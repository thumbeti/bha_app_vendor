import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/vendor_provider.dart';
import '../widget/custom_drawer.dart';
import '../widget/orders/received_orders.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _vendorData = Provider.of<VendorProvider>(context);
    if(_vendorData.doc == null) {
      _vendorData.getVendorData();
    }
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Dashboard'),
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
                child: Text('Received Orders'),
              ),
              Tab(
                child: Text('Completed Orders'),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
          ReceivedOrders(),
          ReceivedOrders(),
        ],
        ),
      ),
    );
  }
}
