import 'package:bha_app_vendor/firebase_services.dart';
import 'package:bha_app_vendor/widget/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../model/product_model.dart';

class UnPublishedProduct extends StatelessWidget {
  final String? shopName;
  const UnPublishedProduct({Key? key, this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(shopName, false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Center(child: const CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
        if(snapshot.docs.isEmpty){
          return Center(child: Text('No Un Published Products.'),);
        }
        return ProductCard(snapshot: snapshot);
      },
    );
  }
}
