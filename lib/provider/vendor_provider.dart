import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services.dart';

class VendorProvider with ChangeNotifier {

  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot? doc;

  getVendorData() {
   _services.vendor.doc(_services.user!.uid).get().then((document){
     doc=document;
     notifyListeners();
   });
  }
}