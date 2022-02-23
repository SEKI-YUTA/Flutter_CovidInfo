import 'package:covid_info/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class CovidInfoSearch extends StatefulWidget {
  const CovidInfoSearch({ Key? key }) : super(key: key);

  @override
  _CovidInfoSearchState createState() => _CovidInfoSearchState();
}

class _CovidInfoSearchState extends State<CovidInfoSearch> {
  final String baseEndPoint = "https://opendata.corona.go.jp/api/Covid19JapanAll";
  final TextEditingController _editingController = TextEditingController();
  DateTime _latest = DateTime.now().subtract(Duration(days: 2));
  DateTime? _targetDate;
  List<String> prefectures = [
    "",
    "北海道",
    "青森県",
    "岩手県",
    "宮城県",
    "秋田県",
    "山形県",
    "福島県",
    "茨城県",
    "栃木県",
    "群馬県",
    "埼玉県",
    "千葉県",
    "東京都",
    "神奈川県",
    "新潟県",
    "富山県",
    "石川県",
    "福井県",
    "山梨県",
    "長野県",
    "岐阜県",
    "静岡県",
    "愛知県",
    "三重県",
    "滋賀県",
    "京都府",
    "大阪府",
    "兵庫県",
    "奈良県",
    "和歌山県",
    "鳥取県",
    "島根県",
    "岡山県",
    "広島県",
    "山口県",
    "徳島県",
    "香川県",
    "愛媛県",
    "高知県",
    "福岡県",
    "佐賀県",
    "長崎県",
    "熊本県",
    "大分県",
    "宮崎県",
    "鹿児島県",
    "沖縄県"
  ];
  String? dropdownValue = "";
  String? _targetDay;
  String? _targetDayYesterday;
  var _targetData;
  var _targetDataYesterday;

  Future<Null> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _latest, firstDate: DateTime(2020, 1,1), lastDate: _latest);
    if(picked != null) {
      print(picked);
      formatDate(picked);
      setState(() {
        _targetDate = picked;
      });
    }
  }

  void formatDate(DateTime _dateTime) {
    // print(_dateTime);
    var formatter = NumberFormat("00");
    DateTime _yesterday = _dateTime.subtract(Duration(days: 1));
    String _year = formatter.format(int.parse(DateFormat.y().format(_dateTime)));
    String _month = formatter.format(int.parse(DateFormat.M().format(_dateTime)));
    String _day = formatter.format(int.parse(DateFormat.d().format(_dateTime)));
    String _year_yesterday = formatter.format(int.parse(DateFormat.y().format(_yesterday)));
    String _month_yesterday = formatter.format(int.parse(DateFormat.M().format(_yesterday)));
    String _day_yesterday = formatter.format(int.parse(DateFormat.d().format(_yesterday)));
    setState(() {
      _targetDay = "${_year}-${_month}-${_day}";
      _targetDayYesterday = "${_year_yesterday}-${_month_yesterday}-${_day_yesterday}";
    });
  }

  // require date order
  void fetchData() async {
    if(_targetDay == null || _targetDayYesterday == null) return;
    String _option = "?date=${_targetDay!.replaceAll("-", "")}";
    String _option_yesterday = "?date=${_targetDayYesterday!.replaceAll("-", "")}";
    http.get(Uri.parse(baseEndPoint + _option)).then(
      (response) {
        var decoed = utf8.decode(response.bodyBytes);
        var json =  jsonDecode(decoed);
        if(json["itemList"].length >= 1) {
          setState(() {
            _targetData = json["itemList"];
          });
          context.read<CovidInfo>().setTargetData(json["itemList"]);
        }
      }
    );
    http.get(Uri.parse(baseEndPoint + _option_yesterday)).then(
      (response) {
        var decoed = utf8.decode(response.bodyBytes);
        var json =  jsonDecode(decoed);
        print(json["itemList"][0]);
        print(json['itemList'].length);
        if(json["itemList"].length >= 1) {
          setState(() {
            _targetDataYesterday = json["itemList"];
          });
          context.read<CovidInfo>().setTargetDataYesterday(json["itemList"]);
        }
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('過去のデータを検索'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => _pickDate(context), child: Text('日付を選択')),
              SizedBox(width: 5,),
              Text("${_targetDay != null ? _targetDay : "選択されていません"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ],
          ),
          Row(
            
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // FittedBox(
              //   child: Container(
              //     child: DropdownButton(
              //       items: prefectures.map<DropdownMenuItem<String>>((String value) =>
              //       DropdownMenuItem(child: Text(value))
              //     ).toList()
              //     , onChanged: (String? newValue) {
              //       setState(() {
              //         dropdownValue = newValue!;
              //       });
              //     }),
              //   ),
              // ),
              ElevatedButton(onPressed: () => fetchData(), child: Text('検索')),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _targetData != null && _targetDataYesterday != null ? List.generate(_targetData.length, (index) =>
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(_targetData[index]["date"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          Text(_targetData[index]["name_jp"], style: TextStyle(fontSize: 16),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('累計感染者数:${_targetData[index]["npatients"]}人', style: TextStyle(fontSize: 16),),
                          SizedBox(width: 5,),
                          Text('新規感染者数: ${int.parse(_targetData[index]["npatients"]) - int.parse(_targetDataYesterday[index]["npatients"])}人', style: TextStyle(fontSize: 16),)
                        ],
                      )
                    ],
                  ),
                )
                ) : [Text('選択されていません')],
              ),
            ),
          )
        ],
      ),
    );
  }
}