import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DlChart extends StatefulWidget {
  const DlChart({super.key});

  @override
  State<DlChart> createState() => _DlChartState();
}

class _DlChartState extends State<DlChart> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id = Get.arguments;

  int count = 0;
  List<dynamic> wonList = [];
  List<dynamic> usdList = [];
  List<dynamic> dateList = [];

  List<double> usdConvert = [];
  List<int> wonConvert = [];

  final List<ChartData> chartData = [];
  final List<ChartData> chartData2 = [];
  late ZoomPanBehavior _zoomPanBehavior;

  String usd = "0.00";
  String won = "0";

  // 숫자 , 찍기 위한  함수
  var f = NumberFormat("###,###,###,###", "en_US");
  var fd = NumberFormat("###,###,###,###.0#", "en_US");

  @override
  void initState() {
    //그래프 줌 옵션
    _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    super.initState();
    docCek();
    docCek2();
  }

  docCek() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["wonList"] == null) {
          print("데이터가 없을때");
        } else {
          print("데이터 있음");

          wonList.addAll(value.data()!["wonList"]);
          dateList.addAll(value.data()!["dateList"]);

          int i = 0;

          for (String wp in wonList) {
            print('나는 $wp을 좋아해');
            if (i < wonList.length) {
              i++;
              chartData.add(ChartData(dateList[i - 1].toString(),
                  int.parse(wonList[i - 1].toString())));
            }
          }

          won = value.data()!["wonList"][value.data()!["wonList"].length - 1];
        }
      });
    });
  }

  docCek2() async {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc(id);
    userCollectionReference.get().then((value) {
      setState(() {
        if (value.data()!["wonList"] == null) {
          print("데이터가 없을때");
        } else {
          print("데이터 있음");

          usdList.addAll(value.data()!["usdList"]);

          int i = 0;

          for (String up in usdList) {
            print('나는 $up을 좋아해');
            if (i < usdList.length) {
              i++;
              chartData2.add(ChartData(dateList[i - 1].toString(),
                  int.parse(usdList[i - 1].toString())));
            }
          }

          usd = value.data()!["usdList"][value.data()!["usdList"].length - 1];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dallant",
          style: TextStyle(fontSize: 25, fontFamily: 'Mtext'),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500,
            height: 350,
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
                  child: SfCartesianChart(
                    zoomPanBehavior: _zoomPanBehavior,
                    //String 옵션
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, String>(
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              showCumulativeValues: true,
                              useSeriesColor: true),
                          dataSource: chartData,
                          color: Colors.red[600],
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                      LineSeries<ChartData, String>(
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              showCumulativeValues: true,
                              useSeriesColor: true),
                          dataSource: chartData2,
                          color: Colors.amber[800],
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                    ],
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
                Image.asset("assets/dallant-logo2.png", width: 25, height: 25),
                Row(
                  children: [
                    Text("1.00 DL",
                        style: TextStyle(fontSize: 15, color: Colors.red[600])),
                    Text("/${f.format(int.parse(won))}원",
                        style: TextStyle(fontSize: 15, color: Colors.red[600])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 17, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 30,
                  color: Colors.amber[700],
                ),
                Row(
                  children: [
                    Text("1.00 DL",
                        style:
                            TextStyle(fontSize: 15, color: Colors.amber[800])),
                    Text("/${fd.format(double.parse(usd))}0USD",
                        style:
                            TextStyle(fontSize: 15, color: Colors.amber[800])),
                  ],
                ),
              ],
            ),
          ),
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
