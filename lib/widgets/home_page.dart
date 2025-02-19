import 'package:flutter/material.dart';
import 'package:product_firestore_app/models/product_model.dart';
import 'package:product_firestore_app/service/database.dart';
import 'package:product_firestore_app/widgets/product_edit.dart';
import 'package:product_firestore_app/widgets/product_popup.dart'; // import หน้าแก้ไข

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Database db = Database.myInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              // ใช้ showModalBottomSheet เพื่อเปิด Popup สำหรับเพิ่มสินค้า
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => ProductPopup(),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: db.getAllProductStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          List<ProductModel> products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product.productName),
                subtitle: Text('Price: ${product.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // เปิดหน้า EditProductPage ในรูปแบบ Bottom Sheet
                    bool? result = await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => EditProductPage(product: product),
                    );

                    // รีเฟรชข้อมูลเมื่อกลับมาจากหน้าแก้ไข
                    if (result == true) {
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
