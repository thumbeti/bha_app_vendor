import 'package:bha_app_vendor/firebase_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants.dart';
import '../../model/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;
  final String? productId;
  const ProductDetailsScreen({this.product, this.productId, Key? key})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  bool _editable = true;
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _salesPrice = TextEditingController();
  final _regularPrice = TextEditingController();
  String? _taxStatus;
  String? _taxPercent;
  bool? _availableInStock;

  Widget _taxStatusDropDown() {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: _taxStatus,
      hint: Text('Tax status'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          _taxStatus = newValue;
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

  Widget _taxPercentDropDown() {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: _taxPercent,
      hint: Text('Tax percentage'),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          _taxPercent = newValue;
        });
      },
      items: TAXPERCENTS.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select tax percentage';
        }
        return null;
      },
    );
  }

  Widget _textField(
      {TextEditingController? controller,
      String? label,
      TextInputType? inputType,
    String? Function(String?)? validator}) {
    return TextFormField(
      minLines: null,
      maxLines: null,
      controller: controller,
      keyboardType: inputType,
      validator: validator == null ?
          (value) {
        if (value!.isEmpty) {
          return 'Enter $label';
        }
      } : validator,
    );
  }

  updateProduct(){
    EasyLoading.show();
    _services.products.doc(widget.productId).update({
      'productName' : _productName.text,
      'productDescription' : _description.text,
      'regularPrice' : int.parse(_regularPrice.text),
      'salesPrice' : int.parse(_salesPrice.text),
      'taxStatus' : _taxStatus,
      'taxPercentage' : TAXPERCENTS[_taxPercent],
      'availableInStock' : _availableInStock,
    }).then((value) {
      setState(() {
        _editable = true;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    setState(() {
      _productName.text = widget.product!.productName!;
      _description.text = widget.product!.productDescription!;
      _salesPrice.text = widget.product!.salesPrice!.toString();
      _regularPrice.text = widget.product!.regularPrice!.toString();
      _taxStatus = widget.product!.taxStatus;
      _taxPercent = widget.product!.taxPercentage == null
          ? null
          : TAXPERCENTS.keys.firstWhere(
              (k) => TAXPERCENTS[k] == widget.product!.taxPercentage,
              orElse: () => 'Select Tax Percent');
      _availableInStock = widget.product!.availableInStock;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.product!.productName!),
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
                        if(_formKey.currentState!.validate()){
                          updateProduct();
                        }
                      },
                    ),
                ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              AbsorbPointer(
                absorbing: _editable,
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      child: CachedNetworkImage(
                          imageUrl: widget.product!.productImageUrl!),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Name: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: _textField(
                            label: 'Product name',
                            inputType: TextInputType.text,
                            controller: _productName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Description: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: _textField(
                            label: 'Description',
                            inputType: TextInputType.text,
                            controller: _description,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        if (widget.product!.salesPrice != null)
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Sales Price: \u{20B9}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: _textField(
                                    label: 'Sales Price',
                                    inputType: TextInputType.number,
                                    controller: _salesPrice,
                                      validator: (value) {
                                        if(value!.isEmpty) {
                                          return 'Enter sales price';
                                        }
                                        if(int.parse(_regularPrice.text) < int.parse(value)) {
                                          return 'Enter sales price less than regular price.';
                                        }
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Regular Price: \u{20B9}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: _textField(
                                  label: 'Regular Price',
                                  inputType: TextInputType.number,
                                  controller: _regularPrice,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return 'Enter regular price';
                                    }
                                    if(int.parse(value) < int.parse(_salesPrice.text)) {
                                      return 'Enter regular price less than sales price.';
                                    }
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _taxStatusDropDown(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        if (_taxStatus == 'Taxable')
                          Expanded(
                            child: _taxPercentDropDown(),
                          ),
                      ],
                    ),
                    if (widget.product!.category != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Category: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.product!.category!),
                          ],
                        ),
                      ),
                    if (widget.product!.mainCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Main Category: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.product!.mainCategory!),
                          ],
                        ),
                      ),
                    if (widget.product!.subCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              'Sub Category: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.product!.subCategory!),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(children: [
                        Text(
                          'SKU: ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(widget.product!.sku!),
                      ]),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Available in stock?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: _availableInStock,
                        onChanged: (value) {
                          setState(() {
                            _availableInStock = value;
                            //provider.getFormData(availableInStock: value);
                          });
                        }),
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
