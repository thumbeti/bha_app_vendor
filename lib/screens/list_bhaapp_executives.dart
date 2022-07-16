import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListBhaAppExecutives extends StatefulWidget {
  const ListBhaAppExecutives({Key? key}) : super(key: key);
  static const String id = 'list_bhaapp_executives';

  @override
  State<ListBhaAppExecutives> createState() => _ListBhaAppExecutivesState();
}

class _ListBhaAppExecutivesState extends State<ListBhaAppExecutives> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BhaApp executives'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('executives').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!.docs.map((doc) {
                  return Card(
                    child: ListTile(
                      title: Text(doc['name']),
                      trailing: Text(doc['ID']),
                    ),
                  );
                }).toList(),
              ),
            );
        },
      ),
    );
  }
}
