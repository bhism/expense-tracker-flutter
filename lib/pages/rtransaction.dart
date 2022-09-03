import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class rtransaction extends StatefulWidget {
  @override
  State<rtransaction> createState() => _rtransactionState();
}

class _rtransactionState extends State<rtransaction> {
  TextEditingController to = TextEditingController();

  TextEditingController content = TextEditingController();

  TextEditingController amount = TextEditingController();

  CollectionReference ref =
      FirebaseFirestore.instance.collection('transaction');

  var email = "";

  final auth = FirebaseAuth.instance;

  CollectionReference ref1 = FirebaseFirestore.instance.collection('users');

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getdata() async {
    DocumentSnapshot userdoc = await ref1.doc(user!.uid).get();
    setState(() {
      email = userdoc.get('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              ref.add({
                'user1': email,
                'amount': "-" + amount.text,
                'user2': to.text,
                'Description': content.text,
                't': 'r',
              }).whenComplete(
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                },
              );
            },
            child: Text(
              "Done",
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            },
            child: Text(
              "Cancel",
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: to,
                decoration: InputDecoration(
                  hintText: 'To...',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: amount,
                decoration: InputDecoration(
                  hintText: 'amount',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  controller: content,
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
