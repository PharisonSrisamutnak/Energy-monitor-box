import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:view/Register.dart';
import 'package:view/Status.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'Device.dart';
import 'AddDevice.dart';
import 'APIGettotal.dart';

class APIID_Device extends StatelessWidget {
  var boob;
  var pass;
  APIID_Device({this.boob, this.pass});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(
        title: 'Select Device',
        name: boob.toString(),
        password: pass.toString(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key? key,
      required this.title,
      required this.name,
      required this.password})
      : super(key: key);

  final String title;
  final String name;
  final String password;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  List view = [];
  List<User> users = [];
  
  Future<List<User>> _getUsers() async {
    if (box.read('IdDevicemode') == '1') {
    print('ID_User');
    box.read('ID_User');
    
    var data = await http.get(Uri.parse(
        'https://electricityreportingsystemproject.com/userDevice/' +
            box.read('ID_User').toString()));

    while (data.statusCode != 200) {
      data = await http.get(Uri.parse(
          'https://electricityreportingsystemproject.com/userDevice/' +
              box.read('ID_User').toString()));
    }
    
    var jsonData = jsonDecode(data.body);

    print('ID_Device');
    print(data.body);

    print('---------');

    print('Status device: ');
    print(data.body);

    print('has device?');
    print(jsonData);
    print('----------');

    box.write('status_device', data.body);

    if (data.body == "false") {
      print("ยังไม่ได้ลงทะเบียน อุปกรณ์");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("The device has not been registered."),
          );
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddDeviceDemo()),
      );
    } else {
      var txt = jsonData[0].toString().split(":");
      print(txt[1].toString().split("}"));
      print(jsonData.length);

      for (var u = 0; u < jsonData.length; u++) {
        var txt = jsonData[u].toString().split(":");
        var txt1 = txt[1].toString().split("}");
        var txt2 = txt1[0].toString().split(" ");
        print(txt2[1]);
        User user = User(txt2[1].toString());

        users.add(user);
      }
    }
    box.write('IdDevicemode', '0');
    }
    box.write('IdDevicemode', '0');
    print(users);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: 20.0),
          //   child: GestureDetector(
          //     onTap: () {
                
          //     },
              // child: Icon(Icons.delete),
          //   ),
          // )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //print(snapshot.data);
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].ID_Device),
                    //subtitle: Text(snapshot.data[index].Time),
                    onTap: () {
                      //print(snapshot.data[index].ID_Device);
                      box.write('ID_Device',
                          snapshot.data[index].ID_Device.toString());
                      print('API_ID_Device :');
                      print(box.read('ID_Device'));
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                APIGettotal()), //DetailPage(snapshot.data[index])
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.ID_Device),
      ),
    );
  }
}

class User {
  final String ID_Device;

  User(
    this.ID_Device,
  );
}
