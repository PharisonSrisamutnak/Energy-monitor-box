import 'package:flutter/material.dart';
//import 'package:view/APIStatus.dart';
import 'package:view/login.dart';
import 'Register.dart';
import 'APIRegister.dart';
import 'APILogin.dart';

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {  
  
  @override
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordCrotroller = TextEditingController();

  Widget build(BuildContext context) {
  print('-------------------------------Login Page----------------------------');
    _chacktext(){
  if(emailController.text.isEmpty||passwordCrotroller.text.isEmpty){
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
                },
              ),
            ],
          );
        },
      );
    return;
    print('-----------------------------------------------------------------------------------');
  }
}

return Scaffold(
      backgroundColor: Colors.white,
      //You should use `Scaffold` if you have `TextField` in body.
      //Otherwise on focus your `TextField` won`t scroll when keyboard popup.
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
                      margin: const EdgeInsets.only(top: 30.0,bottom: 30.0),
                      height: 200.0,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          image : DecorationImage(
                            image: AssetImage('assets/images/Image4.png'),
                            fit: BoxFit.fitWidth,
                          )
                        )
                      ),
                    ),
                     Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: Text("Electricity Reporting System",style: TextStyle(
                        fontFamily: 'Bai Jamjuree',
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                     Container(
                       margin: EdgeInsets.only(top: 15.0,bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                             controller: emailController,
                            decoration: new InputDecoration(
                            hintText: "Enter Username",
                            border: OutlineInputBorder()
                            ),
                          ),
                        ],
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(bottom:15.0),
                       child: Column(
                        children: <Widget>[
                           new TextFormField(
                             obscureText: true,
                             controller: passwordCrotroller,
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
                        child: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            fixedSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: ()
                        {
                          if(emailController.text.isEmpty||passwordCrotroller.text.isEmpty){
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
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              return;
                            }
                            else{
                              Navigator.push(
                               context, MaterialPageRoute(builder: (context) => APIPage1(boob:emailController.text,pass:passwordCrotroller.text)),
                              );
                            }
                        },
                      ),
                    ),
                    Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        child: const Text('Register'),
                        style: OutlinedButton.styleFrom(
                            primary: Colors.orange,
                            fixedSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: ()
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterDemo()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Footer Container
            //Here you will get unexpected behaviour when keyboard pops-up. 
            //So its better to use `bottomNavigationBar` to avoid this.
            Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.orange,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );

      //************************************************************ */
/*

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
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
                controller: emailController,
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
                controller: passwordCrotroller,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {  
                  print(emailController.text);
                   Navigator.push(
                       context, MaterialPageRoute(builder: (context) => APIPage1(boob:emailController.text,pass:passwordCrotroller.text)),
                    );
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );*/
  }
}