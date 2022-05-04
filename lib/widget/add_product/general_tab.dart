import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_services.dart';
import '../../provider/product_provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  final FirebaseServices _services = FirebaseServices();
  Widget _formField(
      {String? label,
      TextInputType? inputType,
      void Function(String)? onChanged}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      print(value.docs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              //productName
              _formField(
                  label: 'Enter product name',
                  inputType: TextInputType.name,
                  onChanged: (value) {
                    // save in provider
                    provider.getFormData(
                      productName: value,
                    );
                  }),
              _formField(
                  label: 'Regular price (\u{20B9})',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    // save in provider
                    provider.getFormData(
                      regularPrice: int.parse(value),
                    );
                  }),
              _formField(
                  label: 'Sales price (\u{20B9})',
                  inputType: TextInputType.number,
                  onChanged: (value) {
                    // save in provider
                    provider.getFormData(
                      salesPrice: int.parse(value),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}
