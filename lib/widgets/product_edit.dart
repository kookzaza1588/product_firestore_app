import 'package:flutter/material.dart';
import 'package:product_firestore_app/models/product_model.dart';
import 'package:product_firestore_app/service/database.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final Database db = Database.myInstance;
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเริ่มต้นจาก product ที่ได้รับ
    nameController.text = widget.product.productName;
    priceController.text = widget.product.price.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'ราคาสินค้า'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // สร้าง object ของ ProductModel ที่ได้รับการแก้ไข
              ProductModel updatedProduct = ProductModel(
                id: widget.product.id,
                productName: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
              );

              // อัปเดตข้อมูลสินค้าใน Firebase
              await db.updateProduct(product: updatedProduct);

              if (context.mounted) {
                // ปิด Popup และส่งผลลัพธ์ว่าอัปเดตสำเร็จ
                Navigator.pop(context, true);
              }
            },
            child: const Text('บันทึกการแก้ไข'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
