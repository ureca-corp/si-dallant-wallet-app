import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:si_dallant_wallet_app/screens/mainpage.dart';

class SwapExchange extends StatefulWidget {
  const SwapExchange({super.key});

  @override
  State<SwapExchange> createState() => _SwapExchangeState();
}

class _SwapExchangeState extends State<SwapExchange> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool swapcheck = false;
  bool exchange = false;
  bool dallant = false;
  bool ycg = false;
  bool gold = false;
  bool dbj = false;

  String id = Get.arguments;

  String userId = "";
  String dallantPrice = "";

  var sendIdController = TextEditingController();
  var quantityController = TextEditingController();
  var userInsertController = TextEditingController();

  //신청분류
  String rSE = "";

  //종류
  String jList = "";

  //시간 전송
  String tradeCode = "";

  DateTime now = DateTime.now();

  static final storage = FlutterSecureStorage();
  String userInfo = ""; //user의 정보를 저장하기 위한 변수

  String a = "";
  String b = "";

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(int.parse(s));
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = (await storage.read(key: "login"))!;

    //user의 정보가 있다면 바로 메인 페이지로 넘어가게 합니다.
    Get.off(
      MainPage(id: userInfo.split(" ")[1], pass: userInfo.split(" ")[3]),
      arguments: tradeCode,
    );
  }

  void _submit() async {
    DocumentSnapshot userCode = await firestore
        .collection('users')
        .doc(sendIdController.text.trim())
        .get();
    DocumentSnapshot myName = await firestore.collection('users').doc(id).get();

    print("내용::::::::::::");
    print(sendIdController.text.trim());
    print(quantityController.text.trim());
    print(userInsertController.text.trim());
    print(rSE);
    print(jList);

    rSE == 'Swap'
        ? a = quantityController.text.trim()
        : b = quantityController.text.trim();

    String convertedDateTime =
        "${now.year.toString()}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString()}${now.minute.toString()}";

    setState(() {
      tradeCode = convertedDateTime;
    });

    if (_formKey.currentState!.validate()) {
      Get.dialog(
        AlertDialog(
          title: const Text('신청하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text("예"),
              onPressed: () async {
                try {
                  print("입력성공");
                  firestore
                      .collection('users')
                      .doc(id)
                      .collection('trade')
                      .doc(convertedDateTime)
                      .set({
                        "option": rSE ?? "",
                        "time": convertedDateTime ?? "",
                        "sendId": sendIdController.text.trim() ?? "",
                        "sendName": userCode['name'] ?? "",
                        "type": jList ?? "",
                        // "quantity": quantityController.text.trim()?? "",
                        "purpose": userInsertController.text.trim() ?? "",
                        "incomDL": a ?? "0",
                        "exDL": b ?? "0",
                        "result": "처리 대기중",
                        "date":
                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}",
                      });
                  firestore
                      .collection('admin')
                      .doc('database')
                      .collection('trade')
                      .doc('${myName['id']}-$convertedDateTime')
                      .set({
                        "option": rSE ?? "",
                        "time": convertedDateTime ?? "",
                        "name": myName['name'] ?? "",
                        "id": myName['id'] ?? "",
                        "sendId": sendIdController.text.trim() ?? "",
                        "sendName": userCode['name'] ?? "",
                        "type": jList ?? "",
                        // "quantity": quantityController.text.trim()?? "",
                        "purpose": userInsertController.text.trim() ?? "",
                        "incomDL": a ?? "0",
                        "exDL": b ?? "0",
                        "result": "처리 대기중",
                        "nowDate":
                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}",
                        "date":
                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
                      });

                  Get.snackbar(
                    '신청이 완료되었습니다.',
                    '해당 내용 검토후 처리해드리겠습니다.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                    forwardAnimationCurve: Curves.elasticInOut,
                    reverseAnimationCurve: Curves.easeOut,
                  );

                  _asyncMethod();
                } catch (e) {
                  print(e);
                  Get.snackbar(
                    '아이디가 일치하지 않습니다',
                    '받는분의 아이디를 다시 확인하세요!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    forwardAnimationCurve: Curves.elasticInOut,
                    reverseAnimationCurve: Curves.easeOut,
                  );
                }
              },
            ),
            TextButton(child: const Text("아니요"), onPressed: () => Get.back()),
          ],
        ),
      );
    } else {
      print("키다 입렵해유~");
    }
  }

  void data() async {
    DocumentSnapshot userCode = await firestore
        .collection('user')
        .doc(id)
        .get();
    //print(userCode.id);

    DocumentSnapshot dallantPrice = await firestore
        .collection('dallant_price')
        .doc("dallant_price")
        .get();
    print(dallantPrice["price"]);
    setState(() {
      //userId = userCode['User_id'];
      this.dallantPrice = dallantPrice["price"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  var f = NumberFormat("###,###,###,###.0#", "en_US");

  @override
  Widget build(BuildContext context) {
    print("Dallant : $dallantPrice");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Swap & Exchange",
            style: TextStyle(fontSize: 25, fontFamily: 'Mtext'),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "신청분류",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MSHCheckbox(
                        size: 15,
                        value: swapcheck,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            exchange = false;
                            swapcheck = selected;

                            if (swapcheck = selected) {
                              rSE = "Swap";
                            } else {
                              rSE = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Swap',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797979),
                        ),
                      ),
                      const SizedBox(width: 20),
                      MSHCheckbox(
                        size: 15,
                        value: exchange,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            exchange = selected;
                            swapcheck = false;

                            if (exchange = selected) {
                              rSE = "Exchange";
                            } else {
                              rSE = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Exchange',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797979),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: InkWell(
                      onTap: () {
                        Future<DateTime?> future = showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2042),
                        );

                        future.then((date) {
                          setState(() {
                            now = date!;
                          });
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            10.0,
                            8.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            "${now.year.toString()}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString()}${now.minute.toString()}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                        child: Text(
                          id,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: sendIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "받는분 ID는 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: '받는 아이디',
                          // hintText: 'Enter your email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "종류",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MSHCheckbox(
                        size: 15,
                        value: dallant,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            dallant = selected;
                            ycg = false;
                            gold = false;
                            dbj = false;

                            if (dallant = selected) {
                              jList = "Dallant";
                            } else {
                              jList = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 5),

                      /*const Text('Dallant',
                        style:  TextStyle(
                            fontSize: 15,
                            color: Color(0xff797979)
                        ),
                      ),*/
                      SizedBox(
                        width: 25,
                        child: Image.asset("assets/dallant-logo2.png"),
                      ),
                      const SizedBox(width: 10),
                      MSHCheckbox(
                        size: 15,
                        value: ycg,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            dallant = false;
                            ycg = selected;
                            gold = false;
                            dbj = false;

                            if (ycg = selected) {
                              jList = "예치금";
                            } else {
                              jList = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '예치금',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797979),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MSHCheckbox(
                        size: 15,
                        value: gold,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            dallant = false;
                            ycg = false;
                            gold = selected;
                            dbj = false;

                            if (gold = selected) {
                              jList = "GOLD";
                            } else {
                              jList = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'GOLD',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797979),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MSHCheckbox(
                        size: 15,
                        value: dbj,
                        checkedColor: Colors.blue,
                        style: MSHCheckboxStyle.fillScaleColor,
                        onChanged: (selected) {
                          setState(() {
                            dallant = false;
                            ycg = false;
                            gold = false;
                            dbj = selected;

                            if (dbj = selected) {
                              jList = "상품권";
                            } else {
                              jList = "";
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '상품권',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff797979),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        // onChanged: (string) {
                        //   string = '${formNum(
                        //     string.replaceAll(',', ''),
                        //   )}';
                        //   quantityController.value = TextEditingValue(
                        //     text: string,
                        //     selection: TextSelection.collapsed(
                        //       offset: string.length,
                        //     ),
                        //   );
                        // },
                        controller: quantityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "수량은 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: '수량',
                          // hintText: 'Enter your email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: userInsertController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "용도는 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: '용도',
                          // hintText: 'Enter your email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("현재 시세 : 1DL", style: TextStyle(fontSize: 15)),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset("assets/dallant-logo2.png"),
                        ),
                        SizedBox(width: 5),
                        Text("/", style: TextStyle(fontSize: 15)),
                        SizedBox(width: 5),
                        Text(dallantPrice, style: TextStyle(fontSize: 15)),
                        SizedBox(width: 5),
                        Text("원", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: SizedBox(
                      width: 500,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text("신청하기"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
