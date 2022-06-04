import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  Vendor({
      this.shopName,
      this.ownerName,
      this.gstNumber,
      this.mobile,
      this.pinCode,
      this.address,
      this.email,
      this.country,
      this.state,
      this.city,
      this.uid,
      this.shopState,
      this.approved,
      this.loadDefaultProducts,
      this.shopImage,
      this.time,
      this.openTime,
      this.closeTime,
      this.weeklyOffDay,
      this.shopType,
      this.loadProductType,
      this.regPaymentId,
      this.regPaymentSig,
      this.vendorId,
      this.deliveryAreas,
      this.whatsAppNum,
      this.representativeID,
      this.termsAndConditions,
      this.cgst,
      this.sgst,
      this.igst,
      this.invoice,
  });

  Vendor.fromJson(Map<String, Object?> json)
      : this(
      shopName: json['shopName']! as String,
    ownerName: json['ownerName']! as String,
    gstNumber: json['gstNumber']! as String,
    mobile: json['mobile']! as String,
    pinCode: json['pinCode']! as String,
    address: json['address']! as String,
    email: json['email']! as String,
    country: json['country']! as String,
    state: json['state']! as String,
    city: json['city']! as String,
    uid: json['uid']! as String,
    shopState: json['shopState']! as String,
    approved: json['approved']! as bool,
    loadDefaultProducts: json['loadDefaultProducts'] as bool,
    shopImage: json['shopImage']! as String,
    time: json['time']! as Timestamp,
    openTime: json['openTime']! as Map,
    closeTime: json['closeTime']! as Map,
    weeklyOffDay: json['weeklyOffDay']! as String,
    shopType: json['shopType']! as String,
    loadProductType: json['loadProductType']! as String,
    regPaymentId: json['regPaymentId']! as String,
    regPaymentSig: json['regPaymentSig']! as String,
    vendorId: json['vendorId']! as String,
    deliveryAreas: json['deliveryAreas']! as List<dynamic>,
    whatsAppNum: json['whatsAppNum']! as String,
    representativeID: json['representativeID']! as String,
    termsAndConditions: json['termsAndConditions']! as String,
    cgst:json['cgst']! as double,
    sgst:json['sgst']! as double,
    igst:json['igst']! as double,
    invoice:json['invoice']! as String,
  );

  final String? shopImage;
  final String? shopName;
  final String? ownerName;
  final String? gstNumber;
  final String? mobile;
  final String? pinCode;
  final String? address;
  final String? email;
  final String? country;
  final String? state;
  final String? city;
  final String? uid;
  final String? shopState;
  final bool? approved;
  final bool? loadDefaultProducts;
  final Timestamp? time;
  final Map? openTime;
  final Map? closeTime;
  final String? weeklyOffDay;
  final String? shopType;
  final String? loadProductType;
  final String? regPaymentId;
  final String? regPaymentSig;
  final String? vendorId;
  final List<dynamic>? deliveryAreas;
  final String? whatsAppNum;
  final String? representativeID;
  final String? termsAndConditions;
  final double? cgst;
  final double? sgst;
  final double? igst;
  final String? invoice;

  Map<String, Object?> toJson() {
    return {
      'shopName': shopName,
      'ownerName': ownerName,
      'gstNumber': gstNumber,
      'mobile': mobile,
      'pinCode': pinCode,
      'address': address,
      'email': email,
      'country': country,
      'state': state,
      'city': city,
      'uid': uid,
      'shopState': shopState,
      'approved': approved,
      'loadDefaultProducts' : loadDefaultProducts,
      'shopImage': shopImage,
      'time': time,
      'openTime': openTime,
      'closeTime': closeTime,
      'weeklyOffDay': weeklyOffDay,
      'shopType': shopType,
      'loadProductType': loadProductType,
      'regPaymentId': regPaymentId?? '',
      'regPaymentSig': regPaymentSig?? '',
      'vendorId': vendorId,
      'deliveryAreas': deliveryAreas,
      'whatsAppNum':whatsAppNum,
      'representativeID': representativeID,
      'termsAndConditions': termsAndConditions,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'invoice': invoice,
    };
  }
}