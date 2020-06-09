import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {


  String identifier;
  Login(this.identifier);

  @override
  _LoginState createState() => _LoginState();
}




class _LoginState extends State<Login> {
  String usernameString ;
  String passwordString ;

  final signInKey = GlobalKey<FormState>();
  //final FirebaseAuth _auth = FirebaseAuth.instance;

 /* Future<void> loginUser() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
        ),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Form(
          key: signInKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 180,
                image: AssetImage('assets/images/logo.png')
              ),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  onChanged: (text){
                    usernameString = text;

                  },
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    focusedBorder:OutlineInputBorder
                      (
                        borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    labelText: "Email/Username",
                    labelStyle: TextStyle
                      (
                        color: Colors.grey
                      ),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder
                      (
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Email cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (text){
                    passwordString = text;
                  },
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    focusedBorder:OutlineInputBorder
                      (
                      borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle
                      (
                        color: Colors.grey
                    ),
                    fillColor: Colors.white,
                    border: new OutlineInputBorder
                      (
                      borderRadius: new BorderRadius.circular(8.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {
                      return "Email cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 30,),

              Container(
                margin: EdgeInsets.only(left: 40, right:40),
                child: SizedBox(
                  width: double.infinity,
                  // height: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      //print (email);
                      loginRequest();
                      //loginUser();
                    },
                    color: primaryColor,
                    child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text(
                      'LOGIN',
                      style: TextStyle(
                        color: white,
                      ),
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }






  bool isLoading = false;

  Future<void> loginRequest() async {

    if (signInKey.currentState.validate()) {

      Map addressInfo = { 'username' : usernameString, 'password' : passwordString};

      try
      {
        print(loginUrl);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            loginUrl,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          getUserInfoFromServer();
          //saveData(responseJson);

          print(responseJson);
        }
        else
        {
         final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
          setState(() {
            isLoading = false;
          });
          print(response.statusCode);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
    else{
      print('errors');
    }

  }


  void getUserInfoFromServer() async
  {
    try
    {
      setState(() {
        isLoading = true;
      });

      print(userInfo+usernameString);
      final response = await http.get(
        userInfo+usernameString,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
       // userInfoObject = responseJson;
        saveNameData(responseJson);
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(response.statusCode);
        //Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e);
      showToast('Something went wrong');
      //Navigator.pop(context);

    }

  }

 /* void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(user_token, data);
    preferences.setString(username, usernameString);
    preferences.setString(password, passwordString);
    preferences.setBool(is_logged_in, true);

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }*/

  void saveNameData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

    print(data[0]['email']);
    preferences.setString(user_id, data[0]['user_id']);
    preferences.setString(firstname, data[0]['firstname']);
    preferences.setString(lastname, data[0]['lastname']);
    preferences.setString(email, data[0]['email']);
    preferences.setString(username, usernameString);
    preferences.setString(password, passwordString);
    preferences.setBool(is_logged_in, true);
    if(widget.identifier == 'finish')
    {
      Navigator.pop(context);
    }
    else if(widget.identifier == 'home')
    {
     // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    }
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }





  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



/*
focusedBorder:OutlineInputBorder(
borderSide: const BorderSide(color: primaryColor, width: 2.0),
borderRadius: BorderRadius.circular(25.0),
)*/
