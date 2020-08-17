import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'datas.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Temperature {
  final int datetime;
  final double temper;

  Temperature({this.datetime, this.temper});
}

class Chart_data {
  DateTime dateTime;
  double min_val;
  double max_val;

  Chart_data(this.dateTime, this.min_val, this.max_val);
}

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'temperature.db');

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load("assets/db/temperature.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path,
        version: 1,
        onCreate: (db, version) async {},
        onUpgrade: (db, oldVersion, newVersion) {},
        onOpen: (db) async {});
  }

  deleteAllNewTemper() async {
    final db = await database;
    db.rawDelete('DELETE FROM new_temperature');
  }

  Future<bool> set_temper_table(Datas datas) async {
    final db = await database;

    db.rawDelete('DELETE FROM new_temperature');

    int duration;

    if (datas.datetime.month == 2) {
      if (datas.datetime.year%4==0) {
        duration = 29;
      } else {
        duration = 28;
      }
    } else if (datas.datetime.month == 4 || datas.datetime.month == 6 || datas.datetime.month == 9 || datas.datetime.month == 11) {
      duration = 30;
    } else {
      duration = 31;
    }

    var rows = await db.rawQuery(
        "SELECT * FROM old_temperature WHERE spot=? AND datetime between ? AND ?",
        [
          datas.spot,
          '2020' + DateFormat('-MM-dd').format(datas.datetime) + ' 00:00',
          '2020' +
              DateFormat('-MM-dd')
                  .format(datas.datetime.add(Duration(days: duration)))
        ]);

    Batch batch = db.batch();
    rows.forEach((row) {
      batch.rawInsert(
          'INSERT INTO new_temperature(datetime, spot, temperature, wetness, discomfort) VALUES(?, ?, ?, ?, ?)',
          [
            row['datetime'],
            row['spot'],
            row['temperature'],
            row['wetness'],
            row['discomfort']
          ]);
    });
    batch.commit();

    return true;
  }

  cal_acc_tax(Datas datas, int cnt) async {
    int use_elec = (datas.ex_elec + (datas.consumption * cnt)).floor();
    double tax_sum = 0;
    int welfare1 = 0;
    int welfare2 = 0;



    if (datas.type==1) {
      //주택용 저압
      if (datas.datetime.month == 7 || datas.datetime.month == 8) {
        // 하계
        if (use_elec>1000) {
          tax_sum = (7300 + ((use_elec-1000) * 709.5) + 210505);
        }
        else if (use_elec>450) {
          tax_sum = (7300 + ((use_elec-450) * 280.6) + 56175);
        }
        else if (use_elec>300) {
          tax_sum = (1600 + ((use_elec-300) * 187.9) + 27990);
        }
        else {
          tax_sum = (910 + ((use_elec-0) * 93.3) + 0);
        }
      }
      else {
        // 하계 아닐때
        if ((datas.datetime.month == 12 || datas.datetime.month == 1 || datas.datetime.month == 2) && use_elec>1000) {
          //동계 슈퍼유저
          tax_sum = (7300 + ((use_elec-1000) * 709.5) + 224600);
        }
        else if (use_elec>400) {
          tax_sum = (7300 + ((use_elec-400) * 280.6) + 56240);
        }
        else if (use_elec>200) {
          tax_sum = (1600 + ((use_elec-200) * 187.9) + 18660);
        }
        else {
          tax_sum = (910 + ((use_elec-0) * 93.3) + 0);
        }
      }
    }
    else if (datas.type==2) {
      //주택용 고압
      if (datas.datetime.month == 7 || datas.datetime.month == 8) {
        // 하계
        if (use_elec>1000) {
          tax_sum = (6060 + ((use_elec-1000) * 574.6) + 164165);
        }
        else if (use_elec>450) {
          tax_sum = (6060 + ((use_elec-450) * 215.6) + 45585);
        }
        else if (use_elec>300) {
          tax_sum = (1260 + ((use_elec-300) * 147.3) + 23490);
        }
        else {
          tax_sum = (730 + ((use_elec-0) * 78.3) + 0);
        }
      }
      else {
        // 하계 아닐때
        if ((datas.datetime.month == 12 || datas.datetime.month == 1 || datas.datetime.month == 2) && use_elec>1000) {
          //동계 슈퍼유저
          tax_sum = (6060 + ((use_elec-1000) * 574.6) + 174480);
        }
        else if (use_elec>400) {
          tax_sum = (6060 + ((use_elec-400) * 215.6) + 45120);
        }
        else if (use_elec>200) {
          tax_sum = (1260 + ((use_elec-200) * 147.3) + 15660);
        }
        else {
          tax_sum = (730 + ((use_elec-0) * 78.3) + 0);
        }
      }
    }

    //대가족/생명 할인
    if (datas.welfare1==1) {
      welfare1 = 0;
    } else if (datas.welfare1==2 || datas.welfare1==3 || datas.welfare1==4) {
      welfare1 = (tax_sum * 0.3)>16000? 16000: tax_sum*0.3;
    }
    else if (datas.welfare1==5) {
      welfare1 = (tax_sum*0.3).floor();
    }

    //복지 할인
    if (datas.welfare2==1) {
      welfare2 = 0;
    } else if (datas.welfare2==2 || datas.welfare2==3 || datas.welfare2==4 || datas.welfare2==5|| datas.welfare2==7) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>20000? 20000: tax_sum;
      } else {
        welfare2 = tax_sum>16000? 16000: tax_sum;
      }
    } else if (datas.welfare2==6) {
      welfare2 = (tax_sum*0.3).floor();
    } else if (datas.welfare2==8) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>12000? 12000: tax_sum;
      } else {
        welfare2 = tax_sum>10000? 10000: tax_sum;
      }
    } else if (datas.welfare2==9) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>10000? 10000: tax_sum;
      } else {
        welfare2 = tax_sum>8000? 8000: tax_sum;
      }
    }

    tax_sum = tax_sum - (welfare1>welfare2? welfare1: welfare2);  //더 많은 쪽을 할인 적용
    tax_sum = (tax_sum + (tax_sum/10).round() + ((tax_sum*0.037/10).floor()*10));

    return tax_sum;
  }

  Future<List<double>> calc_tax(Datas datas) async {
    final db = await database;
    String standard = datas.discomfort==2? 'temperature': 'discomfort';

    var check = await db.rawQuery('SELECT COUNT(*) FROM new_temperature');
    if (check[0]['COUNT(*)']>0) {
      var res = await db.rawQuery(
          'SELECT COUNT(*) FROM new_temperature WHERE $standard>?',
          [datas.dignity]);
      int cnt = res[0]['COUNT(*)'];

      double res1 = await cal_acc_tax(datas, 0);
      double res2 = await cal_acc_tax(datas, cnt);

      return [res1, res2];
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      return await calc_tax(datas);
    }
  }

  get_chart_data(Datas datas) async {
    final db = await database;

    int i, duration;
    double max, min;
    var rows;
    List<FlSpot> chart_data=[];
    List<FlSpot> chart_data2=[];

    if (datas.datetime.month == 2) {
      if (datas.datetime.year%4==0) {
        duration = 29;
      } else {
        duration = 28;
      }
    } else if (datas.datetime.month == 4 || datas.datetime.month == 6 || datas.datetime.month == 9 || datas.datetime.month == 11) {
      duration = 30;
    } else {
      duration = 31;
    }

    for (i=1; i<=duration; i++) {
      rows = await db.rawQuery(
          "SELECT datetime, round(max(temperature),2), round(min(temperature),2) FROM new_temperature WHERE spot=? AND datetime between ? AND ?",
          [
            datas.spot,
            '2020' + DateFormat('-MM-dd').format(datas.datetime.add(Duration(days: i-1))),
            '2020' + DateFormat('-MM-dd').format(datas.datetime.add(Duration(days: i)))
          ]
      );
      chart_data.add(new FlSpot(datas.datetime.add(Duration(days: i)).millisecondsSinceEpoch.toDouble(), rows[0]['round(max(temperature),2)']));
      chart_data2.add(new FlSpot(datas.datetime.add(Duration(days: i)).millisecondsSinceEpoch.toDouble(), rows[0]['round(min(temperature),2)']));
    }

    min = datas.datetime.millisecondsSinceEpoch.toDouble();
    max = datas.datetime.add(Duration(days: i)).millisecondsSinceEpoch.toDouble();

    return [[FlSpot(min, max)], chart_data, chart_data2];
  }

  get_bar_data() async {
    final db = await database;

    int i;
    double max=0;
    var row;
    List<double> res=[];

    row = await db.rawQuery("SELECT count(*) FROM new_temperature WHERE temperature<?", [18]);
    res.add(row[0]['count(*)'] * 1.0);

    for (i=18; i<=29; i=i+2) {
      row = await db.rawQuery("SELECT count(*) FROM new_temperature WHERE temperature>=? AND temperature<?", [i, i+2]);
      res.add(row[0]['count(*)'] * 1.0);
    }

    row = await db.rawQuery("SELECT count(*) FROM new_temperature WHERE temperature>=?", [30]);
    res.add(row[0]['count(*)'] * 1.0);

    res.forEach((element) {
      if (element>max) { max = element; }
    });

    return [max] + res;
  }

  get_detail_data(Datas datas) async {
    final db = await database;

    var row = await db.rawQuery(
        'SELECT COUNT(*) FROM new_temperature WHERE temperature>?',
        [datas.dignity]);
    int cnt = row[0]['COUNT(*)'];

    int use_elec = (datas.ex_elec + (datas.consumption * cnt)).floor();
    double tax_sum = 0;
    double basic = 0;
    int welfare1 = 0;
    int welfare2 = 0;
    List<int> res = [];

    if (datas.type==1) {
      //주택용 저압
      if (datas.datetime.month == 7 || datas.datetime.month == 8) {
        // 하계
        if (use_elec>1000) {
          tax_sum = (7300 + ((use_elec-1000) * 709.5) + 210505);
          basic = 7300;
        }
        else if (use_elec>450) {
          tax_sum = (7300 + ((use_elec-450) * 280.6) + 56175);
          basic = 7300;
        }
        else if (use_elec>300) {
          tax_sum = (1600 + ((use_elec-300) * 187.9) + 27990);
          basic = 1600;
        }
        else {
          tax_sum = (910 + ((use_elec-0) * 93.3) + 0);
          basic = 910;
        }
      }
      else {
        // 하계 아닐때
        if ((datas.datetime.month == 12 || datas.datetime.month == 1 || datas.datetime.month == 2) && use_elec>1000) {
          //동계 슈퍼유저
          tax_sum = (7300 + ((use_elec-1000) * 709.5) + 224600);
          basic = 7300;
        }
        else if (use_elec>400) {
          tax_sum = (7300 + ((use_elec-400) * 280.6) + 56240);
          basic = 7300;
        }
        else if (use_elec>200) {
          tax_sum = (1600 + ((use_elec-200) * 187.9) + 18660);
          basic = 1600;
        }
        else {
          tax_sum = (910 + ((use_elec-0) * 93.3) + 0);
          basic = 910;
        }
      }
    }
    else if (datas.type==2) {
      //주택용 고압
      if (datas.datetime.month == 7 || datas.datetime.month == 8) {
        // 하계
        if (use_elec>1000) {
          tax_sum = (6060 + ((use_elec-1000) * 574.6) + 164165);
          basic = 6060;
        }
        else if (use_elec>450) {
          tax_sum = (6060 + ((use_elec-450) * 215.6) + 45585);
          basic = 6060;
        }
        else if (use_elec>300) {
          tax_sum = (1260 + ((use_elec-300) * 147.3) + 23490);
          basic = 1260;
        }
        else {
          tax_sum = (730 + ((use_elec-0) * 78.3) + 0);
          basic = 730;
        }
      }
      else {
        // 하계 아닐때
        if ((datas.datetime.month == 12 || datas.datetime.month == 1 || datas.datetime.month == 2) && use_elec>1000) {
          //동계 슈퍼유저
          tax_sum = (6060 + ((use_elec-1000) * 574.6) + 174480);
          basic = 6060;
        }
        else if (use_elec>400) {
          tax_sum = (6060 + ((use_elec-400) * 215.6) + 45120);
          basic = 6060;
        }
        else if (use_elec>200) {
          tax_sum = (1260 + ((use_elec-200) * 147.3) + 15660);
          basic = 1260;
        }
        else {
          tax_sum = (730 + ((use_elec-0) * 78.3) + 0);
          basic = 730;
        }
      }
    }

    //대가족/생명 할인
    if (datas.welfare1==1) {
      welfare1 = 0;
    } else if (datas.welfare1==2 || datas.welfare1==3 || datas.welfare1==4) {
      welfare1 = (tax_sum * 0.3)>16000? 16000: tax_sum*0.3;
    }
    else if (datas.welfare1==5) {
      welfare1 = (tax_sum*0.3).floor();
    }

    //복지 할인
    if (datas.welfare2==1) {
      welfare2 = 0;
    } else if (datas.welfare2==2 || datas.welfare2==3 || datas.welfare2==4 || datas.welfare2==5|| datas.welfare2==7) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>20000? 20000: tax_sum;
      } else {
        welfare2 = tax_sum>16000? 16000: tax_sum;
      }
    } else if (datas.welfare2==6) {
      welfare2 = (tax_sum*0.3).floor();
    } else if (datas.welfare2==8) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>12000? 12000: tax_sum;
      } else {
        welfare2 = tax_sum>10000? 10000: tax_sum;
      }
    } else if (datas.welfare2==9) {
      if (datas.datetime.month==6 || datas.datetime.month==7 || datas.datetime.month==8) {
        welfare2 = tax_sum>10000? 10000: tax_sum;
      } else {
        welfare2 = tax_sum>8000? 8000: tax_sum;
      }
    }

    res.add((basic).floor()); //기본요금
    res.add((tax_sum-basic).floor()); //전력량요금
    res.add(welfare1); //복지할인
    res.add(welfare2); //복지할인
    tax_sum = tax_sum - (welfare1>welfare2? welfare1: welfare2);  //더 많은 쪽을 할인 적용
    res.add((tax_sum).floor()); //전기요금계
    res.add((tax_sum/10).round());
    res.add(((tax_sum*0.037/10).floor()*10));
    tax_sum = (tax_sum + (tax_sum/10).round() + ((tax_sum*0.037/10).floor()*10));
    res.add(((tax_sum/10).round()*10));

    return res;  //기본요금, 전력량요금, 복지할인, 전기요금계(기본요금 ＋ 전력량요금 － 복지할인), 부가가치세, 전력산업기반기금, 청구금액
  }

  Future<List<double>> total_result(Datas datas) async {
    final db = await database;
    String standard = datas.discomfort==2? 'temperature': 'discomfort';

    var res = await db.rawQuery(
        'SELECT COUNT(*) FROM new_temperature WHERE $standard>?',
        [datas.dignity]);
    int cnt = res[0]['COUNT(*)'];

    double res1 = await cal_acc_tax(datas, 0);
    double res2 = await cal_acc_tax(datas, cnt);
    return [res1, (res2-res1), res2];
  }
}
