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
        stream: _services.vendors.doc(_services.user!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            //_services.scaffold(context, message)
            return const Center(child: Text('Something went wrong!!'));
            //return const RegistrationScreen();
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
            if(vendor.loadDefaultProducts == true) {
              // Loading default products
              _services.loadCommonProducts(vendor);
              _services.vendors.doc(_services.user!.uid).update({ 'loadDefaultProducts': false,});
            }
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
                    'Thanks for registering with BhaApp.\nBhaApp admin will contact you soon.',
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
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  /*
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: Text(
                      'Siva, Approve vendor *${vendor.ownerName!}*..',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //load default products...
                      //_services.loadCommonProducts(vendor);
                      //TODO: Remove this once tested.
                      _services.vendors.doc(_services.user!.uid).update({ 'approved': true,});
                    },
                  )
                   */
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