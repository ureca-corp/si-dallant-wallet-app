import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DallantInsert extends StatefulWidget {
  const DallantInsert({super.key});

  @override
  State<DallantInsert> createState() => _DallantInsertState();
}

class _DallantInsertState extends State<DallantInsert> {

  FirebaseFirestore firestore =FirebaseFirestore.instance;

  var sendIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getData();

  }

  Future<void> getData() async {
    var collection = FirebaseFirestore.instance.collection('users');

    // final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('users').doc(widget.id).collection("trade").get();

    // setState(() {
    //   itemCount  = qSnap.docs.length;
    // });


    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();


        print(data['id']);


      }
    });

  }


  // void _submit() async {
  //
  //   print("내용::::::::::::");
  //   print(sendIdController.text.trim());
  //
  //     Get.dialog(
  //       AlertDialog(
  //         title: const Text('신청하시겠습니까?'),
  //         actions: [
  //           TextButton(
  //             child: const Text("예"),
  //             onPressed: () async{
  //               try {
  //                 print("입력성공");
  //                 firestore.collection('users').doc("12").collection('trade').doc("123").set({
  //                   "option":rSE ?? "",
  //                   "time": convertedDateTime?? "",
  //                   "sendId": sendIdController.text.trim()?? "",
  //                   "type": jList?? "",
  //                   // "quantity": quantityController.text.trim()?? "",
  //                   "purpose": userInsertController.text.trim()?? "",
  //                   "incomDL":a??"0",
  //                   "exDL":b??"0",
  //                   "result":"처리중",
  //                 });
  //                 Get.snackbar(
  //                   '신청이 완료되었습니다.',
  //                   '해당 내용 검토후 처리해드리겠습니다.',
  //                   snackPosition: SnackPosition.BOTTOM,
  //                   colorText: Colors.white,
  //                   forwardAnimationCurve: Curves.elasticInOut,
  //                   reverseAnimationCurve: Curves.easeOut,
  //                 );
  //
  //               } catch (e) {
  //                 print(e);
  //               }
  //             },
  //           ),
  //
  //           TextButton(
  //             child: const Text("아니요"),
  //             onPressed: () => Get.back(),
  //           ),
  //         ],
  //       ),
  //     );
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyProfile"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
            child: TextFormField(
              controller: sendIdController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return "받는분 ID는 필수로 입력해야 합니다.";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: '받는 아이디',
                // hintText: 'Enter your email',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          ElevatedButton(onPressed: (){}, child: Text('신청'))
        ],
      )
    );
  }
}
