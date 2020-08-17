import 'package:flutter/material.dart';
import 'calcfunc.dart';
import 'resultpage.dart';
import 'package:intl/intl.dart';
import 'datas.dart';
import 'helppage.dart';

class RoomPage extends StatefulWidget {
  final Datas d;

  RoomPage(this.d, {Key key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  double real_height = 0.0;
  double real_width = 0.0;
  double full_height = 0.0;
  final currency = NumberFormat("###,###,000", "en_US");
  double _dragPostion = 0;
  double _dragPercentage = 0;
  int man_state=0;
  int bg_state=0;
  List<String> bg_list = [
    'assets/images/bg1.png',
    'assets/images/bg2.png'
  ];
  List<String> ondo_list = [
    'assets/images/ondo1.png',
    'assets/images/ondo2.png'
  ];
  List<String> man_list = [
    'assets/images/man1.png',
    'assets/images/man2.png',
    'assets/images/man3.png',
    'assets/images/man4.png',
  ];

  Future<List<double>> mediaQuerySize(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padd = MediaQuery.of(context).padding;

    if (size.width > 0) {
      if ((size.height / size.width) < 1.5) {
        bg_state = 1;
      } else {
        bg_state = 0;
      }

      return [
        (size.height - padd.top - padd.bottom),
        (size.width - padd.left - padd.right),
        size.height
      ]; //real_h, real_w, full_h
    } else {
      await Future.delayed(Duration(milliseconds: 100));
      return await mediaQuerySize(context);
    }
  }

  void set_man_state() {
    setState(() {
      if (widget.d.discomfort==2) {
        if (widget.d.dignity>28) {
          man_state = 3;
        } else if (widget.d.dignity > 25) {
          man_state = 2;
        } else if (widget.d.dignity > 22) {
          man_state = 1;
        } else {
          man_state = 0;
        }
      } else {
        if (widget.d.dignity>78) {
          man_state = 3;
        } else if (widget.d.dignity > 75) {
          man_state = 2;
        } else if (widget.d.dignity > 72) {
          man_state = 1;
        } else {
          man_state = 0;
        }
      }
    });
  }

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0;
    double _ondo2 = 0;

    if (val.dy <= 0) {
      newDragPosition = full_height;
    } else if (val.dy >= full_height) {
      newDragPosition = 0;
    } else {
      newDragPosition = full_height - val.dy;
    }

    _ondo2 = widget.d.discomfort == 2
        ? (_dragPercentage / 0.0388) + 13.0
        : (_dragPercentage / 0.0388) + 63.0;
    _ondo2 = (_ondo2 * 2).floor() / 2;

    setState(() {
      _dragPostion = newDragPosition;
      _dragPercentage = _dragPostion / real_height;
      widget.d.dignity = _ondo2;
      set_man_state();
    });
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _updateDragPosition(offset);
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(start.globalPosition);
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    setState(() {
      _dragPercentage = _dragPercentage - (_dragPercentage % 0.0388);
      _dragPostion = (_dragPercentage * real_height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: Color(0xFFFFEFE1),
            child: FutureBuilder(
                future: mediaQuerySize(context),
                builder: (BuildContext context, AsyncSnapshot snapshot_size) {
                  if (snapshot_size.hasData == false) {
                    return CircularProgressIndicator();
                  } else {
                    real_height = snapshot_size.data[0];
                    real_width = snapshot_size.data[1];
                    full_height = snapshot_size.data[2];
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(bg_list[bg_state]),
                            fit: BoxFit.fitWidth),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        floatingActionButton: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                return HelpPage();
                              }));
                            },
                            child: Icon(Icons.help),
                            backgroundColor: Color(0xFFC99E71),
                          ),
                        ),
                        body: Padding(
                            padding: EdgeInsets.all(0),
                            child: Stack(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset(
                                            ondo_list[widget.d.discomfort - 1],
                                            height: real_height * 1,
                                            fit: BoxFit.fitHeight),
                                      ),
                                    ]),
                                Positioned(
                                  bottom: real_height*0.15,
                                    left: real_width*0.05,
                                    child: Container(
                                      //margin: EdgeInsets.fromLTRB(100, 300, 0, 0),
                                      child: Image.asset(
                                          man_list[man_state],
                                          width: real_height * 0.275,
                                          fit: BoxFit.fitWidth),
                                    ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedOpacity(
                                    opacity: widget.d.discomfort == 2
                                        ? ((widget.d.dignity - 13) / 25) * 0.7
                                        : ((widget.d.dignity - 63) / 25) * 0.7,
                                    duration: Duration(milliseconds: 200),
                                    child: AnimatedContainer(
                                      width:
                                          real_width * 1,
                                      height: widget.d.discomfort == 2
                                          ? real_height *
                                              (0.04 * (widget.d.dignity - 13))
                                          : real_height *
                                              (0.04 * (widget.d.dignity - 63)),
                                      //widget.d.discomfort==2? real_height * (0.2776 + (0.0384 * (widget.d.dignity - 20))): real_height * (0.2776 + (0.0384 * (widget.d.dignity - 70))),
                                      duration: Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 4.0,
                                            color: Colors.red.shade200,
                                          ),
                                        ),
                                        gradient: new LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.red,
                                            Colors.red,
                                          ],
                                        ),
                                      ),
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                        future: DBHelper().calc_tax(widget.d),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                          if (snapshot.hasData == false) {
                                            return CircularProgressIndicator();
                                          }
                                          //error가 발생하게 될 경우 반환하게 되는 부분
                                          else if (snapshot.hasError) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Error: ${snapshot.error}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            );
                                          }
                                          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                          else {
                                            int ex_price =
                                                (snapshot.data[0] / 10).floor() *
                                                    10;
                                            int new_price =
                                                (snapshot.data[1] / 10).floor() *
                                                        10 -
                                                    ex_price;

                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    real_width * 0.03,
                                                    real_height * 0.1,
                                                    0,
                                                    0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Text('+',
                                                            style: TextStyle(
                                                                fontSize:
                                                                real_height *
                                                                        0.08,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xFF000000))),
                                                      ],
                                                    ),
                                                    Container(
                                                      width:
                                                          (new_price + ex_price) >
                                                                  1000000
                                                              ? real_width * 0.55
                                                              : real_width * 0.5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                              '${currency.format(ex_price)}',
                                                              textAlign:
                                                                  TextAlign.right,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  real_height *
                                                                          0.07,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF000000))),
                                                          Text(
                                                              '${currency.format(new_price)}',
                                                              textAlign:
                                                                  TextAlign.right,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  real_height *
                                                                          0.07,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF000000))),
                                                          Divider(
                                                              color:
                                                                  Colors.black),
                                                          Text(
                                                              '${currency.format(new_price + ex_price)}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  real_height *
                                                                          0.07,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF000000))),
                                                          //Text('${currency.format(snapshot.data)}'),
                                                          //Text('${currency.format(widget.d.ex_value)}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Opacity(
                                        opacity: 0,
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          width: real_width * 1,
                                          height: real_height,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onHorizontalDragUpdate:
                                          (DragUpdateDetails update) =>
                                              _onDragUpdate(context, update),
                                      onHorizontalDragStart:
                                          (DragStartDetails start) =>
                                              _onDragStart(context, start),
                                      onHorizontalDragEnd: (DragEndDetails end) =>
                                          _onDragEnd(context, end),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        AnimatedContainer(
                                          width: real_width * 0.025,
                                          height: widget.d.discomfort == 2
                                              ? real_height *
                                                  (0 +
                                                      (0.04 *
                                                          (widget.d.dignity -
                                                              13)))
                                              : real_height *
                                                  (0 +
                                                      (0.04 *
                                                          (widget.d.dignity -
                                                              63))),
                                          duration: Duration(milliseconds: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                          ),
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                        child: RaisedButton(
                                          color: Color(0xFFC99E71),
                                          child: Text('상세내용',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFFEFE1))),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder:
                                                    (BuildContext context) {
                                              return ResultPage(widget.d);
                                            }));
                                          },
                                        ),
                                      )
                                    ]),
                              ],
                            )),
                      ),
                    );
                  }
                })));
  }
}
