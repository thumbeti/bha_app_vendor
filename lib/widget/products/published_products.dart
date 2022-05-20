import 'package:bha_app_vendor/widget/products/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../firebase_services.dart';
import '../../model/product_model.dart';

class PublishedProduct extends StatelessWidget {
  final String? shopName;
  const PublishedProduct({Key? key, this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(shopName, true),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Center(child: const CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
        if(snapshot.docs.isEmpty){
          return Center(child: Text('No Products Published yet.'),);
        }
        return ProductCard(snapshot: snapshot,);
      },
    );
  }
}
