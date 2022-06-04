import 'package:bha_app_vendor/screens/product_screen.dart';
import 'package:bha_app_vendor/widget/add_product/inventory_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../firebase_services.dart';
import '../provider/product_provider.dart';
import '../provider/vendor_provider.dart';
import '../widget/add_product/general_tab.dart';
import '../widget/add_product/shipping_tab.dart';
import '../widget/custom_drawer.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = 'add_product_screen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _vendor = Provider.of<VendorProvider>(context);
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 2,
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
              ],
            ),
          ),
          drawer: CustomDrawer(),
          body: TabBarView(
            children: [
              GeneralTab(),
              InventoryTab(),
              //ShippingTab(),
              //Center(child: Text('Attributes'),),
            ],
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Save Product'),
                onPressed: () {
                  if (_provider.prodImage == null) {
                    _services.scaffold(context, 'Product image not selected.');
                    return;
                  }
                  print(_provider.productData);
                  if (_formKey.currentState!.validate()) {
                    _provider.getFormData(seller: {
                      'name': _vendor.vendor!.shopName,
                      'uid': _services.user!.uid,
                      'vid': _vendor.vendor!.vendorId,
                    });
                    EasyLoading.show(status: 'Please wait...');
                    _services
                        .uploadImage(_provider.prodImage,
                            'products/${_vendor.vendor!.shopName}/${_provider.productData!['productName']}/productImage.jpg')
                        .then((String? url) {
                      if (url != null) {
                        setState(() {
                          _provider.getFormData(
                            productImageUrl: url,
                          );
                        });
                      }
                    }).then((value) async {
                      await _services
                          .saveToDB(
                              context: context, data: _provider.productData)
                          .then((value) {
                        EasyLoading.dismiss();
                        setState(() {
                          _provider.clearProductData();
                        });
                        return Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const ProductScreen(),
                          ),
                        );
                      });
                    });
                  } else {
                    _services.scaffold(
                        context, "Validate failed while Saving.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
