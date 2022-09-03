import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class edit extends StatefulWidget {
  DocumentSnapshot docid;
  edit({required this.docid});
  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController to = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController amount = TextEditingController();

  var email = "";

  final auth = FirebaseAuth.instance;

  CollectionReference ref1 = FirebaseFirestore.instance.collection('users');

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getdata();
    to = TextEditingController(text: widget.docid.get('user2'));
    String am = widget.docid.get('amount');
    am = am.replaceAll('+', '');
    am = am.replaceAll('-', '');
    amount = TextEditingController(text: am);
    content = TextEditingController(text: widget.docid.get('Description'));

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
              if (widget.docid.get('t') == 't') {
                widget.docid.reference.update({
                  'user1': email,
                  'amount': "+" + amount.text,
                  'user2': to.text,
                  'Description': content.text,
                  't': 't',
                }).whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                });
              }
              if (widget.docid.get('t') == 'r') {
                widget.docid.reference.update({
                  'user1': email,
                  'amount': "-" + amount.text,
                  'user2': to.text,
                  'Description': content.text,
                  't': 'r',
                }).whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                });
              }
            },
            child: Text(
              "Done",
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(
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
                  hintText: 'Recieve From......',
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
