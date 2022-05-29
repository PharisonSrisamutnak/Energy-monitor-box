import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'APILog.dart';
import 'Status.dart';
import 'Device.dart';
import 'AddDevice.dart';
import 'APIID_Device.dart';

class APIAddDevice extends StatelessWidget {
    var boob;
    APIAddDevice({this.boob});

  Widget build(BuildContext context){
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: '',name:boob.toString()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  const MyHomePage({Key? key,required this.title,required this.name,}) : super(key: key);

  final String title;
  final String name;
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
   
}

class _MyHomePageState extends State<MyHomePage> {
final box = GetStorage();

  Future<List<User>> _getUsers() async {

    String ID_Device = box.read('ID_Device').toString();
    String ID_User = box.read('ID_User').toString();

    print("___ID_User____");
    print(ID_User);
    print("___ID_Device____");
    print(ID_Device);
    
    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/addDevice/'+ID_Device+'/'+ID_User));
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/addDevice/'+ID_Device+'/'+ID_User));
    }
    
    var jsonData = jsonDecode(data.body);
    print("Jsondata: APIAddDevice");
    print(jsonData);
    
    List<User> users = [];
    if(box.read('IdDevicemode') == '1'){
      if(jsonData.toString() == "false"){
            print("AddDevice_false");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Please enter ID_Device again."),
                );
              },
            );
            Navigator.push(
            context,MaterialPageRoute(builder: (context) => AddDeviceDemo()),         
            ); 
          }
    }
    
    if(jsonData.toString() == "true"){
      box.write('IdDevicemode', '0');
      print("AddDevice_true");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("complete."),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: ()
                {
                  box.write('IdDevicemode', '1');
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => APIID_Device()),         
                  );
                },
              ),
            ],
          );
        },
      );
    
    }
     print("___End_ID_Device____");
    return users;
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, centerTitle: true,title: Text("ERS"),),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero,
        children: [
         DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text('Electricity Reportling System'),
              
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,MaterialPageRoute(builder: (context) => DeviceDemo()),         
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
              title: const Text('nontification'),
              onTap: () {
                Navigator.pop(context);
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

