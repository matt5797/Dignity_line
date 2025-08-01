import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'roompage.dart';
import 'package:intl/intl.dart';
import 'datas.dart';
import 'calcfunc.dart';
import 'helppage.dart';
import 'splashpage.dart';
import 'package:simple_page_indicator/simple_page_indicator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    //광고 admob 적용
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7449571046358730~5385730102');
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['air conditioner', 'fan', 'summer'],
      childDirected: false,
      testDevices: <String>[
        'C97158959CA68CCF26AD29B523315B64'
      ],
    );

    BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-7449571046358730/6507240084',
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
     */

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
      //home: HomePage(),
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new HomePage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formsPageViewController = PageController();
  List _forms;
  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;
  final textFieldCtrl1 = TextEditingController();
  final textFieldCtrl2 = TextEditingController();
  final textFieldCtrl3 = TextEditingController();
  Datas datas = Datas(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), 350, 119, 25, 1.8, 1, 1, 1, 2);
  BannerAd myBanner;
  AdWidget adWidget;
  Container adContainer;
  InterstitialAd myInterstitial;

  void _handleRadioValueChange(int value) {
    setState(() {
      datas.discomfort = value;
      datas.dignity = (datas.discomfort==2)? 25: 75;
      });
  }

  @override
  void initState() {
    super.initState();

    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-7449571046358730/6507240084',
      size: AdSize.banner,
      request: AdRequest(
          testDevices: <String>[
            'C97158959CA68CCF26AD29B523315B64'
          ],
      ),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    myBanner?.load();
    adWidget = AdWidget(ad: myBanner);

    myInterstitial = InterstitialAd(
      adUnitId: 'ca-app-pub-7449571046358730/2882478705',
      request: AdRequest(
        testDevices: <String>[
          'C97158959CA68CCF26AD29B523315B64'
        ],
      ),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    myInterstitial?.load();

    if ((DateTime.now().month <= 5) | (DateTime.now().month >= 10)) {
      datas = Datas(DateTime(DateTime.now().year, 8, DateTime.now().day), 350, 119, 25, 1.8, 1, 1, 1, 2);
    }
    DBHelper().initDB();
  }

  @override
  void dispose() {
    myBanner?.dispose();
    myBanner = null;
    myInterstitial?.dispose();
    myInterstitial = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _forms = [
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Step1Container(),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Step2Container(),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Step3Container(),
      ),
    ];

    return Scaffold(
        backgroundColor: Color(0xFFFFEFE1),
        floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            child: Stack(
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
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20)),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          SimplePageIndicator(
                            itemCount: _forms.length,
                            controller: _formsPageViewController,
                            maxSize: 6,
                            minSize: 3,
                            indicatorColor: Color(0xFF946637),
                            space: 14,
                          ),
                          Expanded(
                            flex: 1,
                            child: PageView.builder(
                              controller: _formsPageViewController,
                              //physics: NeverScrollableScrollPhysics(),
                              itemCount: _forms.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _forms[index];
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  top: 200,
                  bottom: -1,
                  left: 5,
                  right: 5,
                ),
              ],
            ),
        ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: adWidget,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      ),
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool onWillPop() {
    if (_formsPageViewController.page.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }

  Step1Container() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(height: 20),
              RaisedButton(
                  color: Color(0xFFC99E71),
                  child: Text('다 음',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFEFE1))),
                  onPressed: () {
                    setState(() {
                      if (textFieldCtrl1.text.isEmpty) {
                        _validate1 = true;
                      } else {
                        _validate1 = false;
                      }
                      if (textFieldCtrl2.text.isEmpty) {
                        _validate2 = true;
                      } else {
                        _validate2 = false;
                      }
                      if (textFieldCtrl3.text.isEmpty) {
                        _validate3 = true;
                      } else {
                        _validate3 = false;
                      }
                      if(!_validate1 && !_validate2 && !_validate3) {
                        datas.ex_elec = int.parse(textFieldCtrl1.text);
                        datas.consumption = double.parse(textFieldCtrl3.text) / double.parse(textFieldCtrl2.text) / 1000;
                        datas.efficiency = double.parse(textFieldCtrl2.text);
                        datas.capacity = int.parse(textFieldCtrl3.text);
                        DBHelper().set_temper_table(datas);
                      }
                    });
                    if (!_validate1 && !_validate2 && !_validate3) {
                      _nextFormStep();
                    }
                  }
              ),
            ],
          ),
      ),
    );
  }

  Step2Container() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 75),
            RaisedButton(
                color: Color(0xFFC99E71),
                child: Text('다 음',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFEFE1))),
                onPressed: () {
                  _nextFormStep();
                }
            ),
          ],
        ),
      ),
    );
  }

  Step3Container() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                DBHelper().set_temper_table(datas);
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(height: 75),
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
                    } else {
                      _validate1 = false;
                    }
                    if (textFieldCtrl2.text.isEmpty) {
                      _validate2 = true;
                    } else {
                      _validate2 = false;
                    }
                    if (textFieldCtrl3.text.isEmpty) {
                      _validate3 = true;
                    } else {
                      _validate3 = false;
                    }
                    if(!_validate1 && !_validate2 && !_validate3) {
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
                    myInterstitial?.show();
                  } else {
                    _formsPageViewController.jumpToPage(0);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
