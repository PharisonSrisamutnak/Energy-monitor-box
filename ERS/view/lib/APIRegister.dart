import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'Register.dart';


class APIregister extends StatelessWidget {
    var boob;
    var pass;
    APIregister({this.boob,this.pass});
    
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(title: '',name:boob.toString(),password:pass.toString()),
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

    print('/////ID_device/////');
    print(box.read('Username'));
    print('/////Password/////');
    print(box.read('Password'));

    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/Register/'+box.read('Username').toString()+'/'+box.read('Password').toString()));
    
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/Register/'+box.read('Username').toString()+'/'+box.read('Password').toString()));
    }
    var jsonData = jsonDecode(data.body);
    print("Jsondata: APIRegister");
    print(jsonData);

    List<User> users = [];

    if(jsonData.toString() == "false"){
      print("Register_false");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Please enter new username or password again."),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: ()
                {
                  Navigator.of(context).pop();  
                  Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterDemo()),         
                  ); 
                },
              ),
            ],
          );
        },
      );   
    }
    if(jsonData.toString() == "true"){
      print("Register_true");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Register complete."),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: ()
                {
                  Navigator.of(context).pop();
                  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginDemo()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
   print("End Jsondata: APIRegister");
   print(jsonData);
    return users;
  }  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.orange,
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
                        // Navigator.push(context, 
                        //   new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                        // );
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
       
    );
  }
}

class User {
  final String ID_User;
  final String Name_User;
  final String Password;
 
  User(this.ID_User, this.Name_User, this.Password);
}

