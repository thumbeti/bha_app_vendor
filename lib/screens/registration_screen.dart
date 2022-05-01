import 'dart:io';
import 'dart:math';

import 'package:bha_app_vendor/firebase_services.dart';
import 'package:bha_app_vendor/screens/landing_screen.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  static List<String?> deliveryAreasList = [null];

  late Razorpay _razorpay;
  bool testMode = true;
  int modeClickCount = 0;

  final _shopName = TextEditingController();
  final _ownerName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();
  final _pinCode = TextEditingController();
  final _address = TextEditingController();

  String? _bName;
  String? _rentalSubMode = rentalSubModes[1];
  String? _weeklyOffDay = weeklyOffDay[0];
  XFile? _shopImage;
  String? _shopImageUrl;

  String? countryValue;
  String? stateValue;
  String? cityValue;

  String? _regPaymentId;
  String? _regPaymentSig;

  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay openTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay closeTime = const TimeOfDay(hour: 20, minute: 0);

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    //deliveryAreasList.insert(0, '');
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
    _razorpay.clear();
  }

  Widget _formField({
    TextEditingController? controller,
    String? label,
    TextInputType? type,
    String? prefix,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefix: Text(prefix ?? ''),
      ),
      //maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: (value) {
        if (controller == _shopName) {
          setState(() {
            _bName = value;
          });
        }
      },
    );
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold(message) {
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

  Map timeOfDayToFirebase(TimeOfDay timeOfDay) {
    return {'hour': timeOfDay.hour, 'minute': timeOfDay.minute};
  }

  TimeOfDay firebaseToTimeOfDay(Map data) {
    return TimeOfDay(hour: data['hour'], minute: data['minute']);
  }

  String genVendorId() {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    //String vid = cityValue!.substring(0,3)+'_'+List.generate(5, (index) => _chars[r.nextInt(_chars.length)]).join();
    String vid = _pinCode.text+'_'+List.generate(4, (index) => _chars[r.nextInt(_chars.length)]).join();
    return vid;
  }

  void finishRegistration() async {
    termsAndConditionsDialog(context);
    //openCheckout();
    _saveToDB();
  }

  _saveToDB() {
    EasyLoading.show(status: 'Please wait..');
    _services
        .uploadImage(_shopImage, 'vendors/${_services.user!.uid}/shopImage.jpg')
        .then((String? url) {
      if (url != null) {
        setState(() {
          _shopImageUrl = url;
        });
      }
    }).then((value) {
      _services.addVendor(data: {
        'shopImage': _shopImageUrl,
        'shopName': _shopName.text,
        'ownerName': _ownerName.text,
        'mobile': '+91${_contactNumber.text}',
        'pinCode': _pinCode.text,
        'address': _address.text,
        'country': countryValue,
        'state': stateValue,
        'city': cityValue,
        'uid': _services.user!.uid,
        'shopState': 'NEW',
        'approved': false,
        'time': DateTime.now(),
        'openTime': timeOfDayToFirebase(openTime),
        'closeTime': timeOfDayToFirebase(closeTime),
        'weeklyOffDay': _weeklyOffDay,
        'regPaymentId': _regPaymentId?? 'noPaymentId',
        'regPaymentSig': _regPaymentSig?? 'noPaymentSig',
        'rentalSubMode': _rentalSubMode,
        'vendorId': genVendorId(),
        //'tinNumber':_gstNumber.text.isEmpty? null : _gstNumber.text,
      }).then((value) {
        EasyLoading.dismiss();
        Navigator.pop(context);
      });
    });
  }

  Future<void> _selectTime(BuildContext context, String openClose) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        if (openClose.compareTo('open') == 0) {
          openTime = timeOfDay;
        } else {
          closeTime = timeOfDay;
        }
      });
    }
  }

//  num fac = pow(10, 2);
  void openCheckoutForApp() async {
    int priceInPaise = (oneTimeRegistrationFee * 100).round();
    var options = {
      'key': testMode ? "rzp_test_iN0mm4sTh9A0YI" : "rzp_live_lAJGHfpfAKDzER",
      'amount': priceInPaise,
      'name': 'Bha App',
      'description': 'Payment for registration.',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '+91${_contactNumber.text}', 'email': _email.text},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      print('Amount: ' + priceInPaise.toString());
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _regPaymentId = response.paymentId!;
      _regPaymentSig = response.signature!;
    });
    print('Success Response: $response');
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    openCheckoutForApp();
  }

  Future<dynamic> termsAndConditionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terms and Conditions'),
            content: SelectableText(termsAndConditions),
            scrollable: true,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('I do not agree!'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.grey,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(
                width: 10,
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  //finishRegistration();
                },
                child: const Text('I agree!'),
                style: TextButton.styleFrom(
                  //primary: buttonTxt,
                  //backgroundColor: buttonBg,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    _shopImage == null
                        ? Container(
                            color: Colors.blue,
                            height: 200,
                            child: TextButton(
                              child: Center(
                                child: Text('Tap to add shop image.',
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 15)),
                              ),
                              onPressed: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _shopImage = value;
                                  });
                                });
                              },
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _shopImage = value;
                                });
                              });
                            },
                            child: Container(
                              height: 240,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  opacity: 100,
                                  image: FileImage(
                                    File(_shopImage!.path),
                                  ),
                                  //image: FileImage(File(_shopImage!.path),),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 100,
                      child: AppBar(
                        title: Image.asset(
                          "assets/images/bha_app_logo.png",
                          fit: BoxFit.contain,
                          height: 25,
                        ),
                        toolbarHeight: 88,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(
                            icon: Icon(Icons.exit_to_app),
                            color: Colors.black,
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /* Add LOGO if needed
                            InkWell(
                              onTap: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _logo = value;
                                  });
                                });
                              },
                              child: Card(
                                //elevation: 4,
                                color: Colors.transparent,
                                child: _logo == null
                                    ? const SizedBox(
                                        height: 50,
                                        width: 50,
                                        //child: Center(child: Text('+')),
                                        child: Center(child: Text('')),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Image.file(
                                            File(_logo!.path),
                                          ),
                                        ),
                                      ),
                              ),
                            ), */
                            Text(
                              _bName == null ? '' : _bName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  modeClickCount++;
                                  if (modeClickCount > 5) {
                                    modeClickCount = 0;
                                    testMode = !testMode;
                                  }
                                });
                              },
                              child: testMode
                                  ? const Text(
                                      "Test",
                                    )
                                  : const Text(
                                      "Live",
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                child: Column(
                  children: [
                    _formField(
                        controller: _shopName,
                        label: 'Shop Name',
                        type: TextInputType.text,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Shop name';
                          }
                        }),
                    _formField(
                        controller: _ownerName,
                        label: 'Owner Name',
                        type: TextInputType.text,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Owner name';
                          }
                        }),
                    _formField(
                        controller: _contactNumber,
                        label: 'Contact number',
                        type: TextInputType.phone,
                        maxLength: 10,
                        prefix: '+91',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Contact number';
                          }
                        }),
                    _formField(
                        controller: _email,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email address';
                          }
                          final bool isValid = EmailValidator.validate(value);
                          if (isValid == false) {
                            return 'Invalid Email';
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text('Shop Hours:'),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                _selectTime(context, 'open');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              child: Text(
                                openTime.hour.toString().padLeft(2, "0") +
                                    ":" +
                                    openTime.minute.toString().padLeft(2, "0"),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            //Text(openTime.hour.toString() + ":" + openTime.minute.toString()),
                            const Text("Open"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                _selectTime(context, 'close');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              child: Text(
                                closeTime.hour.toString().padLeft(2, "0") +
                                    ":" +
                                    closeTime.minute.toString().padLeft(2, "0"),
                                style: const TextStyle(color: Colors.white),
                              ),
                              //child: const Text("Close"),
                            ),
                            //Text(closeTime.hour.toString() + ":" + closeTime.minute.toString()),
                            const Text("Close"),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Rental Subscription : '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _rentalSubMode,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Rental mode';
                                }
                              },
                              hint: const Text('Select Rental mode'),
                              items: rentalSubModes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _rentalSubMode = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Weekly off day : '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _weeklyOffDay,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select weekly off day';
                                }
                              },
                              hint: const Text('Select day'),
                              items: weeklyOffDay.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _weeklyOffDay = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    _formField(
                        controller: _address,
                        label: 'Address',
                        type: TextInputType.text,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Address';
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add Delivery Areas:', style: TextStyle(fontSize: 20),),
                        Container(),
                      ],
                    ),
                    ..._getDeliveryAreas(),
                    const SizedBox(
                      height: 10,
                    ),

                    ///Adding CSC Picker Widget in app
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.DISABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          //borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "*Country",
                      stateDropdownLabel: "*State",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: DefaultCountry.India,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),
                    _formField(
                        controller: _pinCode,
                        label: 'PIN code',
                        type: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter PIN code';
                          }
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Registration charges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  const Text(
                    'Registration fee:',
                    style: TextStyle(
                      fontFamily: 'CircularStd-Medium',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\u{20B9} ' + oneTimeRegistrationFee.toStringAsFixed(2),
                    style: TextStyle(
                      fontFamily: 'CircularStd-Bold',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                      'This Includes One time setup,\nTwo Posters, and One T-Shirt'),
                ],
              ),
            ],
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
                      if (_shopImage == null) {
                        _scaffold('Shop Image not seleted');
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        if (countryValue == null ||
                            stateValue == null ||
                            cityValue == null) {
                          _scaffold('Select address field completely');
                          return;
                        }
                        //onPressed: _saveToDB,
                        //onPressed: () => termsAndConditionsDialog(context),
                        finishRegistration();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const LandingScreen(),
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

  /// get delivery areas text-fields
  List<Widget> _getDeliveryAreas(){
    List<Widget> areasTextFields = [];
    print('Siva: ' + deliveryAreasList.toString());
    for(int i=0; i<deliveryAreasList.length; i++){
      areasTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: DeliveryAreas(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                //_addRemoveButton(i == deliveryAreasList.length-1, i),
                _addRemoveButton(i == 0, i),
              ],
            ),
          )
      );
    }
    return areasTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          deliveryAreasList.insert(index, '');
        }
        else deliveryAreasList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

}

class DeliveryAreas extends StatefulWidget {
  final int index;
  DeliveryAreas(this.index);
  //const DeliveryAreas({Key? key}) : super(key: key);
  @override
  State<DeliveryAreas> createState() => _DeliveryAreasState();
}

class _DeliveryAreasState extends State<DeliveryAreas> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _nameController.text = _RegistrationScreenState.deliveryAreasList[widget.index] ?? '';
    });

    return TextFormField(
      //autovalidateMode: AutovalidateMode.always,
      controller: _nameController,
      onChanged: (v) => _RegistrationScreenState.deliveryAreasList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter delivery area.'
      ),
      validator: (String? v){
        print('RAM:<' + v.toString()+ '>');
        //if(v!.length < 2) return 'Please enter something valid';
        if(v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

