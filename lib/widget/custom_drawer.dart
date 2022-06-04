import 'package:bha_app_vendor/screens/landing_screen.dart';
import 'package:bha_app_vendor/screens/vendor_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_services.dart';
import '../provider/vendor_provider.dart';
import '../screens/add_product_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/product_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    final _vendorData = Provider.of<VendorProvider>(context);

    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(menuTitle!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
        child: Column(
      children: [
        Container(
          height: 86,
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              DrawerHeader(
                  child: _vendorData.doc == null
                      ? Text(
                          'Fetching..',
                          style: TextStyle(color: Colors.white),
                        )
                      : Row(
                          children: [
                            //CachedNetworkImage(imageUrl:_vendorData.doc!['logo']),
                            //SizedBox(width: 10),
                            Text(
                              _vendorData.doc!['shopName'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _menu(
                menuTitle: 'Home',
                icon: Icons.home_outlined,
                route: HomeScreen.id,
              ),
              ExpansionTile(
                leading: Icon(Icons.account_tree_outlined),
                title: Text('Products'),
                children: [
                  _menu(
                    menuTitle: 'All Products',
                    route: ProductScreen.id,
                  ),
                  _menu(
                    menuTitle: 'Add Product',
                    route: AddProductScreen.id,
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.account_tree_outlined),
                title: Text('Vendor'),
                children: [
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded),
                    title: Text('Vendor Info'),
                    onTap: () {
                      _vendorData.getVendorData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VendorEditScreen(
                            vendor: _vendorData.vendor,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded),
                    title: Text('In active Vendor (TEST)'),
                    onTap: () {
                      _services.vendors.doc(_services.user!.uid).update({ 'approved': false,});
                      _services.vendors.doc(_services.user!.uid).update({ 'loadDefaultProducts': true,});
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LandingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          title: Text('Sign Out'),
          trailing: Icon(Icons.exit_to_app),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
        ),
      ],
    ));
  }
}
