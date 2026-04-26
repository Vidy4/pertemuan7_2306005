import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ProductPage()));
}

class Product {
  String name;
  int price;
  String imageUrl; // tambahan

  Product({
    required this.name,
    required this.price,
    this.imageUrl = "", // default kosong
  });
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  List<Product> products = [
    Product(
      name: "Laptop",
      price: 100000,
      imageUrl:
          "https://picsum.photos/id/2/367/267", 
    ),
    Product(
      name: "HP",
      price: 200000,
      imageUrl:
          "https://picsum.photos/id/160/367/267",
    ),
    Product(
      name: "Kamera",
      price: 300000,
      imageUrl:
          "https://picsum.photos/id/250/367/267",
    ),
    Product(
      name: "Tablet",
      price: 3000000,
      imageUrl:
          "https://picsum.photos/id/341/367/267",
    ),
  ];

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void updateProduct(int index, Product product) {
    setState(() {
      products[index] = product;
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void showForm({Product? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );
    TextEditingController imageController = TextEditingController(
      text: product?.imageUrl ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? "Tambah Product" : "Edit Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nama Product"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Harga Product"),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: "Link Gambar"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text("Simpan"),
              onPressed: () {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  return;
                }

                final newProduct = Product(
                  name: nameController.text,
                  price: int.tryParse(priceController.text) ?? 0,
                  imageUrl: imageController.text,
                );

                if (product == null) {
                  addProduct(newProduct);
                } else {
                  updateProduct(index!, newProduct);
                }

                Navigator.pop(context);

                // optional dispose
                nameController.dispose();
                priceController.dispose();
                imageController.dispose();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD App Products"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: products[index].imageUrl.isNotEmpty
                ? Image.network(
                    products[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image);
                    },
                  )
                : Icon(Icons.image),
            title: Text(products[index].name),
            subtitle: Text("Rp ${products[index].price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () =>
                      showForm(product: products[index], index: index),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => deleteProduct(index),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
