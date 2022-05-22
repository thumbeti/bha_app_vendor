import 'package:bha_app_vendor/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product(
      {this.productName,
      this.productDescription,
      this.regularPrice,
      this.priceUnit,
      this.salesPrice,
      this.taxStatus,
      this.taxPercentage,
      this.category,
      this.mainCategory,
      this.subCategory,
      this.seller,
      this.sku,
      this.manageInventory,
        this.availableInStock,
      this.soh,
      this.reOrderLevel,
      this.chargeShipping,
      this.shippingCharge,
      this.productImageUrl,
      this.approved});

  Product.fromJson(Map<String, Object?> json)
      : this(
          productName: json['productName']==null? null : json['productName']! as String,
          productDescription: json['productDescription']==null? null : json['productDescription']! as String,
          regularPrice: json['regularPrice']==null? null : json['regularPrice']! as int,
          priceUnit: json['priceUnit']==null? null : json['priceUnit']! as String,
          salesPrice: json['salesPrice']==null? null: json['salesPrice']! as int,
          taxStatus: json['taxStatus']==null? null : json['taxStatus']! as String,
          taxPercentage: json['taxPercentage']==null? null : json['taxPercentage']! as double,
          category: json['category']==null? null : json['category']! as String,
          mainCategory: json['mainCategory']==null? null : json['mainCategory']! as String,
          subCategory: json['subCategory']==null? null : json['subCategory']! as String,
          seller: json['seller']==null? null : json['seller']! as Map,
          sku: json['sku']==null? null : json['sku']! as String,
          manageInventory: json['manageInventory']==null? null : json['manageInventory']! as bool,
          availableInStock: json['availableInStock']==null? null : json['availableInStock']! as bool,
          soh: json['soh']==null? null : json['soh']! as int,
          reOrderLevel: json['reOrderLevel']==null? null : json['reOrderLevel']! as int,
          chargeShipping: json['chargeShipping']==null? null : json['chargeShipping']! as bool,
          shippingCharge: json['shippingCharge']==null? null : json['shippingCharge']! as int,
          productImageUrl: json['productImageUrl']==null? null : json['productImageUrl']! as String,
          approved: json['approved']==null? null : json['approved']! as bool,
        );

  final String? productName;
  final String? productDescription;
  final int? regularPrice;
  final String? priceUnit;
  final int? salesPrice;
  final String? taxStatus;
  final double? taxPercentage;
  final String? category;
  final String? mainCategory;
  final String? subCategory;
  final Map? seller;
  final String? sku;
  final bool? manageInventory;
  final bool? availableInStock;
  final int? soh;
  final int? reOrderLevel;
  final bool? chargeShipping;
  final int? shippingCharge;
  final String? productImageUrl;
  final bool? approved;

  Map<String, Object?> toJson() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'regularPrice': regularPrice,
      'priceUnit': priceUnit,
      'salesPrice': salesPrice,
      'taxStatus': taxStatus,
      'taxPercentage': taxPercentage,
      'category': category,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'seller': seller,
      'sku': sku,
      'manageInventory': manageInventory,
      'availableInStock' : availableInStock,
      'soh': soh,
      'reOrderLevel': reOrderLevel,
      'chargeShipping': chargeShipping,
      'shippingCharge': shippingCharge,
      'productImageUrl': productImageUrl,
      'approved': approved,
    };
  }
}

FirebaseServices _services = FirebaseServices();
productQuery(String? shopName, bool? approved) {
  return FirebaseFirestore.instance.collection('products').where('approved', isEqualTo: approved)
      .where('seller.uid', isEqualTo: _services.user!.uid)
      .orderBy('productName')
      .withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),);
}