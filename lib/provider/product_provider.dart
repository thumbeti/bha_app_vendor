import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {'approved': false};
  XFile? prodImage;

  getFormData(
      {String? productName,
      String? productDescription,
      int? regularPrice,
      String? priceUnit,
      int? salesPrice,
      String? taxStatus,
      double? taxPercentage,
      String? category,
      String? mainCategory,
      String? subCategory,
      Map<String, dynamic>? seller,
      String? sku,
        bool? manageInventory,
        int? soh,
        int? reOrderLevel,
        bool? chargeShipping,
        int? shippingCharge,
        String? productImageUrl,
      }) {
    if (seller != null) {
      productData!['seller'] = seller;
    }
    if (productName != null) {
      productData!['productName'] = productName;
    }
    if (regularPrice != null) {
      productData!['regularPrice'] = regularPrice;
    }
    if (salesPrice != null) {
      productData!['salesPrice'] = salesPrice;
    }
    if (taxStatus != null) {
      productData!['taxStatus'] = taxStatus;
    }
    if (taxPercentage != null) {
      productData!['taxPercentage'] = taxPercentage;
    }
    if (category != null) {
      productData!['category'] = category;
    }
    if (mainCategory != null) {
      productData!['mainCategory'] = mainCategory;
    }
    if (subCategory != null) {
      productData!['subCategory'] = subCategory;
    }
    if (productDescription != null) {
      productData!['productDescription'] = productDescription;
    }
    if (priceUnit != null) {
      productData!['priceUnit'] = priceUnit;
    }
    if (sku != null) {
      productData!['sku'] = sku;
    }
    if (manageInventory != null) {
      productData!['manageInventory'] = manageInventory;
    }
    if (soh != null) {
      productData!['soh'] = soh;
    }
    if (reOrderLevel != null) {
      productData!['reOrderLevel'] = reOrderLevel;
    }
    if (chargeShipping != null) {
      productData!['chargeShipping'] = chargeShipping;
    }
    if (shippingCharge != null) {
      productData!['shippingCharge'] = shippingCharge;
    }
    if (productImageUrl != null) {
      productData!['productImageUrl'] = productImageUrl;
    }
    notifyListeners();
  }

  clearProductData() {
    productData!.clear();
    productData!['approved']=false;
    prodImage = null;
    notifyListeners();
  }
}
