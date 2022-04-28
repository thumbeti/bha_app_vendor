import 'package:bha_app_vendor/firebase_services.dart';
import 'package:bha_app_vendor/screens/login_screen.dart';
import 'package:bha_app_vendor/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/vendor.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _services.vendor.doc(_services.user!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:CircularProgressIndicator(),
            );
          }
          if(!snapshot.data!.exists){
            return const RegistrationScreen();
          }
          Vendor vendor = Vendor.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if(vendor.approved == true) {
            return const HomeScreen();
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //vendor.businessName==null ? Text("") : Text(vendor.businessName!,),
                  const SizedBox(height: 10,),
                  Text('Hi '+ vendor.ownerName!+',', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  Text('Your vendor ID: '+ vendor.vendorId!, style: const TextStyle(fontSize: 20),),
                  const SizedBox(height: 10,),
                  const Text(
                    'Thanks for registering with Bha App.\nBha App admin will contact you soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute (
                          builder: (BuildContext context) => const LoginScreen(),
                        ),);
                      });
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/*
Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thanks for registering with Bha App.\nBha App admin will contact you soon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute (
                      builder: (BuildContext context) => const LoginScreen(),
                    ),);
                  });
                },
              )
            ],
          ),
        ),
      ),
 */