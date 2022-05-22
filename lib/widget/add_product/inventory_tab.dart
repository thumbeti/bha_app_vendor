import 'package:bha_app_vendor/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> with AutomaticKeepAliveClientMixin {
  //final FirebaseServices _services = FirebaseServices();
  bool? _availableInStock = true;
  //bool? _manageInventory = false;
  var skuControler = TextEditingController(text: DateTime.now().millisecondsSinceEpoch.toString());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: skuControler,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'SKU',
              ),
              validator: (value) {
                  setState(() {
                    provider.getFormData(sku: skuControler.text);
                  });
                  return;
              },
              onChanged: (value) {
                setState(() {
                  provider.getFormData(sku: value);
                });
              },
            ),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Available in stock?', style: TextStyle(color: Colors.grey),),
                value: _availableInStock,
                onChanged: (value) {
                  setState(() {
                    _availableInStock = value;
                    provider.getFormData(availableInStock: value);
                  });
                }),
          /*
          CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Manage Inventory?', style: TextStyle(color: Colors.grey),),
                value: _manageInventory,
                onChanged: (value) {
                  setState(() {
                    _manageInventory = value;
                    provider.getFormData(manageInventory: value);
                  });
                }),
            if(_manageInventory == true)
              Column(
                children: [
                  _services.formField(
                      label: 'Stock on hand',
                      inputType: TextInputType.number,
                      onChanged:(value) {
                        provider.getFormData(soh: int.parse(value));
                      }
                  ),
                  _services.formField(
                      label: 'Re-order level',
                      inputType: TextInputType.number,
                      onChanged:(value) {
                        provider.getFormData(reOrderLevel: int.parse(value));
                      }
                  ),
                ],
              ),
            */
          ],
        ),
      );
    });
  }
}
