import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'roompage.dart';
import 'package:intl/intl.dart';
import 'datas.dart';
import 'calcfunc.dart';
import 'helppage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //광고 admob 적용
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-6906871181988858~7575945029');
    //ca-app-pub-6906871181988858~7575945029
    //ca-app-pub-3940256099942544~3347511713 // test ID
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[
        'C97158959CA68CCF26AD29B523315B64'
      ], // Android emulators are considered test devices
    );

    BannerAd myBanner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
        anchorType: AnchorType.bottom,
      );

    return MaterialApp(
      title: 'Dignity_line',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KO'),
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;
  final textFieldCtrl1 = TextEditingController();
  final textFieldCtrl2 = TextEditingController();
  final textFieldCtrl3 = TextEditingController();
  Datas datas = Datas(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), 350, 119, 25, 1.8, 1, 1, 1, 2); //기준기간, 전달사용량, 기준지점, 기준온도, 전기효율, 타입

  void _handleRadioValueChange(int value) {
    setState(() {
      datas.discomfort = value;
      datas.dignity = (datas.discomfort==2)? 25: 75;
      });
  }

  @override
  void initState() {
    super.initState();

    DBHelper().initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xFFC99E71),
                  floating: true,
                  expandedHeight: 250,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Image.asset(
                            'assets/images/city.png',
                            fit: BoxFit.cover),
                        right: 0,
                        left: 0,
                        top: 0,
                        height: 250,
                      ),
                      Positioned(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(50),
                            ),
                          ),
                        ),
                        bottom: -1,
                        left: 10,
                        right: 10,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(0)),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Text("기준 지표",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF946637))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.help, color: Color(0xFF946637),),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return HelpPage();
                                                }));
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('기온',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF946637))),
                                            Radio(
                                              value: 2,
                                              groupValue: datas.discomfort,
                                              onChanged: _handleRadioValueChange,
                                              activeColor: Color(0xFF946637),
                                            ),
                                            Text('불쾌지수',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF946637))),
                                            Radio(
                                              value: 1,
                                              groupValue: datas.discomfort,
                                              onChanged: _handleRadioValueChange,
                                              activeColor: Color(0xFF946637),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Text("계약 종류",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF946637))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.help, color: Color(0xFF946637),),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return HelpPage();
                                                }));
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                        child: DropdownButton(
                                            value: datas.type,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text(type_dic[1],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(type_dic[2],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 2,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                datas.type = value;
                                              });
                                            })),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Text("기존 사용량 (월간)",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF946637))),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.number,
                                            controller: textFieldCtrl1,
                                            decoration: InputDecoration(
                                              hintText: '500',
                                              errorText: _validate1 ? '필수 입력 사항입니다.' : null,
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              WhitelistingTextInputFormatter.digitsOnly
                                            ],
                                          ),
                                        ),
                                        Text('  kWh',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF946637))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text("에어컨 냉방효율",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF946637))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.help, color: Color(0xFF946637),),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return HelpPage();
                                                }));
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.number,
                                            controller: textFieldCtrl2,
                                            decoration: InputDecoration(
                                              hintText: '5.1',
                                              errorText: _validate2 ? '필수 입력 사항입니다.' : null,
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              WhitelistingTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}')),
                                            ],
                                          ),
                                        ),
                                        Text('  W/W',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF946637))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text("에어컨 정격냉방능력",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF946637))),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.help, color: Color(0xFF946637),),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return HelpPage();
                                                }));
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: TextFormField(
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.number,
                                            controller: textFieldCtrl3,
                                            decoration: InputDecoration(
                                              hintText: '7200',
                                              errorText: _validate3 ? '필수 입력 사항입니다.' : null,
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              WhitelistingTextInputFormatter(RegExp(r'^(\d+)?\.?\d{0,2}')),
                                            ],
                                          ),
                                        ),
                                        Text('  W',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF946637))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text("대가족/생명유지 요금",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF946637))),
                                    ),
                                    Container(
                                        child: DropdownButton(
                                            value: datas.welfare1,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text(welfare1_dic[1],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare1_dic[2],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare1_dic[3],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 3,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare1_dic[4],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 4,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare1_dic[5],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 5,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                datas.welfare1 = value;
                                              });
                                            })),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text("복지할인요금",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF946637))),
                                    ),
                                    Container(
                                        child: DropdownButton(
                                            value: datas.welfare2,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[1],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[2],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[3],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 3,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[4],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 4,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[5],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 5,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[6],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 6,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[7],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 7,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[8],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 8,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(welfare2_dic[9],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 9,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                datas.welfare2 = value;
                                              });
                                            })),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text('시작 날짜',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF946637))),
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              showDatePicker(
                                                  locale: const Locale('ko', 'KO'),
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2019),
                                                  lastDate: DateTime(2023))
                                                  .then((date) {
                                                setState(() {
                                                  datas.datetime =
                                                  date != null ? date : datas.datetime;
                                                });
                                              });
                                            },
                                            color: Color(0xFFC99E71),
                                            child: Text(
                                              DateFormat.yMMMMd("ko_KO").format(datas.datetime),
                                              style: TextStyle(color: Color(0xFFFFEFE1)),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.date_range),
                                            onPressed: () {
                                              showDatePicker(
                                                  locale: const Locale('ko', 'KO'),
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2019),
                                                  lastDate: DateTime(2023))
                                                  .then((date) {
                                                setState(() {
                                                  datas.datetime =
                                                  date != null ? date : datas.datetime;
                                                });
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text("기준 지점",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF946637))),
                                    ),
                                    Container(
                                        child: DropdownButton(
                                            value: datas.spot,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text(spot_dic[102],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 102,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[108],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 108,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[112],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 112,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[119],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 119,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[133],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 133,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[143],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 143,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[152],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 152,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[156],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 156,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[159],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 159,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[184],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 184,
                                              ),
                                              DropdownMenuItem(
                                                child: Text(spot_dic[201],
                                                    style: TextStyle(color: Color(0xFF946637))),
                                                value: 201,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                datas.spot = value;
                                              });
                                            })),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                  color: Color(0xFFC99E71),
                                  child: Text('계 산',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFEFE1))),
                                  onPressed: () {
                                    setState(() {
                                      if (textFieldCtrl1.text.isEmpty) {
                                        _validate1 = true;
                                      } else if (textFieldCtrl2.text.isEmpty) {
                                        _validate2 = true;
                                      } else if (textFieldCtrl3.text.isEmpty) {
                                        _validate3 = true;
                                      } else {
                                        _validate1 = false;
                                        _validate2 = false;
                                        _validate3 = false;
                                        datas.ex_elec = int.parse(textFieldCtrl1.text);
                                        datas.consumption = double.parse(textFieldCtrl3.text) / double.parse(textFieldCtrl2.text) / 1000;
                                        datas.efficiency = double.parse(textFieldCtrl2.text);
                                        datas.capacity = int.parse(textFieldCtrl3.text);
                                        DBHelper().set_temper_table(datas);
                                      }
                                    });
                                    if (!_validate1 && !_validate2 && !_validate3) {
                                      Navigator.push(context,
                                          MaterialPageRoute<void>(builder: (BuildContext context) {
                                            return RoomPage(datas);
                                          })
                                      );
                                    }
                                  }),
                              Container(
                                height: 150,
                              ),
                            ],
                          ),
                        ),
                      ),
                )
              ],
            )
        )
    );
  }
}