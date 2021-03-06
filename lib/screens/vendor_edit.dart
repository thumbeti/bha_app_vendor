import 'dart:io';

import 'package:bha_app_vendor/model/vendor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_validator/gst_validator.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../firebase_services.dart';
import '../provider/vendor_provider.dart';
import 'package:intl/intl.dart';

class VendorEditScreen extends StatefulWidget {
  static const String id = 'vendor_edit';
  final Vendor? vendor;
  const VendorEditScreen({this.vendor, Key? key}) : super(key: key);

  @override
  State<VendorEditScreen> createState() => _VendorEditScreenState();
}

class _VendorEditScreenState extends State<VendorEditScreen> {
  final FirebaseServices _services = FirebaseServices();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  bool _editable = true;
  final _shopName = TextEditingController();
  final _ownerName = TextEditingController();
  final _vendorID = TextEditingController();
  final _contactNumber = TextEditingController();
  final _whatsAppNum = TextEditingController();
  final _email = TextEditingController();
  final _gstNumber = TextEditingController();
  final _address = TextEditingController();
  final _bankAccountNo = TextEditingController();
  final _bankName = TextEditingController();
  final _IFSCcode = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay openTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay closeTime = TimeOfDay(hour: 20, minute: 0);
  String? _weeklyOffDay = weeklyOffDay[0];
  String? _shopState = shopStates[0];

  XFile? _shopImage;
  String? _shopImageUrl;

  XFile? _GSTImage;
  String? _GSTImageUrl;
  XFile? _licenseImage;
  String? _licenseImageUrl;
  XFile? _aadharImage;
  String? _aadharImageUrl;
  XFile? _chequeImage;
  String? _chequeImageUrl;

  @override
  void initState() {
    setState(() {
      _shopName.text = widget.vendor!.shopName!;
      _ownerName.text = widget.vendor!.ownerName!;
      _vendorID.text = widget.vendor!.vendorId!;
      _contactNumber.text = widget.vendor!.mobile!;
      _whatsAppNum.text = widget.vendor!.whatsAppNum!;
      _email.text = widget.vendor!.email!;
      _gstNumber.text = widget.vendor!.gstNumber!;
      openTime = TimeOfDay(
          hour: widget.vendor!.openTime!['hour'],
          minute: widget.vendor!.openTime!['minute']);
      closeTime = TimeOfDay(
          hour: widget.vendor!.closeTime!['hour'],
          minute: widget.vendor!.closeTime!['minute']);
      _weeklyOffDay = widget.vendor!.weeklyOffDay;
      _shopState = widget.vendor!.shopState!;
      _address.text = widget.vendor!.address!;
      _bankAccountNo.text = widget.vendor!.bankDetails!['accountNo']?? '';
      _bankName.text = widget.vendor!.bankDetails!['bankName']?? '';
      _IFSCcode.text = widget.vendor!.bankDetails!['IFSCcode']?? '';
    });
    super.initState();
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
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

  String _convertTo12Hours(TimeOfDay selectedTime) {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
    var dateFormat = DateFormat("h:mm a");
    return dateFormat.format(tempDate);
  }

  updateVendorWithPics(Vendor? vendor) {
    EasyLoading.show(status: 'Please wait..');
    _services
        .uploadImage(
            _chequeImage, 'vendors/${_services.user!.uid}/BankChequeImage.jpg')
        .then((String? url) {
      if (url != null) {
        setState(() {
          _chequeImageUrl = url;
        });
      }
    }).then((value) async {
      _services
          .uploadImage(
              _aadharImage, 'vendors/${_services.user!.uid}/AadharImage.jpg')
          .then((String? url) {
        if (url != null) {
          setState(() {
            _aadharImageUrl = url;
          });
        }
      }).then((value) async {
        _services
            .uploadImage(_licenseImage,
                'vendors/${_services.user!.uid}/LicenseImage.jpg')
            .then((String? url) {
          if (url != null) {
            setState(() {
              _licenseImageUrl = url;
            });
          }
        }).then((value) async {
          _services
              .uploadImage(
                  _GSTImage, 'vendors/${_services.user!.uid}/GSTImage.jpg')
              .then((String? url) {
            if (url != null) {
              setState(() {
                _GSTImageUrl = url;
              });
            }
          }).then((value) async {
            _services
                .uploadImage(
                    _shopImage, 'vendors/${_services.user!.uid}/shopImage.jpg')
                .then((String? url) {
              if (url != null) {
                setState(() {
                  _shopImageUrl = url;
                });
              }
            }).then((value) async {
              await _services.vendors.doc(vendor!.uid).update({
                'shopImage':
                    _shopImageUrl != null ? _shopImageUrl : vendor.shopImage?? null,
                'shopName': _shopName.text,
                'ownerName': _ownerName.text,
                'mobile': _contactNumber.text,
                'whatsAppNum': _whatsAppNum.text,
                'email': _email.text,
                'openTime': _services.timeOfDayToFirebase(openTime),
                'closeTime': _services.timeOfDayToFirebase(closeTime),
                'weeklyOffDay': _weeklyOffDay,
                'shopState': _shopState,
                'gstNumber': _gstNumber.text,
                'gstImage': _GSTImageUrl != null ? _GSTImageUrl : vendor.gstImage?? null,
                'licenseImage': _licenseImageUrl != null? _licenseImageUrl : vendor.licenseImage?? null,
                'aadharImage': _aadharImageUrl != null? _aadharImageUrl : vendor.aadharImage?? null,
                'address': _address.text,
                'bankDetails': {
                  'cheque' : _chequeImageUrl!=null? _chequeImageUrl : vendor.bankDetails!['cheque']?? null,
                  'bankName' : _bankName.text,
                  'accountNo' : _bankAccountNo.text,
                  'IFSCcode' : _IFSCcode.text,
                }
              }).then((value) async {
                setState(() {
                  _editable = true;
                });
                EasyLoading.dismiss();
              });
            });
          });
        });
      });
    });
    return;
  }

  updateVendor(String? uid) {
    EasyLoading.show();
    _services.vendors.doc(uid).update({
      'shopName': _shopName.text,
      'ownerName': _ownerName.text,
      'mobile': _contactNumber.text,
      'whatsAppNum': _whatsAppNum.text,
      'email': _email.text,
      'openTime': _services.timeOfDayToFirebase(openTime),
      'closeTime': _services.timeOfDayToFirebase(closeTime),
      'weeklyOffDay': _weeklyOffDay,
      'shopState': _shopState,
      'gstNumber': _gstNumber.text,
      'address': _address.text,
    }).then((value) {
      setState(() {
        _editable = true;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(_vendorData.vendor!.shopName!),
          actions: [
            _editable
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _editable = false;
                      });
                    },
                    icon: Icon(Icons.edit_outlined),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber)),
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateVendorWithPics(_vendorData.vendor);
                        }
                      },
                    ),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editable,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _shopImage = value;
                          });
                        });
                      },
                      child: _shopImage == null
                          ? Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                  imageUrl: _vendorData.vendor!.shopImage!),
                            )
                          : Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: FileImage(
                                    File(_shopImage!.path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _services.formField(
                        label: 'Shop name',
                        inputType: TextInputType.text,
                        controller: _shopName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Shop name';
                          }
                          return null;
                        }),
                    _services.formField(
                        controller: _ownerName,
                        label: 'Owner Name',
                        inputType: TextInputType.text,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Owner name';
                          }
                          return null;
                        }),
                    _services.formField(
                      controller: _vendorID,
                      label: 'Vendor ID',
                      inputType: TextInputType.text,
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: _gstNumber,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'GST number',
                      ),
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!=null && value.isNotEmpty) {
                          final bool isValid = GSTValidator().isValid(value);
                          if (isValid == false) {
                            return 'Invalid GST Number';
                          }
                        }
                        return null;
                      },
                    ),
                    Text('GST Cerificate'),
                    //GST Certificate
                    InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _GSTImage = value;
                          });
                        });
                      },
                      child: _GSTImage == null
                          ? Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.blue.shade100,
                              child: _vendorData.vendor!.gstImage == null
                                  ? Center(
                                      child: Text('Add GST Certificate.',
                                          style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontSize: 15)),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: _vendorData.vendor!.gstImage!),
                            )
                          : Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: FileImage(
                                    File(_GSTImage!.path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Shop license'),
                    //Shop license
                    InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _licenseImage = value;
                          });
                        });
                      },
                      child: _licenseImage == null
                          ? Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue.shade100,
                        child: _vendorData.vendor!.licenseImage == null
                            ? Center(
                          child: Text('Add Shop license.',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 15)),
                        )
                            : CachedNetworkImage(
                            imageUrl: _vendorData.vendor!.licenseImage!),
                      )
                          : Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: FileImage(
                              File(_licenseImage!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Aadhar card'),
                    //Aadhar card
                    InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _aadharImage = value;
                          });
                        });
                      },
                      child: _aadharImage == null
                          ? Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue.shade100,
                        child: _vendorData.vendor!.aadharImage == null
                            ? Center(
                          child: Text('Add Aadhar card.',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 15)),
                        )
                            : CachedNetworkImage(
                            imageUrl: _vendorData.vendor!.aadharImage!),
                      )
                          : Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: FileImage(
                              File(_aadharImage!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _contactNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Contact number',
                      ),
                      maxLength: 13,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    TextFormField(
                      controller: _whatsAppNum,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'WhatsApp number',
                      ),
                      maxLength: 13,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    _services.formField(
                        controller: _email,
                        label: 'Email',
                        inputType: TextInputType.emailAddress,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            final bool isValid = EmailValidator.validate(value);
                            if (isValid == false) {
                              return 'Invalid Email';
                            }
                          }
                          return null;
                        }),
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
                                _convertTo12Hours(openTime),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
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
                                _convertTo12Hours(closeTime),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const Text("Close"),
                          ],
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
                                return null;
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
                    Row(
                      children: [
                        const Text('Shop State : '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _shopState,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select weekly off day';
                                }
                                return null;
                              },
                              hint: const Text('Select state'),
                              items: shopStates.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _shopState = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    _services.formField(
                        controller: _address,
                        label: 'Address',
                        inputType: TextInputType.text,
                        maxLength: 100,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Address';
                          }
                          return null;
                        }),
                    const Divider(color: Colors.grey,),
                    Text('Bank Details',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,),
                    //Bank cheque Image
                    Text('Bank cheque'),
                    InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            _chequeImage = value;
                          });
                        });
                      },
                      child: _chequeImage == null
                          ? Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue.shade100,
                        child: _vendorData.vendor!.bankDetails!['cheque'] == null
                            ? Center(
                          child: Text('Add Cheque image.',
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 15)),
                        )
                            : CachedNetworkImage(
                            imageUrl: _vendorData.vendor!.bankDetails!['cheque']),
                      )
                          : Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: FileImage(
                              File(_chequeImage!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _services.formField(
                      controller: _bankAccountNo,
                      label: 'Bank A/C No',
                      inputType: TextInputType.number,
                    ),
                    _services.formField(
                      controller: _bankName,
                      label: 'Bank Name',
                      inputType: TextInputType.text,
                    ),
                    _services.formField(
                      controller: _IFSCcode,
                      label: 'IFSC Code',
                      inputType: TextInputType.text,
                    ),
                    const Divider(color: Colors.grey,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
