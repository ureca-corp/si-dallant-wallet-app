import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultDl extends StatefulWidget {
  const ResultDl({super.key});

  @override
  State<ResultDl> createState() => _ResultDlState();
}

class _ResultDlState extends State<ResultDl> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  String userID ="";

  List<String> data = [];


  void pref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userId') ?? '';
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref();
    print(data);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat screen'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                _authentication.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/$userID/trade')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                data.add(docs[index]['result']);

                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      data.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                );
              },
            );
          },
        ));
  }
}