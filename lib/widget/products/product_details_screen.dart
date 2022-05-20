import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product? product;
  final String? productId;
  const ProductDetailsScreen({this.product, this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(product!.productName!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
              height: 150,
              child: CachedNetworkImage(imageUrl: product!.productImageUrl!),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: 'Name : ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: product!.productName! , style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: 'Regular price : ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: '\u{20B9} ${product!.regularPrice!.toString()}' , style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: 'Sales price : Rs. ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: '\u{20B9} ${product!.salesPrice!.toString()}' , style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
