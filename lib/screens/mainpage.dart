import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:si_dallant_wallet_app/screens/alert_page.dart';
import 'package:si_dallant_wallet_app/screens/dl_chart.dart';
import 'package:si_dallant_wallet_app/screens/login.dart';
import 'package:si_dallant_wallet_app/screens/mydallant.dart';
import 'package:si_dallant_wallet_app/screens/reward_confirm.dart';
import 'package:si_dallant_wallet_app/screens/swap_exchange.dart';

class MainPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;

  const MainPage({super.key, required this.id, required this.pass});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final storage = FlutterSecureStorage();

  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  late String id;
  late String pass;

  var tradeValue = Get.arguments;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userName = "";
  String userDL = "";

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(int.parse(s));
  }

  // 숫자 , 찍기 위한  함수
  var f = NumberFormat("###,###,###,###.0#", "en_US");

  void readData() async {
    // final prefs = await SharedPreferences.getInstance();
    final userCollectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id);
    userCollectionReference.get().then(
      (value) => {
        // print(":::::::::::::::::: 들어가 있는 값 표시"),
        // print(widget.id),
        // print(value.data()),

        // print(":::::::::::::::----------- 정보 표시"),
        // print(value['name']),
        // print(value['dl']),
        setState(() {
          userDL = value['dl'] ?? '0';
          userName = value['name'] ?? '';
        }),

        // prefs.setString('userName', value['name']),
      },
    );
  }

  double result = 0;
  List<double> incomSum = [];
  double total = 0;

  double result2 = 0;
  List<double> exSum = [];
  double total2 = 0;

  //alert counter
  int itemCount = 0;

  Future<void> getData() async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("trade");

    final QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("trade")
        .get();

    setState(() {
      itemCount = qSnap.docs.length;
    });

    collection.snapshots().listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        if (data['incomDL'] != "") {
          double incomSwap = double.parse(data['incomDL']);
          incomSum.add(incomSwap);
          double sum = incomSum.reduce((a, b) => a + b);

          setState(() {
            total = sum;
            // total2 = sum2;
          });
        } else if (data['exDL'] != "") {
          // double incomSwap = double.parse(data['incomDL']);
          double exSwap = double.parse(data['exDL']);
          exSum.add(exSwap);
          double sum2 = exSum.reduce((a, b) => a + b);

          setState(() {
            // total = sum;
            total2 = sum2;
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    readData();

    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass; //widget.pass LogOutPage에서 전달받은 pass 의미한다.
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width; // 현재 디바이스의 넓이
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0), // here the desired height
        child: AppBar(elevation: 0.0, automaticallyImplyLeading: false),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/$id/trade')
              .snapshots(),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30.0),
                          ),
                          color: Colors.amber.withOpacity(0.95),
                        ),
                        width: double.infinity,
                        height: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: deviceWidth * 0.35,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(DlChart(), arguments: id);
                                    },
                                    child: const Text(
                                      "Dallant",
                                      style: TextStyle(
                                        fontFamily: 'Mtext',
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_alert,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Get.to(AlertPage(), arguments: id);
                                      },
                                    ),
                                    itemCount == 0
                                        ? Container()
                                        : Positioned(
                                            child: Stack(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.brightness_1,
                                                  size: 20.0,
                                                  color: Colors.red.shade500,
                                                ),
                                                Positioned(
                                                  top: 2.0,
                                                  right: 5.5,
                                                  child: Center(
                                                    child: Text(
                                                      itemCount.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const SizedBox(width: 50),
                                const Text(
                                  "안녕하세요 ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "$userName님!",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    storage.delete(key: "login");
                                    Get.offAll(LoginPage());
                                  },
                                  child: Text(
                                    "로그아웃",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 50),
                                InkWell(
                                  child: const Text(
                                    "My Dallant -> ",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(MyDallant(), arguments: id);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (userDL == "0")
                                    const Text(
                                      "DL 0  ",
                                      style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                      ),
                                    )
                                  else
                                    Text(
                                      "DL ${f.format(double.parse(userDL))}  ",
                                      style: const TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 350,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xffdc864c), Color(0xffd97f52)],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          onPressed: () {
                            Get.to(RewardConfirm(), arguments: id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text(
                                  'Reward Confirm',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 350,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF2E44D0), Color(0xff58abdf)],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          onPressed: () {
                            Get.to(() => SwapExchange(), arguments: id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text(
                                  'Swap & Exchange',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "거래내역",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "모두보기",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.orange[200],
                                    child: const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Income Swap",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    if (total == 0)
                                      const Text(
                                        "DL 0",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    else
                                      Text(
                                        "DL ${f.format(total)}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.blue[200],
                                    child: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Expenditure Swap",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      if (total2 == 0)
                                        const Text(
                                          "DL 0",
                                          style: TextStyle(fontSize: 15),
                                        )
                                      else
                                        Text(
                                          "DL ${f.format(total2)}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: SizedBox(
                                height: 500,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: deviceWidth * 0.45,
                                                child: Row(
                                                  children: [
                                                    docs[index]['option'] ==
                                                            'Swap'
                                                        ? SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: Icon(
                                                              Icons
                                                                  .monetization_on_outlined,
                                                              size: 50,
                                                              color: Colors
                                                                  .amber[700],
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: Icon(
                                                              Icons
                                                                  .monetization_on_outlined,
                                                              size: 50,
                                                              color: Colors
                                                                  .blue[400],
                                                            ),
                                                          ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          docs[index]['sendName'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          docs[index]['option'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.45,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    if (docs[index]['option'] ==
                                                        'Swap')
                                                      Tooltip(
                                                        message:
                                                            docs[index]['purpose'],
                                                        verticalOffset: 54,
                                                        child: Text(
                                                          "-DL ${f.format(double.parse(docs[index]['incomDL']))}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .amber[700],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Tooltip(
                                                        message:
                                                            docs[index]['purpose'],
                                                        verticalOffset: 54,
                                                        child: Text(
                                                          "-DL ${f.format(double.parse(docs[index]['exDL']))}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .blue[400],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    if (docs[index]['result'] ==
                                                        '처리완료')
                                                      Tooltip(
                                                        message:
                                                            docs[index]['purpose'],
                                                        verticalOffset: 54,
                                                        child: Text(
                                                          docs[index]['result'],
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Tooltip(
                                                        message:
                                                            docs[index]['purpose'],
                                                        verticalOffset: 54,
                                                        child: Text(
                                                          docs[index]['result'],
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        ),
                                                      ),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
        ),
      ),
    );
  }
}
