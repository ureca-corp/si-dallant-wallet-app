import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_dallant_wallet_app/screens/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var idController = TextEditingController();
  var mobileController = TextEditingController();
  var banknumController = TextEditingController();
  var chooidController = TextEditingController();

  String bank = "";

  void _checkEmail() async {
    // 정규표현식
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    DocumentSnapshot userCode = await firestore
        .collection('users')
        .doc(idController.text.trim())
        .get();

    // 중복 이메일 검사
    bool duplicate = false;

    try {
      if (idController.text.trim() == userCode['id']) {
        print("아이디가 일치 합니다.");
        Get.snackbar(
          '중복된 아이디가 있습니다!',
          '다른 아이디를 입력하세요~',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.easeOut,
        );
      }
    } catch (e) {
      print(e);
      print("아이디가 일치 하지 않습니다.");
      _submit();
      duplicate = false;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        print("입력성공11111");
        var now = DateTime.now();
        var formatter = DateFormat("yyyy-MM-dd hh:mm:ss");

        firestore.collection('users').doc(idController.text.trim()).set({
          "name": nameController.text.trim(),
          "id": idController.text.trim(),
          "phone": mobileController.text.trim(),
          "bank": bank,
          "bankNum": banknumController.text.trim(),
          "recommender": chooidController.text.trim(),
          //auto set
          "code": "1234",
          "dl": "0",
          "admin": "n",
          "comments": "",
          "createdAt": formatter.format(now),
          // 'epList': FieldValue.arrayUnion([0]),
          // 'spList': FieldValue.arrayUnion([0]),
          // 'npList': FieldValue.arrayUnion([0]),
          // 'dlList': FieldValue.arrayUnion([0]),

          // 'wonList': FieldValue.arrayUnion(["0"]),
          // 'usdList': FieldValue.arrayUnion(["0"]),
          // 'dateList': FieldValue.arrayUnion([""]),

          // 'dallantDateList':FieldValue.arrayUnion([""]),
          // 'dlStats':FieldValue.arrayUnion([{'usd': "0", 'won': "0"}]),
        });
        Get.snackbar(
          '회원가입 완료되었습니다.',
          '관리자에게 코드를 부여 받으세요!',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.easeOut,
        );
        Get.to(const LoginPage());
      } catch (e) {
        print(e);
      }
    } else {
      print("값이 따 입력되지 않았어요");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "회원가입",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30.0),
                    ),
                    color: Colors.amber.withOpacity(0.95),
                  ),
                  width: double.infinity,
                  height: 20.0,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '성함(Name)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "성함(이름)은 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '아이디(ID)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "아이디는 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "모바일",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '-없이 숫자만 입력해주세요!',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "휴대폰 번호는 필수로 입력해야 합니다.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "연결계좌",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButtonFormField<String?>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xffcfcfcf),
                          ),
                        ),
                        // underline: Container(height: 1.4, color: Color(0xffc0c0c0)),
                        hint: const Text("거래은행을 선택하세요"),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "은행명을 선택해주세요!";
                          } else {
                            setState(() {
                              bank = value;
                            });
                          }
                          return null;
                        },

                        onChanged: (String? newValue) {
                          print(newValue);

                          // firestore.collection('users').doc('feverh').update({
                          //   "bank" :newValue,
                          // });
                        },
                        items:
                            [
                              '카카오뱅크',
                              '케이뱅크',
                              '토스뱅크',
                              'KB국민은행',
                              '신한은행',
                              '우리은행',
                              'NH농협은행',
                              'KEB하나은행',
                              'SC제일은행',
                              '국민은행',
                              '새마을금고',
                              '우체국은행',
                              '외환은행',
                              '한국시티은행',
                              '경남은행',
                              '광주은행',
                              '대구은행',
                              '부산은행',
                              '전북은행',
                              '제주은행',
                              '기업은행',
                              '수협',
                              '한국산업은행',
                              '한국수출입은행',
                              '기타은행',
                            ].map<DropdownMenuItem<String?>>((String? i) {
                              return DropdownMenuItem<String?>(
                                value: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 17.0),
                                  child: Text(
                                    {
                                          '카카오뱅크': '카카오뱅크',
                                          '케이뱅크': '케이뱅크',
                                          '토스뱅크': '토스뱅크',
                                          'KB국민은행': 'KB국민은행',
                                          '신한은행': '신한은행',
                                          '우리은행': '우리은행',
                                          'NH농협은행': 'NH농협은행',
                                          'KEB하나은행': 'KEB하나은행',
                                          'SC제일은행': 'SC제일은행',
                                          '국민은행': '국민은행',
                                          '새마을금고': '새마을금고',
                                          '우체국은행': '우체국은행',
                                          '외환은행': '외환은행',
                                          '한국시티은행': '한국시티은행',
                                          '경남은행': '경남은행',
                                          '광주은행': '광주은행',
                                          '대구은행': '대구은행',
                                          '부산은행': '부산은행',
                                          '전북은행': '전북은행',
                                          '제주은행': '제주은행',
                                          '기업은행': '기업은행',
                                          '수협': '수협',
                                          '한국산업은행': '한국산업은행',
                                          '한국수출입은행': '한국수출입은행',
                                          '기타은행': '기타은행',
                                        }[i] ??
                                        '비공개',
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: banknumController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '계좌번호(-빼고 입력해주세요)',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "추천인 아이디",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: chooidController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '추천인 아이디',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    _formKey.currentState!.validate();

                    _checkEmail();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '회원 가입 완료',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
