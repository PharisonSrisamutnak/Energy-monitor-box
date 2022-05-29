import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:view/Register.dart';
import 'package:view/Status.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';



import 'login.dart';
import 'Device.dart';
import 'APIID_Device.dart';
import 'notification.dart';

class APInotificationsetting extends StatelessWidget {
  
    var  boob;
    var  pass;
    APInotificationsetting({this.boob,this.pass});
    
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
  
    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/settingNoti/'+box.read('ID_User').toString()+'/'+box.read('statusnotisetting').toString()));
    print('---------');
    print(data);
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/settingNoti/'+box.read('ID_User').toString()+'/'+box.read('statusnotisetting').toString()));
    }
    
    var jsonData = jsonDecode(data.body);
    print('*******************API NOTI PAGE******************');
    print('data.statusCode');
    print(data.statusCode);
    
    print(jsonData);
    List<User> users = [];
    box.read('statusnotisetting');
    print('API Status_Nontification Token is: ');
    print(box.read('statusnotisetting'));

    if(box.read('statusnotisetting').toString() == "0"){
      print("APInotification is : 0");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text("Notification is off."),
            // actions: <Widget>[
            //   FlatButton(
            //     child: new Text("OK"),
            //     onPressed: ()
            //     {
                                 
            //     },
            //   ),
            // ],
          );
        },
      );
      Navigator.push(context,MaterialPageRoute(builder: (context) => StatusWidget()),          
      );  
    }
    if(box.read('statusnotisetting').toString() == "1"){
      print("APInotification is : 1");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Notification is on."),
            // actions: <Widget>[
            //   FlatButton(
            //     child: new Text("OK"),
            //     onPressed: ()
            //     {
            //       Navigator.push(context,MaterialPageRoute(builder: (context) => StatusWidget()),         
            //       );
            //     },
            //   ),
            // ],
          );
        },
      );
      Navigator.push(context,MaterialPageRoute(builder: (context) => StatusWidget()),         
      );
    }
    print(jsonData);
     print('******************************************************');
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

