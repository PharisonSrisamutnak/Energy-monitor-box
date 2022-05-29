import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:view/APIStatus.dart';
import 'package:view/login.dart';
import 'APIAddDevice.dart';
import 'package:get_storage/get_storage.dart';

import 'login.dart';
import 'APILog.dart';
import 'Status.dart';
import 'Device.dart';

class AddDeviceDemo extends StatefulWidget {
  @override
  _AddDeviceDemoState createState() => _AddDeviceDemoState();
}

class _AddDeviceDemoState extends State<AddDeviceDemo> {
  final box = GetStorage();
  @override
   TextEditingController _DeviceController = TextEditingController();

  Widget build(BuildContext context) {
  
    return Scaffold(

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.orange,
              alignment: Alignment.center,
            ),
                      Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: Text("Register Device",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Container(
                       margin: EdgeInsets.only(top: 15.0,bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                            controller: _DeviceController,
                            decoration: new InputDecoration(
                            hintText: "Enter ID_Device",
                            border: OutlineInputBorder()
                            ),
                          ),
                        ],
                       ),
                     ),
                      Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text('Register Device'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            fixedSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: ()
                        {
                          if(_DeviceController.text.isEmpty){
                              print('Empty Fields');
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Please complete the information."),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: new Text("OK"),
                                          onPressed: ()
                                          {
                                             Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              return;
                            }
                            else
                            {   
                                box.write('IdDevicemode', '1');
                                box.write('ID_Device',_DeviceController.text.toString(),);
                                print('/ID_device/');
                                print(box.read('ID_Device'));                            
                                Navigator.push(
                                context, MaterialPageRoute(builder: (context) => APIAddDevice(boob:_DeviceController.text)),);         
                            }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 500),
                      alignment: Alignment.bottomCenter,
                      height: 50.0,
                      padding: const EdgeInsets.all(30.0),
                      color: Colors.orange,
                    ),
          ],
        ),
      ),
    );
  }
}