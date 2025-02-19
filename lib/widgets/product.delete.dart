import 'package:flutter/material.dart';
import 'package:product_firestore_app/models/product_model.dart';
import 'package:product_firestore_app/service/database.dart';

class DeleteProductPage extends StatefulWidget {
  final ProductModel product;

  const DeleteProductPage({super.key, required this.product});

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final Database db = Database.myInstance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ยืนยันการลบสินค้า',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'คุณต้องการลบ "${widget.product.productName}" หรือไม่?',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            'ราคา: ${widget.product.price.toString()} บาท',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteProduct(product: widget.product);
              if (context.mounted) {
                Navigator.pop(context, true); // ส่งค่า true กลับไปถ้าลบสำเร็จ
              }
            },
            child: const Text('ลบสินค้า', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false); // ปิด popup โดยไม่ลบ
            },
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }
}
