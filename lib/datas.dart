class Datas {
  DateTime datetime;  //기준 날짜(시작일)
  int ex_elec;      //이전달 전력량
  int spot;         //기준 지점
  double dignity;   //온도 기준선
  double consumption;  //소모량
  int type;         //계약 타입
  int welfare1;     //대가족 할인
  int welfare2;     //복지 할인
  int discomfort;   //기준 지표
  double efficiency;  //냉방효율
  int capacity;       //냉방능력

  Datas(this.datetime, this.ex_elec, this.spot, this.dignity, this.consumption, this.type, this.welfare1, this.welfare2, this.discomfort);
}

var type_dic = {1:'주택용(저압)', 2:'주택용(고압)'};
var welfare1_dic = {1:'해당없음', 2:'5인 이상 가구', 3:'출산 가구', 4:'3자녀 이상 가구', 5:'생명 유지 장치'};
var welfare2_dic = {1:'해당없음', 2:'독립유공자', 3:'국가유공자', 4:'5.18민주유공자', 5:'장애인', 6:'사회복지시설', 7:'기초생활(생계,의료)', 8:'기초생활(주거,교육)', 9:'차상위계층'};
var spot_dic = {102:'백령도', 108:'서울', 112:'인천', 119:'수원', 133:'대전', 143:'대구', 152:'울산', 156:'광주', 159:'부산', 184:'제주', 201:'강화'};
