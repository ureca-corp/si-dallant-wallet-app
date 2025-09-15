import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyDallant extends StatefulWidget {
  const MyDallant({super.key});

  @override
  State<MyDallant> createState() => _MyDallantState();
}

class _MyDallantState extends State<MyDallant> {

  var id = Get.arguments;

  String userName = "";
  String userDL ="";

  // 숫자 , 찍기 위한  함수
  var f = NumberFormat("###,###,###,###.0#", "en_US");



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  void readData() async{
    // final prefs = await SharedPreferences.getInstance();
    final userCollectionReference = FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) => {
      // print(":::::::::::::::::: 들어가 있는 값 표시"),
      // print(widget.id),
      // print(value.data()),

      // print(":::::::::::::::----------- 정보 표시"),
      // print(value['name']),
      // print(value['dl']),

      setState(() {
        userDL=value['dl']?? '0';
        userName = value['name']?? '';
      }),

      // prefs.setString('userName', value['name']),

    });

  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width; // 현재 디바이스의 넓이
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Dallant", style: TextStyle(
          fontFamily: 'Mtext',
          fontSize: 25,
        ),),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Get.dialog(
              AlertDialog(
                title: const Text('회원 탈퇴를 진행하시겠습니까?'),
                actions: [
                  TextButton(
                    child: const Text("예"),
                    onPressed: () async{
                      Get.back();
                      Get.snackbar(
                        '회원 탈퇴가 신청 되었습니다',
                        '관리자가 검토후 최종 승인 처리 됩니다.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black,
                        colorText: Colors.white,
                        forwardAnimationCurve: Curves.elasticInOut,
                        reverseAnimationCurve: Curves.easeOut,
                      );
                    },
                  ),

                  TextButton(
                    child: const Text("아니요"),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            );
          },
              icon: const Icon(Icons.exit_to_app,size: 20))
        ],
      ),

      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users/$id/trade')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30.0)
                      ),
                      color: Colors.amber.withOpacity(0.95),
                    ),
                    width: double.infinity,
                    height: 120.0,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const SizedBox(width: 50),
                            const Text("안녕하세요 ", style: TextStyle(
                              fontSize: 20,
                            ),),
                            Text("$userName님!",style: const TextStyle(
                                fontSize: 20,fontWeight: FontWeight.bold
                            )),
                            const SizedBox(width:10),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if(userDL == "")
                                const Text("DL 0  ", style: TextStyle(
                                    fontSize: 35,  color: Colors.white
                                ),)
                              else Text("DL $userDL  ", style: const TextStyle(
                                  fontSize: 35,  color: Colors.white
                              ),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 20),
                                        SizedBox(
                                          width: deviceWidth*0.45,
                                          child: Row(
                                            children: [
                                              docs[index]['option'] == 'Swap'?
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Icon(Icons.monetization_on_outlined, size: 50,color: Colors.amber[700],),
                                              )
                                                  :SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Icon(Icons.monetization_on_outlined, size: 50,color: Colors.blue[400],),
                                              ),

                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(docs[index]['sendId'], style: const TextStyle(
                                                      fontSize: 15,fontWeight: FontWeight.bold
                                                  ),),
                                                  Text(docs[index]['option'], style: const TextStyle(
                                                    fontSize: 15,
                                                  ),),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),



                                        SizedBox(
                                          width: deviceWidth*0.45,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              if (docs[index]['option'] == 'Swap')
                                                Tooltip(
                                                  message: docs[index]['purpose'],
                                                  verticalOffset: 54,
                                                  child: Text("+DL ${f.format(double.parse(docs[index]['incomDL']))}", style: TextStyle(
                                                      fontSize: 15, color: Colors.amber[700], fontWeight: FontWeight.bold
                                                  ),),
                                                )
                                              else
                                                Tooltip(
                                                  message: docs[index]['purpose'],
                                                  verticalOffset: 54,
                                                  child: Text("-DL ${f.format(double.parse(docs[index]['exDL']))}", style: TextStyle(
                                                      fontSize: 15, color: Colors.blue[400], fontWeight: FontWeight.bold
                                                  ),),
                                                ),

                                              if (docs[index]['result'] == '처리완료')
                                                Tooltip(
                                                  message: docs[index]['purpose'],
                                                  verticalOffset: 54,
                                                  child: Text(docs[index]['result'], style: const TextStyle(
                                                      fontSize: 15, color: Colors.greenAccent
                                                  ),),
                                                ) else
                                                Tooltip(
                                                  message: docs[index]['purpose'],
                                                  verticalOffset: 54,
                                                  child: Text(docs[index]['result'], style: const TextStyle(
                                                      fontSize: 15, color: Colors.red
                                                  ),),
                                                )
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),

                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              );
            }
        ),
      ),
    );
  }
}
