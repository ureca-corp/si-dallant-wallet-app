import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RewardConfirm extends StatefulWidget {
  const RewardConfirm({super.key});

  @override
  State<RewardConfirm> createState() => _RewardConfirmState();
}

class _RewardConfirmState extends State<RewardConfirm> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id = Get.arguments;

  int EP_won = 0;
  double EP_d = 0;

  int SP_won = 0;
  double SP_d = 0;
  int NP_won = 0;
  double NP_d = 0;

  List<dynamic> epList = [];
  List<dynamic> spList = [];
  List<dynamic> npList = [];
  List<dynamic> dateList = [];

  final List<ChartData> chartData = [];
  final List<ChartData> chartData2 = [];
  final List<ChartData> chartData3 = [];

  late ZoomPanBehavior _zoomPanBehavior;

  // 숫자 , 찍기 위한  함수
  var f = NumberFormat("###,###,###,###", "en_US");

  @override
  void initState() {
    //그래프 줌 옵션
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
    );
    super.initState();
    docCek12();
    docCek();
    docCek2();
    docCek3();
  }

  docCek12() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["epusdList"] == null) {
          print("EP 데이터 없음");
        } else {
          print("EP 데이터 있음");
          dateList.addAll(value.data()!["RC_date"].toList());

          print(dateList);
          // print(EP_won);
        }
      });
    });
  }

  docCek() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["epusdList"] == null) {
          print("EP 데이터 없음");
        } else {
          // epusdList
          epList.addAll(value.data()!["epusdList"].toList());
          print("EP Length : ${epList.length}");
          int i = 0;
          for (double ep in epList) {
            print('나는 $ep을 좋아해');
            if (i < epList.length) {
              i++;
              chartData.add(ChartData(dateList[i - 1].toString(),
                  int.parse(epList[i - 1].round().toString())));
            }
          }

          EP_won = value.data()!["epList"][epList.length - 1];
          EP_d = value.data()!["epusdList"][epList.length - 1];

          print("data1:::::::::");
          print(EP_won);
        }
      });
    });
  }

  docCek2() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["spusdList"] == null) {
          print("SP 데이터 없음");
        } else {
          // epusdList
          spList.addAll(value.data()!["spusdList"].toList());
          int i = 0;
          for (double sp in spList) {
            print('나는 $sp을 좋아해');
            if (i < spList.length) {
              i++;
              chartData2.add(ChartData(dateList[i - 1].toString(),
                  int.parse(spList[i - 1].round().toString())));
            }
          }

          SP_won = value.data()!["spList"][spList.length - 1];
          SP_d = value.data()!["spusdList"][spList.length - 1];

          print("data2:::::::::");
          print(dateList[i - 1].toString());
        }
      });
    });
  }

  docCek3() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["npusdList"] == null) {
          print("NP 데이터 없음");
        } else {
          // epusdList
          npList.addAll(value.data()!["npusdList"].toList());
          int i = 0;
          for (double np in npList) {
            print('나는 $np을 좋아해');
            if (i < npList.length) {
              i++;
              chartData3.add(ChartData(dateList[i - 1].toString(),
                  int.parse(npList[i - 1].round().toString())));
            }
          }

          NP_won = value.data()!["npList"][npList.length - 1];
          NP_d = value.data()!["npusdList"][npList.length - 1];

          print("data3:::::::::");
          print(dateList[i - 1].toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reward Confirm",
            style: TextStyle(fontSize: 25, fontFamily: 'Mtext')),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500,
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffd9b552), Color(0xffedddb0)],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  // 3) Wrap chart in `SingleChildScrollView`
                  child: SfCartesianChart(
                    zoomPanBehavior: _zoomPanBehavior,
                    //String 옵션
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, String>(
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            //showCumulativeValues: true,
                            //useSeriesColor: true),
                          ),
                          dataSource: chartData,
                          color: Colors.red[600],
                          width: 4,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      LineSeries<ChartData, String>(
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            //showCumulativeValues: true,
                            //useSeriesColor: true),
                          ),
                          dataSource: chartData2,
                          color: Colors.amber[800],
                          width: 4,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      LineSeries<ChartData, String>(
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            //showCumulativeValues: true,
                            //useSeriesColor: true),
                          ),
                          dataSource: chartData3,
                          color: Colors.blue[600],
                          width: 4,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                    ],

                    primaryYAxis: NumericAxis(
                      isVisible: false,
                      numberFormat:
                          NumberFormat.currency(locale: 'en_US', name: ""),
                      labelFormat: '{value}',
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                  ),
                ),
                // 4) Add fixed decoration at the end of scroll view
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Value",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              )),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("EP",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red[600],
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("${f.format(EP_won)}원  ",
                        style: TextStyle(fontSize: 15, color: Colors.red[600])),
                    Text("/ $EP_d",
                        style: TextStyle(fontSize: 15, color: Colors.red[600])),
                    const SizedBox(width: 10),
                    Image.asset("assets/dallant-logo2.png",
                        width: 25, height: 25),
                    // Icon(Icons.pause_circle_outline, color: Colors.amber, size: 30,),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SP",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("${f.format(SP_won)}원 ",
                        style:
                            TextStyle(fontSize: 15, color: Colors.amber[800])),
                    Text("/ $SP_d",
                        style:
                            TextStyle(fontSize: 15, color: Colors.amber[800])),
                    const SizedBox(width: 10),
                    Image.asset("assets/dallant-logo2.png",
                        width: 25, height: 25),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("NP",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("${f.format(NP_won)}원 ",
                        style:
                            TextStyle(fontSize: 15, color: Colors.blue[600])),
                    Text("/ $NP_d",
                        style:
                            TextStyle(fontSize: 15, color: Colors.blue[600])),
                    const SizedBox(width: 10),
                    Image.asset("assets/dallant-logo2.png",
                        width: 25, height: 25),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
