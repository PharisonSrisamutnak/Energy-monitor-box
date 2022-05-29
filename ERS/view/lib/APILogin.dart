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
import 'AddDevice.dart';

class APIPage1 extends StatelessWidget {
    var  boob;
    var  pass;
    APIPage1({this.boob,this.pass});
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
    print('----------------------------------Login API PAGE--------------------------------');
    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/Login/'+widget.name+'/'+widget.password));
    print('---------');
    print(data);
    
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/Login/'+widget.name+'/'+widget.password));
    }
    var jsonData = jsonDecode(data.body);
    
    print('data.statusCode');
    print(data.statusCode);
 
    print(jsonData);
    List<User> users = [];
    box.write('ID_User', jsonData);
    print('box is: ');
    print(box.read('ID_User'));

    // if(box.read('status_device') == "false"){
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: new Text("Register Device55555."),
    //       );
    //     },
    //   );
    //    Navigator.push(
    //                 context,MaterialPageRoute(builder: (context) => AddDeviceDemo()),         
    //               );
    // }
    if(jsonData == "not register"){
      print("Tonnnnnnnn");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Please Register."),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: ()
                {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                   MaterialPageRoute(builder: (context) => LoginDemo()),          
                  );                 
                },
              ),
            ],
          );
        },
      );
    }
    
    if(jsonData == "user or password wrong"){
      print("Tooooo");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Please enter your name and password again."),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: ()
                {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => LoginDemo()),         
                  );
                },
              ),
            ],
          );
        },
      );
    }
    if(jsonData != "not register" && jsonData != "user or password wrong"){
      box.write('IdDevicemode', '1');
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: new Text("complete."),
            // actions: <Widget>[
            //   FlatButton(
            //     child: new Text("OK"),
            //     onPressed: ()
            //     {
            //       Navigator.of(context).pop();
            //       Navigator.push(context,MaterialPageRoute(builder: (context) => APIID_Device()),         
            //       );
            //     },
            //   ),
            // ],
      //     );
      //   },
      // );
      Navigator.push(context,MaterialPageRoute(builder: (context) => APIID_Device()),         
      );
    }
    
    // for(var u in jsonData){

    //   User user = User(u["ID_User"], u["Name_User"], u["Password"]);
    //   users.add(user);
    // }

    print(jsonData);
    print('------------------------------------------------------------------------------------');
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

