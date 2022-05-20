import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../firebase_services.dart';
import '../../provider/product_provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker _picker = ImagePicker();

  final FirebaseServices _services = FirebaseServices();
  final List<String> _categories = [];
  String? selectedCategory;
  String? taxStatus = 'Non Taxable';
  String? taxPercent;
  String? priceUnit;

  final _productName = TextEditingController();
  final _productDes = TextEditingController();
  final _regularPrice = TextEditingController();
  final _salePrice = TextEditingController();

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? inputType,
      void Function(String)? onChanged,
      int? minLine,
      int? maxLine}) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
        //return value==null? 'Enter value':null;
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }

  Widget categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: selectedCategory,
      hint: Text('Select category'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      //style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
          provider.getFormData(category: newValue);
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return value == null ? 'Select category' : null;
      },
    );
  }

  Widget _priceUnitDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: priceUnit,
      hint: Text('Price per unit'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          priceUnit = newValue!;
          provider.getFormData(priceUnit: newValue);
        });
      },
      items: units.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return value == null ? 'Select unit for price' : null;
      },
    );
  }

  Widget _taxStatusDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: taxStatus,
      hint: Text('Tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxStatus = newValue!;
          provider.getFormData(taxStatus: newValue);
        });
      },
      items: ['Non Taxable', 'Taxable']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return value == null ? 'Select tax status' : null;
      },
    );
  }

  Widget _taxPercentDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: taxPercent,
      hint: Text('Tax percentage'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxPercent = newValue!;
          provider.getFormData(
            taxPercentage: TAXPERCENTS[taxPercent!],
          );
        });
      },
      items:
        TAXPERCENTS.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select tax percentage';
        }
      },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element['catName']);
        });
      });
      setState(() {
        selectedCategory = _categories.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              provider.prodImage == null
                  ? Container(
                      color: Colors.blue,
                      height: 150,
                      child: TextButton(
                        child: Center(
                          child: Text('Tap to add prod image.',
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 15)),
                        ),
                        onPressed: () {
                          _pickImage().then((value) {
                            setState(() {
                              provider.prodImage = value;
                            });
                          });
                        },
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _pickImage().then((value) {
                          setState(() {
                            provider.prodImage = value;
                          });
                        });
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            opacity: 100,
                            image: FileImage(
                              File(provider.prodImage!.path),
                            ),
                            //image: FileImage(File(_shopImage!.path),),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
              //productName
              _formField(
                  controller: _productName,
                  label: 'Enter product name',
                  inputType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      // save in provider
                      provider.getFormData(
                        productName: value,
                      );
                    });
                  }),
              //Description
              _formField(
                controller: _productDes,
                label: 'Enter description',
                inputType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    // save in provider
                    provider.getFormData(
                      productDescription: value,
                    );
                  });
                },
                minLine: 2,
                maxLine: 10,
              ),
              SizedBox(
                height: 30,
              ),
              categoryDropDown(provider),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.productData!['mainCategory'] ??
                          'Select main category',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    if (selectedCategory != null)
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MainCategoryList(
                                  selectedCategory: selectedCategory,
                                  provider: provider,
                                );
                              }).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.arrow_drop_down),
                      ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.productData!['subCategory'] ??
                          'Select sub category',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    if (provider.productData!['mainCategory'] != null)
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SubCategoryList(
                                  selectedMainCategory:
                                      provider.productData!['mainCategory'],
                                  provider: provider,
                                );
                              }).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.arrow_drop_down),
                      ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 30,
              ),
              _priceUnitDropDown(provider),
              _formField(
                  controller: _regularPrice,
                  label: 'Regular price (\u{20B9})',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      // save in provider
                      provider.getFormData(
                        regularPrice: int.parse(value),
                      );
                    });
                  }),
              _formField(
                  controller: _salePrice,
                  label: 'Sales price (\u{20B9})',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    if (int.parse(value) >
                        provider.productData!['regularPrice']) {
                      _services.scaffold(context,
                          'Sales price should be less than regular price.');
                      return;
                    }
                    setState(() {
                      // save in provider
                      provider.getFormData(
                        salesPrice: int.parse(value),
                      );
                    });
                  }),
              SizedBox(
                height: 30,
              ),
              _taxStatusDropDown(provider),
              if (taxStatus == 'Taxable') _taxPercentDropDown(provider),
            ],
          ),
        );
      },
    );
  }
}

class MainCategoryList extends StatelessWidget {
  final String? selectedCategory;
  final ProductProvider? provider;
  const MainCategoryList({this.selectedCategory, this.provider, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.mainCategories
            .where('category', isEqualTo: selectedCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return Center(
              child: Text('No Main Categories'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    provider!.getFormData(
                        mainCategory: snapshot.data!.docs[index]
                            ['mainCategory']);
                    Navigator.pop(context);
                  },
                  title: Text(snapshot.data!.docs[index]['mainCategory']),
                );
              });
        },
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String? selectedMainCategory;
  final ProductProvider? provider;
  const SubCategoryList({this.selectedMainCategory, this.provider, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.subCategories
            .where('mainCategory', isEqualTo: selectedMainCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return Center(
              child: Text('No Sub Categories'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    provider!.getFormData(
                        subCategory: snapshot.data!.docs[index]['subCatName']);
                    Navigator.pop(context);
                  },
                  title: Text(snapshot.data!.docs[index]['subCatName']),
                );
              });
        },
      ),
    );
  }
}
