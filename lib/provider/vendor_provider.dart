import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services.dart';
import '../model/vendor.dart';

class VendorProvider with ChangeNotifier {

  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot? doc;
  Vendor? vendor;

  getVendorData() {
   _services.vendors.doc(_services.user!.uid).get().then((document){
     doc=document;
     vendor = Vendor.fromJson(document.data() as Map<String, dynamic>);
     notifyListeners();
   });
  }
}