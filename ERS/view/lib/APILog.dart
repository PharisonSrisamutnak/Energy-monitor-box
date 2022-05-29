import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';


import 'login.dart';
import 'Device.dart';
import 'Status.dart';
import 'chart.dart';
import 'APIID_Device.dart';
import 'Export.dart';
import 'notification.dart';
import 'APIGetToken.dart';
import 'AddDevice.dart';

class APILogpage extends StatelessWidget {
    var boob;
    APILogpage({this.boob});
    @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Log',name:(boob.toString())),
    );
  }
   
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,required this.title,required this.name}) : super(key: key);

  final String title;
  final String name;
  

  @override
  _MyHomePageState createState() => new _MyHomePageState();
   
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  
  Future<List<User>> _getUsers() async {
    final now = DateTime.now();
    String ID_Device = box.read('ID_Device').toString();
    var dateendtext = now.toString().split(" ");
    
    print('/ID_Device | APIlog/');
    print(box.read('ID_Device'));

    var data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/History/'+ID_Device+'/2022-03-1'+'/'+dateendtext[0].toString()));
    while(data.statusCode != 200){
      data = await http.get(Uri.parse('https://electricityreportingsystemproject.com/History/'+ID_Device+'/2022-03-1'+'/'+dateendtext[0].toString()));
    }

    var jsonData = jsonDecode(data.body);

    List<User> users = [];

    for(var u in jsonData){
      //print(u);

      User user = User(u["ID_Device"], u["Sensor1"], u["Sensor2"], u["Sensor3"], u["Date"]);
      
      users.add(user);
    }
    //print(users.length);
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
              } 
              else 
              {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].Date),
                      //subtitle: Text(snapshot.data[index].Time),
                      onTap: (){
                        box.write('Log_date', snapshot.data[index].Date.toString());
                        print(box.read('Log_date'));
                        Navigator.push(context,new MaterialPageRoute(builder: (context) => Chart())
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



class User {
  final String ID_Device;
  final String Sensor1;
  final String Sensor2;
  final String Sensor3;
  final String Date;
  User(this.ID_Device, this.Sensor1, this.Sensor2, this.Sensor3, this.Date);
}

