import 'package:bha_app_vendor/widget/products/published_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/vendor_provider.dart';
import '../widget/custom_drawer.dart';
import '../widget/products/un_published.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product_screen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          elevation: 0,
          bottom: TabBar(
            //isScrollable: true,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            tabs: [
              Tab(
                child: Text('Un Published'),
              ),
              Tab(
                child: Text('Published'),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            UnPublishedProduct(shopName: _vendorData.vendor!.shopName),
            PublishedProduct(shopName: _vendorData.vendor!.shopName),
          ],
        ),
      ),
    );
  }
}
