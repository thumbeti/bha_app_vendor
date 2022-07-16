import 'package:cloud_firestore/cloud_firestore.dart';

class Executive{
  Executive(
      {this.name,
        this.email,
        this.mobile,
        this.ID,});

  Executive.fromJson(Map<String, Object?> json)
      : this(
    name: json['name']==null? null : json['name']! as String,
    email: json['email']==null? null : json['email']! as String,
    mobile: json['mobile']==null? null : json['mobile']! as String,
    ID: json['ID']==null? null : json['ID']! as String,
  );

  final String? name;
  final String? email;
  final String? mobile;
  final String? ID;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile' : mobile,
      'ID' : ID,
    };
  }
}

executiveQuery(String? shopName, bool? approved) {
  return FirebaseFirestore.instance.collection('executives')
      .orderBy('timeAdded')
      .withConverter<Executive>(
    fromFirestore: (snapshot, _) => Executive.fromJson(snapshot.data()!),
    toFirestore: (executive, _) => executive.toJson(),);
}