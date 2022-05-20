import 'package:bha_app_vendor/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> with AutomaticKeepAliveClientMixin {
  final FirebaseServices _service = FirebaseServices();
  bool? _chargeShpping = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Charge Shipping/Delivery?', style: TextStyle(color: Colors.grey),),
                value: _chargeShpping,
                onChanged: (value){
                  setState(() {
                    _chargeShpping = value;
                    provider.getFormData(chargeShipping: value);
                  });
                }),
            if(_chargeShpping == true)
              _service.formField(
                label: 'Shipping charge',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(shippingCharge: int.parse(value));
                }
              ),
          ],
        ),
      );
    });;
  }
}
