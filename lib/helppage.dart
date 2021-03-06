import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HelpPage extends StatefulWidget {

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  BannerAd myBanner;
  AdWidget adWidget;

  @override
  void initState() {
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
  }

  @override
  void dispose() {
    myBanner?.dispose();
    myBanner = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFEFE1),
      appBar: AppBar(
        title: Text('도움말'),
        backgroundColor: Color(0xFF946637),
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(10,20,10,20),
        itemCount: vehicles.length,
        itemBuilder: (context, i) {
          return ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(Icons.help, color: Color(0xFF946637)),
            title: Text(vehicles[i].title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFF946637)),),
            children: <Widget>[
              Column(
                children: _buildExpandableContent(vehicles[i]),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: adWidget,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      ),
    );
  }

  _buildExpandableContent(Vehicle vehicle) {
    List<Widget> columnContent = [];

    columnContent.add(
      vehicle.image
    );
    for (String content in vehicle.contents) {
      columnContent.add(
        ListTile(
          title: Text(content, style: TextStyle(fontSize: 18.0, color: Color(0xFF946637)),),
          leading: Icon(vehicle.icon),
        ),
      );
    }

    return columnContent;
  }
}

class Vehicle {
  final String title;
  final Image image;
  List<String> contents = [];
  final IconData icon;

  Vehicle(this.title, this.image, this.contents, this.icon);
}

List<Vehicle> vehicles = [
  new Vehicle(
    '기준지표란?',
    Image.asset(
      'assets/images/null.bmp',
      height: 0,
    ),
    ['본 앱은 기온이 기준 이상일 경우에만 에어컨이 작동한다는 가정을 합니다. 이 기준이 되는 지표로 활용되는 지표는 온도와 불쾌지수 두가지 종류가 있습니다.',
      '온도는 기온을 의미하고 기준선이 되는 온도를 넘는 시간에만 에어컨을 작동합니다.',
      '불쾌지수는 열과 습도가 사람에게 주는 영향을 수치화한 지표로 온습도지수(THI)라고도 불립니다. 여름철 실내 더위에 활용되는 지표로 그 범위가 제한되어 있습니다. 불쾌 지수는 표준적인 지표가 아니라 각 기관마다 적용하는 공식이 다릅니다.',
      '80이상 매우 높음 75~80 높음 68~75 보통 ~68 미만 낮음',
    ],
    Icons.error_outline,
  ),
  new Vehicle(
    '계약 종류에 대해',
    Image.asset(
      'assets/images/null.bmp',
      height: 0,
    ),
    ['주택용(저압)은 주거용 고객으로 계약 전력 3kW 이하의 고객, 독신자 합숙소(기숙사 포함) 또는 집단 주거용 사회복지시설로서 고객이 주택용 전력의 적용을 희망하는 경우, 주거용 오피스텔 등의 경우 사용하는 형태의 전기 요금제입니다.',
      '주택용(고압)은 자체적인 변압 시설을 가지고 있는 시설에 적용되는 요금입니다. 이는 한전에서 관리하는 시설이 아니기 때문에, 저압에 비해 가격이 저렴합니다. 자체적인 관리시설을 가지고 있는 대형 아파트의 경우 이 요금에 해당하는 경우가 있습니다.',
      '저압, 고압의 구분에 대해, 전봇대 등의 전기 배선은 22.9kV의 아주 높은 고압으로 이동하는데, 이를 가정에서 사용하기 위해서는 220V로 변압할 필요가 있습니다. 일반 주택에는 이를 변압해줄 시설이 따로 없기 때문에 한전 변압기에서 이를 낮추어 변압해주고 이를 주택에 공급합니다.',
      '하지만 아파트는 공용시설(엘리베이터, 지하주차장) 등의 전기요금도 많이 들기 때문에 자체적인 변압 시설을 운용하는 경우가 많습니다. 이 경우 한전의 변압시설을 이용하지 않기 때문에 전기료가 절감되고, 관리비에 시설 운용비가 포함됩니다. ',
      '결국 저압, 고압 구분은 한전의 입장에서 공급하는 전기의 전압을 의미한다고 보면 됩니다.',
    ],
    Icons.error_outline,
  ),
  new Vehicle(
    '복지 할인에 대해',
    Image.asset(
      'assets/images/null.bmp',
      height: 0,
    ),
    ['사회적으로 보호를 필요로 하는 고객의 주거용 전력에 대해 요금을 할인하여 주는 제도입니다.',
      '5인 이상 가구, 출산 가구, 3자녀 이상 가구, 생명 유지 장치, 독립유공자, 국가유공자, 5.18민주유공자, 장애인, 사회복지시설, 기초생활(생계,의료), 기초생활(주거,교육), 차상위계층 등의 유형이 있고 복수 해당할 경우 가장 할인율이 큰 유형을 적용한다.'
    ],
    Icons.error_outline,
  ),
  new Vehicle(
    '기준지점이란?',
    Image.asset(
      'assets/images/null.bmp',
      height: 0,
    ),
    ['기준지점은 기상 자료를 수집한 장소를 선택하는 것입니다. 기준 지점에 따라 활용하는 자료와 결과는 달라집니다.',
    ],
    Icons.error_outline,
  ),
  new Vehicle(
    '기존 사용량 확인법',
    Image.asset(
      'assets/images/null.bmp',
      height: 0,
    ),
    ['전기세 고지서를 확인하거나, 인터넷을 통해 간단히 확인 가능합니다. 한국전력공사 앱을 통해 확인할 수도 있습니다.',
    ],
    Icons.error_outline,
  ),
  new Vehicle(
    '에어컨 제원 확인법',
    Image.asset(
      'assets/images/energy.png',
      width: 400,
      fit: BoxFit.fitWidth,
    ),
    ['냉방효율은 1W의 전기를 투입했을때 몇 W 만큼의 냉방 효과를 낼 수 있다는 의미입니다.',
      '정격냉방능력은 냉방 효과를 발휘하는데 사용되는 전력을 의미합니다.'
    ],
    Icons.error_outline,
  ),
];