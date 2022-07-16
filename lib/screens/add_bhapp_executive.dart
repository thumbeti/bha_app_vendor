import 'dart:math';

import 'package:bha_app_vendor/screens/list_bhaapp_executives.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../firebase_services.dart';

class AddBhaAppExecutive extends StatefulWidget {
  const AddBhaAppExecutive({Key? key}) : super(key: key);
  static const String id = 'add_BhaApp_executive';

  @override
  State<AddBhaAppExecutive> createState() => _AddBhaAppExecutiveState();
}

class _AddBhaAppExecutiveState extends State<AddBhaAppExecutive> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();

  String genExecutiveId() {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
    //String vid = cityValue!.substring(0,3)+'_'+List.generate(5, (index) => _chars[r.nextInt(_chars.length)]).join();
    String eid = List.generate(4, (index) => _chars[r.nextInt(_chars.length)]).join();
    return eid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Add BhaApp Executive'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
            child: Column(
              children: [
                _services.formField(
                    controller: _name,
                    label: 'Executive Name',
                    inputType: TextInputType.text,
                    maxLength: 100,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Executive name';
                      }
                    }),
                TextFormField(
                  controller: _contactNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact number',
                    prefix: Text('+91'),
                  ),
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Contact number';
                    }
                  },
                ),
                _services.formField(
                    controller: _email,
                    label: 'Email',
                    inputType: TextInputType.emailAddress,
                    maxLength: 100,
                    validator: (value) {
                      /*
                            if (value!.isEmpty) {
                              return 'Enter Email address';
                            }*/
                      if(value!.isNotEmpty) {
                        final bool isValid = EmailValidator.validate(value);
                        if (isValid == false) {
                          return 'Invalid Email';
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //save to DB
                        _services.addExecutive(
                          data: {
                            'name' : _name.text,
                            'mobile' : '+91${_contactNumber.text}',
                            'email': _email.text,
                            'ID' : genExecutiveId(),
                            'timeAdded' : DateTime.now(),
                          },
                            context: context,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ListBhaAppExecutives(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
