import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart'; //lib ที่ใช้
import 'package:mqtt_client/mqtt_server_client.dart'; //lib ที่ใช้
import 'package:view/APIAddDevice.dart';
import 'package:view/APIGetToken.dart';
import 'package:view/APILog.dart';
import 'package:get_storage/get_storage.dart';

import 'Device.dart';
import 'login.dart';
import 'AddDevice.dart';
import 'APIID_Device.dart';
import 'notification.dart';
import 'notification_setting.dart';
import 'Export.dart';


class StatusWidget extends StatefulWidget {
  final test1;
  StatusWidget({this.test1});
  @override

  State<StatusWidget> createState() => _MyHomePageState(test2 : test1);
}

class _MyHomePageState extends State<StatusWidget> {
  final box = GetStorage();

  

  final test2;
  _MyHomePageState({this.test2});
  int _counter = 0;
  List<dynamic> str  = [0, 0, 0];
  List<dynamic> str1 = [0, 0, 0];
  List<dynamic> str2 = [0, 0, 0];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  mqttConect() async {

  String ID_Device = box.read('ID_Device'.toString());


    MqttServerClient client =
        new MqttServerClient('35.185.185.123', 'smartphone');
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    try {
      await client.connect('mymqtt', 'myraspi');
    } on NoConnectionException catch (e) {
      log(e.toString());
    }

    client.subscribe('statu/sub/'+ID_Device+'/1', MqttQos.atMostOnce);
    

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message); //ได้ payload จาก topic
      setState(() {
        str = pt.split(","); //นำ payload ที่แปลงเป็น string ใส่ใน List
      });
      
      //log(str.toString()); //แสดง List ทาง Debug
       print("log1");
       print(str);
       
      // print("---------"); 
    });
    
    MqttServerClient client1 =
        new MqttServerClient('35.185.185.123', 'smartphone1');
    client1.keepAlivePeriod = 60;
    client1.autoReconnect = true;
    client1.onConnected = onConnected;
    client1.onDisconnected = onDisconnected;

    try {
      await client1.connect('mymqtt', 'myraspi');
    } on NoConnectionException catch (e) {
      log(e.toString());
    }

    client1.subscribe('statu/sub/'+ID_Device+'/2', MqttQos.atMostOnce);

    client1.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess1 = c![0].payload as MqttPublishMessage;
      final pt1 = MqttPublishPayload.bytesToStringAsString(
          recMess1.payload.message); //ได้ payload จาก topic
      setState(() {
        str1 = pt1.split(","); //นำ payload ที่แปลงเป็น string ใส่ใน List
      });
      
      log(str.toString()); //แสดง List ทาง Debug
      // print("log2");
      // print(str1);
      // print("---------");
    });

    MqttServerClient client2 =
        new MqttServerClient('35.185.185.123', 'smartphone2');
    client2.keepAlivePeriod = 60;
    client2.autoReconnect = true;
    client2.onConnected = onConnected;
    client2.onDisconnected = onDisconnected;

    try {
      await client2.connect('mymqtt', 'myraspi');
    } on NoConnectionException catch (e) {
      log(e.toString());
    }

    client2.subscribe('statu/sub/'+ID_Device+'/3', MqttQos.atMostOnce);
  
    client2.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess2 = c![0].payload as MqttPublishMessage;
      final pt2 = MqttPublishPayload.bytesToStringAsString(
          recMess2.payload.message); //ได้ payload จาก topic
      setState(() {
        str2 = pt2.split(","); //นำ payload ที่แปลงเป็น string ใส่ใน List
      });
      
      log(str2.toString()); //แสดง List ทาง Debug
      print("log3");
      print(str2);
      print("---------");
    });
  }

  onConnected() {
    log('Connected');
  }

  onDisconnected() {
    log('Disconnected');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mqttConect();
  }

@override


Widget build(BuildContext context) {
  print('--------------------------Status Page--------------------------');
  final box = GetStorage();
  print(box.read('ID_User'));
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, centerTitle: true,title: Text("ERS"),),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero,
        children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child:  Text('Electricity Reporting System',
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
              ),
              
            ),
            ListTile(
              title: const Text('Device'),
              onTap: () {
                box.write('IdDevicemode', '1');
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => APIID_Device()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Status'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => StatusWidget()),         
                  );
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => APILogpage()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Export report'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => Export()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Register Notification'),
              onTap: () {
                Navigator.pop(context);
                 Navigator.push(
                    context,MaterialPageRoute(builder: (context) => NotificationDemo()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Status Notification'),
              onTap: () {
                Navigator.pop(context);
                 Navigator.push(
                    context,MaterialPageRoute(builder: (context) => APIGetnotification()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Add Device'),
              onTap: () {
                Navigator.pop(context);
                 Navigator.push(
                    context,MaterialPageRoute(builder: (context) => AddDeviceDemo()),         
                  );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => LoginDemo()),         
                  );
              },
            ),
          ],
        ),
        ),
      backgroundColor: Colors.white,
      //You should use `Scaffold` if you have `TextField` in body.
      //Otherwise on focus your `TextField` won`t scroll when keyboard popup.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[     
            //Body Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0,bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("สถานะไฟฟ้า",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2.0,bottom:         0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Sensor1 :",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0,bottom:15.0,left:20),
                      child: Container(
                        width: 350,
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21),
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(21),
                          ),
                          color : Color.fromRGBO(255, 255, 255, 1),
                          border : Border.all(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          width: 2,
                        ),
                      ),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(' แรงดันไฟฟ้า : ' + str[0].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' กระแสไฟฟ้า : '  + str[1].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' วัตต์ : '  + str[2].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' หน่วยไฟฟ้า : '  + box.read('total1').toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                     ),          
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2.0,bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Sensor2 :",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0,bottom:15.0,left:20),
                      child: Container(
                        width: 350,
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21),
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(21),
                          ),
                          color : Color.fromRGBO(255, 255, 255, 1),
                          border : Border.all(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          width: 2,
                        ),
                      ),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(' แรงดันไฟฟ้า : ' + str1[0].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' กระแสไฟฟ้า : '  + str1[1].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' วัตต์ : '  + str1[2].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' หน่วยไฟฟ้า : '  + box.read('total2').toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                     ),          
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2.0,bottom: 0.0),
                      alignment: Alignment.topLeft,
                      child: Text("Sensor3 :",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0,bottom:15.0,left:20),
                      child: Container(
                        width: 350,
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius : BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21),
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(21),
                          ),
                          color : Color.fromRGBO(255, 255, 255, 1),
                          border : Border.all(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          width: 2,
                        ),
                      ),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(' แรงดันไฟฟ้า : ' + str2[0].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' กระแสไฟฟ้า : '  + str2[1].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' วัตต์ : '  + str2[2].toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  Text(' หน่วยไฟฟ้า : '  + box.read('total3').toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                     ),          
                    ),
                    Container(
                     //child: Text(test2),
                      alignment: Alignment.center,
                    ),
                    Container(
                     child: Text(''),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ),

            
            Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.orange,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
    print('----------------------------------------------------------');
  }
  
}