import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool isLoading = false;
  final signInKey = GlobalKey<FormState>();
  String savedPassword = '';
  String usernameSaved = '';

  String oldPass = '';
  String newPAss = "";
  String cPass = "";
  String userId = "";

  void getUserDetail() async
  {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      savedPassword = preferences.getString(password ?? "");
      usernameSaved = preferences.getString(username ?? "");
      userId = preferences.getString(user_id ?? "");
      print(savedPassword);
    });
  }


  void saveNameData() async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(password, newPAss);
    Navigator.pop(context);

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

  Future<void> loginRequest() async {



    print("here");
      Map addressInfo = {"user_id":userId, "username":usernameSaved,"newpassword" : newPAss};

      try
      {
        print(changePasswordUrl);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            changePasswordUrl,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          saveNameData();
          showToast("Profile updated Successfully");
          print(responseJson);
        }
        else
        {
          showToast('Something went wrong');
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

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: signInKey,
      body: Form(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 30),
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: darkText,),

                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Text("Change Password",
                  style: TextStyle(
                      color: darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 150, left: 10, right: 10),
                child: Column(
                  children: <Widget>[

                    Container(
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (text){
                          oldPass = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Old Password",
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
                            return "Password cannot be empty";
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
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (text){
                          newPAss = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "New Password",
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
                            return "Password cannot be empty";
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
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (text){
                          cPass = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Confirm Password",
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
                            return "Password cannot be empty";
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
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8)
                        ),
                        color: primaryColor,
                        onPressed: ()
                        {
                          if(oldPass == "" || newPAss == "" || cPass == "")
                          {
                            showToast("Please fill all fields");
                          }
                          else
                          {
                            if(savedPassword != oldPass)
                            {
                              showToast("Wrong password");
                              return;
                            }
                            else
                            {
                              if(newPAss.trim() != cPass.trim())
                              {
                                showToast("Password doesn't matched!");
                                return;
                              }
                              else
                              {
                                loginRequest();
                              }
                            }
                          }

                        },
                        textColor: white,
                        child: isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(white),) :Text("UPDATE"),
                      ),
                    ),
                    SizedBox(height: 40,),




                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



