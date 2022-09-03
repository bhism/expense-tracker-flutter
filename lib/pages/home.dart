import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/pages/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit.dart';
import 'rtransaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense app",
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var email = "";
  final auth = FirebaseAuth.instance;

  CollectionReference ref = FirebaseFirestore.instance.collection('users');
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
    DocumentSnapshot userdoc = await ref.doc(user!.uid).get();
    setState(() {
      email = userdoc.get('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('transaction')
        .where('user1', isEqualTo: email)
        .snapshots();
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    String amount =
                        snapshot.data!.docChanges[index].doc['amount'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                edit(docid: snapshot.data!.docs[index]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                snapshot.data!.docChanges[index].doc['user2'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: Text(
                                amount,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.add,
              ),
              backgroundColor: Color.fromARGB(255, 162, 0, 255),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => transaction(),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.file_present,
              ),
              backgroundColor: Color.fromARGB(255, 162, 0, 255),
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => transaction(),
                //   ),
                // );
              },
            ),
          ),
          Align(
            alignment: Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Text(
                "-",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 162, 0, 255),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => rtransaction(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
