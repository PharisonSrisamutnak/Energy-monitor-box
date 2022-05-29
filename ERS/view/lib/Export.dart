import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';


import 'Status.dart';

class Export extends StatefulWidget {
  @override
  DateSelect createState() => DateSelect();
}



class DateSelect extends State<Export> {
  final box = GetStorage();
  var start = "";
  var end = "";
  _getreport() async {
     print('Export funtion');
      var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/History/'+box.read('ID_Device').toString()+'/'+box.read('datestarttext').toString()+'/'+box.read('dateendtext').toString()));
      while(data.statusCode != 200){
        data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/History/'+box.read('ID_Device').toString()+'/'+box.read('datestarttext').toString()+'/'+box.read('dateendtext').toString()));
      }
      var jsonData = data.body;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss').format(now);
      print(formattedDate);
      if (await Permission.storage.request().isGranted) {      
//store file in documents folder

      String dir = (await getExternalStorageDirectory())!.path + "/"+start+"-->"+end+"-->"+formattedDate+".json";
      String file = "$dir";
      print(dir);
      File f = new File(file);

// convert rows to String and write as csv file

      //String csv = const ListToCsvConverter().convert(employeeData);
      f.writeAsString(jsonData);
    }else{
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Export complete."),
          );
        },
      );
  }

  
  @override
  Widget build(BuildContext context) {
    start = box.read('datestarttext').toString();
    end = box.read('dateendtext').toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Export report'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            
            Container(
              height: 60.0,
              alignment: Alignment.center,
              child: Text("Select Start Date",style: TextStyle(
                fontFamily: 'Bai Jamjuree',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
            ),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                fixedSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  final now = DateTime.now();
                    DateTime date = new DateTime(now.year, now.month, now.day);
                    DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2022, 3, 5),
                      maxTime: date,
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var datestarttext = date.toString().split(" ");
                    box.write('datestarttext',datestarttext[0]);
                    start = datestarttext[0].toString();
                    print(datestarttext[0]);
                    print(DateTime.now());
                    print('confirm $date');
                    setState(() {});
                  //  _con(start,end);
                  }, currentTime: DateTime.now(), locale: LocaleType.th);
                },
                child: Text(
                  'Time Start',
                  style: TextStyle(color: Colors.black,
                  fontFamily: 'Bai Jamjuree',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,),
                  
                )),
                Container(
                  height: 60.0,
                  alignment: Alignment.center,
                  child: Text("Select End Date",style: TextStyle(
                    fontFamily: 'Bai Jamjuree',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                fixedSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  final now = DateTime.now();
                  DateTime date = new DateTime(now.year, now.month, now.day);
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2022, 3, 5),
                      maxTime: date,
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var dateendtext = date.toString().split(" ");
                    end = dateendtext[0].toString();
                    print(dateendtext[0]);
                    print('confirm $date');
                    box.write('dateendtext',dateendtext[0]);
                    setState(() {});
                   // _con(start,end);
                  }, currentTime: DateTime.now(), locale: LocaleType.th);
                },

                child: Text(
                  'Time End',
                  style: TextStyle(color: Colors.black,
                  fontFamily: 'Bai Jamjuree',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,),
                )),
                Container(
                  height: 80.0,
                  alignment: Alignment.center,
                  child: Text("Your Select Date",style: TextStyle(
                    fontFamily: 'Bai Jamjuree',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
                ),
               Container(
                height: 25.0,
                alignment: Alignment.center,
                child: Text(start.toString()+'  -->  '+end.toString(),style: TextStyle(
                  fontFamily: 'Bai Jamjuree',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
                ),
                Container(
                height: 50.0,
                alignment: Alignment.center,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                fixedSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  _getreport();

                },
                child: Text(
                  'Export report',
                  style: TextStyle(color: Colors.black,
                  fontFamily: 'Bai Jamjuree',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,),
                )),
          ],
        ),
      ),
    );
  }   
}