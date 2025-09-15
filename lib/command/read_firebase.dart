import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadFirestore extends StatefulWidget {
  const ReadFirestore({super.key});

  @override
  State<ReadFirestore> createState() => _ReadFirestoreState();
}

class _ReadFirestoreState extends State<ReadFirestore> {

  FirebaseFirestore firestore =FirebaseFirestore.instance;
  var name="??";
  var phone="??";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("읽어오자 데이터"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Container(
          child:Column(
            children: [
              const SizedBox(height: 100),
              const Text("데이터 베이스에 저장된 이름"),
              Text(name),
              const SizedBox(height: 100),
              Text(phone.toString()),


              ElevatedButton(
                  onPressed:() async {
                    // await for (var snapshot in firestore.collection('Test').snapshots()) {
                    //   for (var message in snapshot.docs) {
                    //     print(message.data());
                    //   }
                    // }

                DocumentSnapshot test1docData = await firestore.collection('Test').doc('test1doc').get();
                print(test1docData.id);
                print(test1docData['name']);
                print(test1docData['phoneNumber']);



                setState(() {
                  name=test1docData['name'];
                  phone=test1docData['phoneNumber'].toString();

                });
              },
                  child: const Text("데이터 불러오기"))
            ],
          ),
        ),
      ),
    );
  }
}
