import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  String id = Get.arguments;
  String comments = "";

  void updateCommentValue(String comments) {
    setState(() {
      this.comments = comments;
    });
  }

  void getAdminComment() {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);

    userCollectionReference.get().then((value) => {
          if (value["comments"] != null) {updateCommentValue(value["comments"])}
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Alert",
              style: TextStyle(fontSize: 25, fontFamily: 'Mtext')),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Visibility(
                visible: comments.isNotEmpty,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Column(children: [
                      Text(
                        "관리자 메시지",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                      )
                    ]))),
            Visibility(
              visible: comments.isNotEmpty,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(color: Colors.amber),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comments,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500))
                        ]),
                  )),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users/$id/trade')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "[${docs[index]['option']}] 안내메세지",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (docs[index]['result'] == '처리 대기중')
                                Text(
                                  "회원님의 ${docs[index]['option']} 신청이 접수 되었습니다!",
                                  style: TextStyle(color: Colors.grey[700]),
                                )
                              else if (docs[index]['result'] == '처리중')
                                Text(
                                  "회원님의 ${docs[index]['option']} 신청이 접수 되었습니다!",
                                  style: TextStyle(color: Colors.grey[700]),
                                )
                              else
                                Text(
                                    "회원님의 ${docs[index]['option']} 신청이 ${docs[index]['result']} 되었습니다.",
                                    style: TextStyle(color: Colors.grey[700])),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(docs[index]['sendId'],
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  /*Text(docs[index]['date'],
                                      style: TextStyle(color: Colors.grey[700]))*/
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        }),
                  );
                }),
          ],
        ));
  }
}
