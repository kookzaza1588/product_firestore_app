import 'package:flutter/material.dart';
import 'package:product_firestore_app/models/product_model.dart';
import 'package:product_firestore_app/service/database.dart';

// ignore: must_be_immutable
class ProductForm extends StatefulWidget {
  ProductModel? product;
  ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  Database db = Database.myInstance;
  var nameController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.product != null){
      nameController.text = widget.product!.productName;
      priceController.text = widget.product!.price.toString();
    }
  }
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.product == null ? 'เพิ่มสินค้า' : 'เเก้ไข ${widget.product!.productName}'),
        TextField(
          controller: nameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
        ),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'ราคาสินค้า'),
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showBtnOk(context),
            const SizedBox(width: 10,),
            showBtnCancel(context)
          ],
          )
      ],
    );
  }
  Widget showBtnOk(BuildContext context){
    return ElevatedButton(
      onPressed: () async{
        String newId = 'PD${DateTime.now().microsecondsSinceEpoch.toString()}';
        await db.setProduct(
          product: ProductModel(
            id: widget.product == null ? newId : widget.product!.id,
            productName: nameController.text, 
            price: double.tryParse(priceController.text) ?? 0, 
            )
          );
        nameController.clear();
        priceController.clear();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }, 
      child: const Text('เพิ่ม')
    );
  }

  Widget showBtnCancel(BuildContext context){
    return ElevatedButton(
      onPressed: (){
        
        Navigator.of(context).pop();
      }, 
      child: const Text('ปิด')
    );
  }
}