import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  Vendor({
      this.shopName,
      this.ownerName,
      this.mobile,
      this.pinCode,
      this.address,
      this.country,
      this.state,
      this.city,
      this.uid,
      this.shopState,
      this.approved,
      this.shopImage,
      this.time,
      this.openTime,
      this.closeTime,
      this.weeklyOffDay,
      this.regPaymentId,
      this.regPaymentSig,
      this.rentalSubMode,
      this.vendorId,
      this.deliveryAreas,
  });

  Vendor.fromJson(Map<String, Object?> json)
      : this(
      shopName: json['shopName']! as String,
    ownerName: json['ownerName']! as String,
    mobile: json['mobile']! as String,
    pinCode: json['pinCode']! as String,
    address: json['address']! as String,
    country: json['country']! as String,
    state: json['state']! as String,
    city: json['city']! as String,
    uid: json['uid']! as String,
    shopState: json['shopState']! as String,
    approved: json['approved']! as bool,
    shopImage: json['shopImage']! as String,
    time: json['time']! as Timestamp,
    openTime: json['openTime']! as Map,
    closeTime: json['closeTime']! as Map,
    weeklyOffDay: json['weeklyOffDay']! as String,
    regPaymentId: json['regPaymentId']! as String,
    regPaymentSig: json['regPaymentSig']! as String,
    rentalSubMode: json['rentalSubMode']! as String,
    vendorId: json['vendorId']! as String,
    deliveryAreas: json['deliveryAreas']! as List<dynamic>,
  );

  final String? shopImage;
  final String? shopName;
  final String? ownerName;
  final String? mobile;
  final String? pinCode;
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? uid;
  final String? shopState;
  final bool? approved;
  final Timestamp? time;
  final Map? openTime;
  final Map? closeTime;
  final String? weeklyOffDay;
  final String? regPaymentId;
  final String? regPaymentSig;
  final String? rentalSubMode;
  final String? vendorId;
  final List<dynamic>? deliveryAreas;

  Map<String, Object?> toJson() {
    return {
      'shopName': shopName,
      'ownerName': ownerName,
      'mobile': mobile,
      'pinCode': pinCode,
      'landmark': address,
      'country': country,
      'state': state,
      'city': city,
      'uid': uid,
      'shopState': shopState,
      'approved': approved,
      'shopImage': shopImage,
      'time': time,
      'openTime': openTime,
      'closeTime': closeTime,
      'weeklyOffDay': weeklyOffDay,
      'regPaymentId': regPaymentId?? '',
      'regPaymentSig': regPaymentSig?? '',
      'rentalSubMode': rentalSubMode,
      'vendorId': vendorId,
      'deliveryAreas': deliveryAreas
    };
  }
}