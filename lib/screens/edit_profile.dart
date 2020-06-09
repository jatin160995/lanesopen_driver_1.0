import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  String fName = "";
  String lName = "";
  String email1 = "";


  EditProfile(this.fName, this.lName, this.email1);

  @override
  _EditProfileState createState() => _EditProfileState();
}



class _EditProfileState extends State<EditProfile> {



  String userId = "";

  //String firstnameString = widget.fName;
  //String lastnameString = "";
  //String emailString = "";

  bool isUpdated = false;


  void saveNameData() async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(firstname, widget.fName);
    preferences.setString(lastname, widget.lName);
    preferences.setString(email, widget.email1);
    Navigator.pop(context);

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }


  bool isLoading = false;
  final signInKey = GlobalKey<FormState>();

  Future<void> loginRequest() async {

    if (signInKey.currentState.validate()) {

      Map addressInfo = {"user_id":userId, "firstname":widget.fName, "lastname":widget.lName, "email":widget.email1};

      try
      {
        print(editProfileUrl);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            editProfileUrl,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          //saveData(responseJson);
          showToast("Profile updated Successfully");
          //Navigator.pop(context);
          saveNameData();
          print(responseJson);
        }
        else
        {
          showToast('Something went wrong');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {




    void getUserDetail() async
    {

      var preferences = await SharedPreferences.getInstance();
      setState(() {
        userId = preferences.getString(user_id ?? "");
        //print(email1);
      });

    }

    getUserDetail();



    return Scaffold(
      body: Form(
        key: signInKey,
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
                child: Text("Edit Profile",
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              initialValue: widget.fName,
                              onChanged: (text){
                                widget.fName = text;
                              },
                              cursorColor: primaryColor,
                              decoration: new InputDecoration(
                                focusedBorder:OutlineInputBorder
                                  (
                                  borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                labelText: "Firstname",
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
                                  return "First name can not be empty";
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
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              initialValue: widget.lName,
                              onChanged: (text){
                                widget.lName = text;
                              },
                              cursorColor: primaryColor,
                              decoration: new InputDecoration(
                                focusedBorder:OutlineInputBorder
                                  (
                                  borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                labelText: "Lastname",
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
                                  return "Last name cannot be empty";
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
                        ),

                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        initialValue: widget.email1,
                        onChanged: (text){
                          widget.email1 = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Email",
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
                          loginRequest();
                          //print(userId);
                        },
                        textColor: white,
                        child: isLoading ? CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color> (white),) : Text("UPDATE"),
                      ),
                    ),
                    SizedBox(height: 40,),
                    FlatButton(
                      child: Text('Change Password'),
                      onPressed: (){
                        Navigator.pushNamed(context, '/password');
                      },
                    )



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
