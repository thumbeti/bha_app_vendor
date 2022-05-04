import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../widget/add_product/general_tab.dart';
import '../widget/custom_drawer.dart';

class AddProductScreen extends StatelessWidget {
  static const String id = 'add_product_screen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add new products'),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            //indicatorColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4,
                color: Colors.black,
                  style: BorderStyle.solid,
              ),
            ),
            tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Inventory'),
              ),
              Tab(
                child: Text('Shipping'),
              ),
              Tab(
                child: Text('Orders'),
              ),
              Tab(
                child: Text('Images'),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            GeneralTab(),
            Center(child: Text('Inventory Tab'),),
            Center(child: Text('Shipping Tab'),),
            Center(child: Text('Orders Tab'),),
            Center(child: Text('Images Tab'),),
          ],
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                child: Text('Save Product'),
                onPressed: (){
                  print(_provider.productData!['productName']);
                  print(_provider.productData!['regularPrice']);
                },),
          ),
        ],
      ),
    );
  }
}
