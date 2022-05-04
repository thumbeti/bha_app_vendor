import 'package:flutter/material.dart';

import '../widget/custom_drawer.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product_screen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('Product Screen'),
      ),
    );
  }
}
