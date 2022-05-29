import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:view/APIStatus.dart';
import 'package:get_storage/get_storage.dart';

import 'package:view/login.dart';
import 'dart:async';
import 'APIRegister.dart';

class RegisterDemo extends StatefulWidget {
  @override
  _RegisterDemoState createState() => _RegisterDemoState();
}

class _RegisterDemoState extends State<RegisterDemo> {
  @override

  final box = GetStorage();
  
   TextEditingController _usernameController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
   TextEditingController _chackpasswordController = TextEditingController();

  Widget build(BuildContext context) {
_clearValues()
{
  _chackpasswordController.text = '';
  _usernameController.text = '';
  _passwordController.text = '';
}
    
    return Scaffold(
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
                      margin: const EdgeInsets.only(top: 10.0),                    
                      height: 60.0,
                      alignment: Alignment.topLeft,
                      child: Text("Register",style: TextStyle(
                        fontFamily:'Bai Jamjuree',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ))
                    ),
                     Container(         
                      margin: EdgeInsets.only(top: 0.0,bottom:5.0),
                      alignment: Alignment.topLeft,
                      child: Text("Username :",style: TextStyle(
                        fontFamily:'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                    ),
                    Container(
                       margin: EdgeInsets.only(top: 0.0,bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                             controller: _usernameController,
                            decoration: new InputDecoration(
                            hintText: "Enter Username",
                            border: OutlineInputBorder()
                            ),
                          ),
                        ],
                       ),
                     ),
                     Container(
                      margin: EdgeInsets.only(top: 0.0,bottom:5.0),
                      alignment: Alignment.topLeft,
                      child: Text("Password :",style: TextStyle(
                        fontFamily:'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                    ),
                    Container(
                       margin: EdgeInsets.only(top: 0.0,bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: new InputDecoration(
                            hintText: "Enter Password",
                            border: OutlineInputBorder()
                            ),
                          ),
                        ],
                       ),
                     ),
                     Container(
                      margin: EdgeInsets.only(top: 0.0,bottom:5.0),
                      alignment: Alignment.topLeft,
                      child: Text("RE-Password :",style: TextStyle(
                        fontFamily:'Bai Jamjuree',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                    ),
                    Container(
                       margin: EdgeInsets.only(top: 0.0,bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                            obscureText: true,
                            controller: _chackpasswordController,
                            decoration: new InputDecoration(
                            hintText: "Enter Password",
                            border: OutlineInputBorder()
                            ),
                          ),
                        ],
                       ),
                     ),
                     Container(
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text('Register'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            fixedSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: ()
                        {
                          if(_passwordController.text.length < 8 && _usernameController.text.length <8){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("Please enter a username or password more 8 characters."),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: new Text("OK"),
                                        onPressed: ()
                                        {
                                          Navigator.of(context).pop();
                                          _clearValues();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            return;
                          }
                          if (_chackpasswordController.text.isEmpty || _usernameController.text.isEmpty || _passwordController.text.isEmpty) {
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
                                          Navigator.of(context).pop();
                                          _clearValues();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            return;
                          }
                          String password = _passwordController.text.toString();
                          String chackpassword = _chackpasswordController.text.toString();

                          if(password != chackpassword){
                            print('Error');
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text("Please enter your password to match."),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: new Text("OK"),
                                          onPressed: ()
                                          {
                                             Navigator.pop(context);
                                             _clearValues();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              return;
                          }
                          else{
                            box.write('Username',_usernameController.text.toString(),);
                            box.write('Password',_passwordController.text.toString(),);
                            print('/user/');
                            print(box.read('Username'));
                            print('/Password/');
                            print(box.read('Password'));
                            Navigator.push(context,MaterialPageRoute(builder: (context) => APIregister(),));     
                         }
                        },
                      ),
                    ),
                    Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        child: const Text('Back'),
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orange,
                            fixedSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginDemo()),
                          );
                        },
                      ),
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
    /*
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailregisController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordregisCrotroller,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                   Navigator.push(
                       context, MaterialPageRoute(builder: (context) => APIregister(boob: emailregisController.text,pass:passwordregisCrotroller.text)),
                    );
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}