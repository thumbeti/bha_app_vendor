import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/vendor_provider.dart';
import '../widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _vendorData = Provider.of<VendorProvider>(context);
    if(_vendorData.doc == null) {
      _vendorData.getVendorData();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Dashboard'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('Dashboard', style: TextStyle(fontSize: 22),),
      ),
    );
  }
}
