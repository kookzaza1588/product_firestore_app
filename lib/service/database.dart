import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_firestore_app/models/product_model.dart';

class Database {
  static Database myInstance = Database();

  Stream<List<ProductModel>> getAllProductStream(){
    var reference = FirebaseFirestore.instance.collection('product');

    Query query = reference.orderBy('id',descending: true);

    var querySnapshot = query.snapshots();

    return querySnapshot.map(
      (snapshot){
        return snapshot.docs.map(
          (doc){
            return ProductModel.formMap(doc.data() as Map<String, dynamic>);
          }).toList();
      });
  }

  Future<void> setProduct({required ProductModel product}) async{
    var reference = FirebaseFirestore.instance.doc('product/${product.id}');
    try {
      await reference.set(product.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct({required ProductModel product}) async {
  var reference = FirebaseFirestore.instance.collection('product').doc(product.id);
  try {
    await reference.delete();
  } catch (e) {
    print('Error deleting product: $e');
    rethrow;
  }
}

  Future<void> updateProduct({required ProductModel product}) async {
  try {
    await FirebaseFirestore.instance
      .collection('product') // ใช้ 'product' ให้ตรงกับ collection ที่เก็บข้อมูล
      .doc(product.id) // ใช้ id ที่ถูกต้องในการระบุ document
      .update({
        'price': product.price, // อัปเดตราคาสินค้า
        'productName': product.productName, // อัปเดตชื่อสินค้า
      });
  } catch (e) {
    print('Error updating product: $e'); // ปรับการแสดงข้อผิดพลาด
    rethrow; // ถ้ามีข้อผิดพลาดให้ throw ใหม่
  }
}

}

