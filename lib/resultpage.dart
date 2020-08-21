import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'calcfunc.dart';
import 'datas.dart';
import 'package:intl/intl.dart';
import 'helppage.dart';

class ResultPage extends StatefulWidget {
  Datas d;

  ResultPage(this.d);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final currency = NumberFormat("###,###,000", "en_US");

  int get_duration() {
    int duration = 30;

    if (widget.d.datetime.month == 2) {
      if (widget.d.datetime.year % 4 == 0) {
        duration = 28;
      } else {
        duration = 27;
      }
    } else if (widget.d.datetime.month == 4 ||
        widget.d.datetime.month == 6 ||
        widget.d.datetime.month == 9 ||
        widget.d.datetime.month == 11) {
      duration = 29;
    } else {
      duration = 30;
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('상세 결과'),
          backgroundColor: Color(0xFF946637),
        ),
        backgroundColor: Color(0xFFFFEFE1),
        floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                    return HelpPage();
                  }));
            },
            child: Icon(Icons.help),
            backgroundColor: Color(0xFFC99E71),
          ),
        ),
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 90),
            child: ListView(
              children: <Widget>[
                FutureBuilder(
                    future: DBHelper().total_result(widget.d),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      } else {
                        return GridView.count(
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(15),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      '${spot_dic[widget.d.spot]}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFF81420A),
                                        fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center),
                                  Text(
                                      '지점',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF81420A)),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      '${DateFormat.yMMMMd("ko_KO").format(widget.d.datetime)} \n~\n ${DateFormat.yMMMMd("ko_KO").format(widget.d.datetime.add(Duration(days: get_duration())))}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF81420A),
                                        fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center),
                                  Text(
                                      '날짜 범위',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF81420A)),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      '${widget.d.discomfort == 1 ? "불쾌지수" : "기온"}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFF81420A),
                                        fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center),
                                  Text(
                                      '지표',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF81420A)),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      '${widget.d.dignity} ${widget.d.discomfort == 1 ? "DI" : "°C"}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFF81420A),
                                        fontWeight: FontWeight.bold,),
                                      textAlign: TextAlign.center),
                                  Text(
                                      '기준선',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF81420A)),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                Card(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  color: Color(0xFFFFF9F1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        color: Color(0xFFD4995E),
                        child: Text('평균 기온 그래프',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Color(0xFFFFFFFF)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: FutureBuilder(
                                future: DBHelper().get_chart_data(widget.d),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return LineChart(
                                      LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: const Color(0xFFFFEFE1),
                                              strokeWidth: 1,
                                            );
                                          },
                                          getDrawingVerticalLine: (value) {
                                            return FlLine(
                                              color: const Color(0xff37434d),
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 22,
                                            textStyle: const TextStyle(
                                                color: Color(0xFF81420A),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            getTitles: (value) {
                                              switch (value.toInt()) {
                                              }
                                              return '';
                                            },
                                            margin: 8,
                                          ),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            textStyle: const TextStyle(
                                              color: Color(0xFF81420A),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            getTitles: (value) {
                                              switch (value.toInt()) {
                                                case 15:
                                                  return '15°C';
                                                case 20:
                                                  return '20°C';
                                                case 25:
                                                  return '25°C';
                                                case 30:
                                                  return '30°C';
                                                case 35:
                                                  return '35°C';
                                              }
                                              return '';
                                            },
                                            reservedSize: 28,
                                            margin: 12,
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                            show: true,
                                            border: Border.all(
                                                color: const Color(0xFF81420A),
                                                width: 1)),
                                        minX: snapshot.data[0][0].x,
                                        maxX: snapshot.data[0][0].y,
                                        minY: 15,
                                        maxY: 40,
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: snapshot.data[1],
                                            isCurved: true,
                                            colors: [Color(0xFF81420A)],
                                            barWidth: 2,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                    radius: 2,
                                                    color: Color(0xFFFFFFFF),
                                                    strokeWidth: 2,
                                                    strokeColor: Color(0xFF81420A));
                                              },
                                            ),
                                            belowBarData: BarAreaData(
                                              show: false,
                                              colors: [Color(0xFF81420A)],
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: snapshot.data[2],
                                            isCurved: true,
                                            colors: [Color(0xFF81420A)],
                                            barWidth: 2,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                    radius: 2,
                                                    color: Color(0xFFFFFFFF),
                                                    strokeWidth: 2,
                                                    strokeColor: Color(0xFF81420A));
                                              },
                                            ),
                                            belowBarData: BarAreaData(
                                              show: false,
                                              colors: [Color(0xFFFFEFE1)],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                })),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: DBHelper().get_bar_data(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      } else {
                        return Card(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Color(0xFFFFF9F1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                color: Color(0xFFD4995E),
                                child: Text(
                                  '온도대 별 카운트 표',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: const Color(0xFFFFFFFF),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: snapshot.data[0] + 30,
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Colors.transparent,
                                          tooltipPadding:
                                              const EdgeInsets.all(0),
                                          tooltipBottomMargin: 3,
                                          getTooltipItem: (
                                            BarChartGroupData group,
                                            int groupIndex,
                                            BarChartRodData rod,
                                            int rodIndex,
                                          ) {
                                            return BarTooltipItem(
                                              rod.y.round().toString(),
                                              TextStyle(
                                                color: Color(0xFF81420A),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: SideTitles(
                                          showTitles: true,
                                          textStyle: TextStyle(
                                              color: const Color(0xFF81420A),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          margin: 20,
                                          getTitles: (double value) {
                                            switch (value.toInt()) {
                                              case 18:
                                                return '~18°C';
                                              case 20:
                                                return '20°C';
                                              case 22:
                                                return '22°C';
                                              case 24:
                                                return '24°C';
                                              case 26:
                                                return '26°C';
                                              case 28:
                                                return '28°C';
                                              case 30:
                                                return '30°C';
                                              case 32:
                                                return '30°C~';
                                              default:
                                                return '';
                                            }
                                          },
                                        ),
                                        leftTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      borderData: FlBorderData(
                                          show: false,
                                          border: Border.all(
                                              color: Color(0xFF81420A),
                                              width: 1.0,
                                              style: BorderStyle.solid)),
                                      barGroups: [
                                        BarChartGroupData(x: 18, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[1],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 20, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[2],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 22, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[3],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 24, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[4],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 26, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[5],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 28, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[6],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 30, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[7],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                        BarChartGroupData(x: 32, barRods: [
                                          BarChartRodData(
                                              y: snapshot.data[8],
                                              color: Color(0xFF81420A))
                                        ], showingTooltipIndicators: [
                                          0
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }),
                FutureBuilder(
                    future: DBHelper().get_detail_data(widget.d),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      } else {
                        return Card(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                          color: Color(0xFFFFF9F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                color: Color(0xFFD4995E),
                                child: Column(
                                  children: <Widget>[
                                    Text('상세 내역',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text('누진세',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '기본요금(원미만 절사): ${currency.format(snapshot.data[0])}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '전력량요금(원미만 절사): ${currency.format(snapshot.data[1])}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '전기요금 합계: ${currency.format(snapshot.data[0] + snapshot.data[1])}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text('복지할인(원미만 절사)',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '${welfare1_dic[widget.d.welfare1]}: -${currency.format(snapshot.data[2])}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '${welfare2_dic[widget.d.welfare2]}: -${currency.format(snapshot.data[3])}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '가장 감액이 큰 유형을 적용: -${currency.format(snapshot.data[2] > snapshot.data[3] ? snapshot.data[2] : snapshot.data[3])}원',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text('전기요금계',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text('기본요금 + 전력량요금 - 복지할인:',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '${currency.format(snapshot.data[0])} + ${currency.format(snapshot.data[1])} - ${currency.format(snapshot.data[2] > snapshot.data[3] ? snapshot.data[2] : snapshot.data[3])} = ${currency.format(snapshot.data[4])}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '전기요금계(원미만 절사): ${currency.format(snapshot.data[4])}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text('추가 부담금',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '부가가치세(원미만 반올림): ${currency.format(snapshot.data[5])}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '전력산업기반기금(10원미만 반올림): ${currency.format(snapshot.data[6])}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '추가 부담금(원미만 절사): ${currency.format(snapshot.data[5] + snapshot.data[6])}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF81420A)),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 5,
                                color: Color(0xFFD4995E),
                                child: Column(
                                  children: <Widget>[
                                    Text('합계',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                    Text('(누진세) - (복지할인) + (추가부담금) = (합계)',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '${currency.format(snapshot.data[0] + snapshot.data[1])} - ${currency.format((snapshot.data[2] > snapshot.data[3] ? snapshot.data[2] : snapshot.data[3]))} + ${currency.format(snapshot.data[5] + snapshot.data[6])} = ${currency.format(snapshot.data[7])}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                        textAlign: TextAlign.center),
                                    Text(
                                        '청구금액: ${currency.format(snapshot.data[7])}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        )));
  }
}
