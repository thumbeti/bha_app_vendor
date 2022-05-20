import 'package:bha_app_vendor/widget/products/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../firebase_services.dart';
import '../../model/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, this.snapshot}) : super(key: key);
    final FirestoreQueryBuilderSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final FirebaseServices services = FirebaseServices();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: snapshot!.docs.length,
          itemBuilder: (context, index) {
            Product product = snapshot!.docs[index].data();
            String id = snapshot!.docs[index].id;
            double discount = 0;
            if (product.regularPrice != null && product.salesPrice != null) {
              discount = (product.regularPrice! - product.salesPrice!) /
                  product.regularPrice! *
                  100;
            }
            return Slidable(
              child: InkWell(
                onTap: () {
                  Navigator.push (
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) => ProductDetailsScreen(
                        product: product,
                        productId: id,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Row(
                    children: [
                      Container(
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                                imageUrl: product.productImageUrl!),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.productName!),
                            Row(
                              children: [
                                if (product.salesPrice != null)
                                  Text('\u{20B9}${services
                                      .formattedNumber(product.salesPrice)}'
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('\u{20B9}${services
                                    .formattedNumber(product.regularPrice)}',
                                  style: TextStyle(
                                      decoration: product.salesPrice != null
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: Colors.red),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${discount.toInt()}%',
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (context){
                      services.products.doc(id).delete();
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (context){
                      services.products.doc(id).update({
                        'approved': product.approved==false? true : false
                      });
                    },
                    backgroundColor: product.approved==false? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    icon: Icons.approval,
                    label: product.approved==false? 'Approve' : 'Inactive',
                  ),
                ],
              ),
            );
          }),
    );
  }
}