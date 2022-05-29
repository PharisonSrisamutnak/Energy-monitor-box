import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:view/Register.dart';
import 'package:view/Status.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'Device.dart';
import 'APILog.dart';
import 'APIID_Device.dart';
import 'AddDevice.dart';
import 'notification.dart';
import 'APIGetToken.dart';
import 'Export.dart';

class Chart extends StatelessWidget {
    var  boob;
    var  pass;
    Chart({this.boob,this.pass});
    
    @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '',name:boob.toString(),password:pass.toString()),
    ); 
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,required this.title,required this.name,required this.password}) : super(key: key);

  final String title;
  final String name;
  final String password;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
   
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();

  Future<List<User>> _getUsers() async {

      print(box.read('ID_Device'));

    var data = await http.get(Uri.parse('http://35.185.185.123:8000/chart/'+box.read('ID_Device')+'/'+box.read('Log_date')));
    while (data.statusCode != 200) {
        data = await http.get(Uri.parse('http://35.185.185.123:8000/chart/'+box.read('ID_Device')+'/'+box.read('Log_date')));
      }
    var jsonData = jsonDecode(data.body);

    print('---------chart-------');
    box.write('chart',jsonData.toString());
    print(box.read('chart'));

    List<User> users = [];

     //Navigator.push(context,new MaterialPageRoute(builder: (context) => chartshowDemoState()));
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      body: Container(
          child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print(snapshot.data);
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading...")
                  )
                );
                
              } else {
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //Body Container
                          Image.network(box.read('chart').toString()),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      );
  }
}


class User {
  final String ID_User;
  final String Name_User;
  final String Password;
 
  User(this.ID_User, this.Name_User, this.Password);
}

