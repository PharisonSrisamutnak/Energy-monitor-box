import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:view/APInotificationsetting.dart';
import 'package:view/Register.dart';
import 'package:view/Status.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'Device.dart';
import 'APIID_Device.dart';
import 'notification.dart';
import 'notification_setting.dart';

class APIGettotal extends StatelessWidget {
  
    var  boob;
    var  pass;
    APIGettotal({this.boob,this.pass});
    
    @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: '',name:boob.toString(),password:pass.toString()),
    ); 
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key,required this.title,required this.name,required this.password}) : super(key: key);

  final String title;
  final String name;
  final String password;
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();

  Future<List<User>> _getUsers() async {
         print('++++++++++++++++++++++++API GET TOKEN+++++++++++++++++++++');
    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/get_Totals/'+box.read('ID_Device').toString()+'/'+box.read('ID_User').toString()));
    print('---------');
    print(data); 
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/get_Totals/'+box.read('ID_Device').toString()+'/'+box.read('ID_User').toString()));
    }
    var jsonData = jsonDecode(data.body);
    
    print('data.statusCode');
    print(data.statusCode);
    
    print(jsonData);
    List<User> users = [];
    if(jsonData.toString() != 'false'){
      box.write('total1', jsonData[0]);
      box.write('total2', jsonData[1]);
      box.write('total3', jsonData[2]);
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatusWidget()),);
    }

    print(jsonData);
     print('++++++++++++++++++++++++++++++++++++++++++++++++-');
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].Date),
                      subtitle: Text(snapshot.data[index].Time),
                      onTap: (){
                        Navigator.push(context, 
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
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
          title: Text(user.ID_User),
        )
    );
  }
}

class User {
  final String ID_User;
  final String Name_User;
  final String Password;
 
  User(this.ID_User, this.Name_User, this.Password);
}