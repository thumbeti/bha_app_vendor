import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'model/vendor.dart';

class FirebaseServices{
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  final CollectionReference mainCategories = FirebaseFirestore.instance.collection('mainCategories');
  final CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategories');
  final CollectionReference products = FirebaseFirestore.instance.collection('products');
  final CollectionReference sendEmail = FirebaseFirestore.instance.collection('mail');
  final CollectionReference executives = FirebaseFirestore.instance.collection('executives');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadImage(XFile? file, String? reference) async {
    if(file != null) {
      File _file = File(file.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref(reference);
      await ref.putFile(_file);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } else {
      return null;
    }
  }

  Future<String> getImageURL(String? reference) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(reference);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return vendors.doc(user!.uid)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addExecutive({Map<String, dynamic>? data, BuildContext? context}) {
    // Call the user's CollectionReference to add a new user
    return executives
        .add(data)
        .then((value) => scaffold(context,"Executive Added with ID: ${data!['ID']}"))
        .catchError((error) => scaffold(context,"Failed to add executive: $error"));
  }

  Future<void> saveToDB({Map<String, dynamic>? data, BuildContext? context}) {
    scaffold(context,"Saving..");
    return products
        .add(data)
        .then((value) => scaffold(context,"Saved"))
        .catchError((error) => scaffold(context,"Failed to save: $error"));
  }

  void loadCommonProducts(Vendor? vendor) async {
    Map<String, dynamic>? productData = {'approved': false,
      'availableInStock': true,
      'manageInventory': false,
      'chargeShipping': false,
      'priceUnit': units[0],
      'taxStatus': TAX_STATUS[0],
      'category': 'Groceries',
      'mainCategory': 'Meat',
      'seller': {
      'name' : vendor!.shopName,
      'uid' : user!.uid,
      'vid' : vendor.vendorId,
      },
    };
    EasyLoading.show(status: 'Loading default products..');
    //Get all Chicken products.
    List<Map<String, dynamic>> prodList = getCommonProducts(vendor.loadProductType!);
    for(Map<String, dynamic> prod in prodList) {
      String imageURL = await getImageURL(
          'products/BhaAppCommonImages/${prod['PicDir']}/${prod['PicName']}');

      productData['sku'] =  DateTime.now().millisecondsSinceEpoch.toString();
      productData['productName'] = prod['name'];
      productData['productDescription'] = prod['desc'];
      productData['productImageUrl'] = imageURL;
      productData['regularPrice'] = int.parse(prod['KGPrice']);
      productData['salesPrice'] = int.parse(prod['KGPrice']);
      productData['subCategory'] = prod['subCategory'];

      if(prod['subCategory'] == 'Fish') {
        productData['attributes'] = {
          'type' : prod['fishCategory'],
        };
      }
      if(prod['subCategory'] == 'HandyMan') {
        productData['category'] = 'Services';
        productData['mainCategory'] = 'HomeServices';
        productData['subCategory'] = prod['subCategory'];
        productData['priceUnit'] = units[8];
      }
      await products.add(productData);
    }
    EasyLoading.dismiss();
  }

  scaffold(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }

  launchWhatsApp({String? phoneNumber, String? msg}) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: msg,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    //await launchUrl('$link');
    await launch('$link');
  }

  sendEmailForRegistration({
    String? vendorEmail,
    String? msg
  }) async {
    print('In sendEmailForRegistration');
    await sendEmail.add(
      {
        'to': "${vendorEmail}",
        'cc': 'info@bhaap.com',
        'bcc': ['thumbeti@gmail.com'],
        //'bcc': ['thumbeti@gmail.com', 'tbrahma@yahoo.com'],
        'message': {
          'subject': "Thanks for registering with BhaApp",
          'text': '${msg}',
        }
      },
    ).then(
          (value) {
        print("Queued email for delivery.");
      },
    );
    print('Email is sent');
  }

  String formInvoice({String? vendorName, String? address, String? paymentID,
    String? gstNo, String? regFee, String? cgstFee, String? sgstFee,
    String? igstFee, String? total,
    int? cgst, int?sgst, int? igst, String? vendorId}){
    String dateString = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    return 'T A X I N V O I C E\n'
        '----------------------------\n'
        'Oxysmart Private Limited\n'
        '#324, 8th Cross,\n'
        'MCECHS Layout Phase 1,\n'
        'Dr Shivaram Karanth Nagar,\n'
        'Bangalore 560 077, Karnataka, India,\n'
        'M: +919071900090, E: info@bhaap.com, CIN: U74999KA2016PTC095005,\n'
        'GSTIN: 29AADCJ7541F1ZG,\n'
        'PAN: AADCJ7541F\n\n'
        'INVOICE TO: ${vendorName}\n'
        'INVOICE NO.: ${paymentID}\n'
        'INVOICE DATE: ${dateString}\n'
        'ADDRESS: ${address}\n\n'
        'Client GST No.: ${gstNo}\n\n'
        'VENDOR CODE: ${vendorId}\n'
        'BhaApp team thanks you and confirms your registration:\n\n'
        'SNo  Activity description       Amount\n'
        '1      Registration..................Rs. ${regFee}\n'
        '        CGST @ ${cgst}%................Rs. ${cgstFee}\n'
        '        SGST @ ${sgst}%................Rs. ${sgstFee}\n'
        '        IGST @ ${igst}%................Rs. ${igstFee}\n'
        '        Total.............................Rs. ${total}\n'
        'Rupees Ninety Nine only.\n\n'
        'Declaration:\n'
        'Certified that all the particulars shown in the above Invoice are true and correct.\n\n'
        'Terms & Conditions:\n'
        'E & O.E.\n'
        '1. Registration charges are not refundable\n'
        '2. Subject to "Karnataka" jurisdiction only\n\n'
        'Thanking you,\n'
        'BhaApp Team\n'
        'Oxysmart Pvt Ltd';
  }

  String formattedNumber(number) {
    var f = NumberFormat("#,##,###", 'en_IN');
    return f.format(number);
  }

  Widget formField({
    TextEditingController? controller,
    String? label,
    String? initValue,
    TextInputType? inputType,
    void Function(String)? onChanged,
    String? prefix,
    int? maxLength,
    bool? readOnly,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      initialValue: initValue,
      decoration: InputDecoration(
        labelText: label,
        prefix: Text(prefix ?? ''),
      ),
      //maxLength: maxLength,
      readOnly: readOnly==null? false : readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Map timeOfDayToFirebase(TimeOfDay timeOfDay) {
    return {'hour': timeOfDay.hour, 'minute': timeOfDay.minute};
  }
}