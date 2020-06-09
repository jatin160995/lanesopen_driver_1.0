import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {









  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoggedIn();
  }

  String fName = "";
  String lName = "";
  String email1 = "";
  String userId = "";


  @override
  Widget build(BuildContext context) {





    void logout() async
    {
      var preferences = await SharedPreferences.getInstance();
      preferences.setString(user_id, "");
      preferences.setString(firstname, "");
      preferences.setString(lastname, "");
      preferences.setString(email, "");
      preferences.setString(username, "");
      preferences.setString(password, "");
      preferences.setBool(is_logged_in, false);

      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
    }


    void getUserDetail() async
    {

      var preferences = await SharedPreferences.getInstance();
      setState(() {
        userId = preferences.getString(user_id ?? "");
        fName = preferences.getString(firstname?? "");
        lName = preferences.getString(lastname ?? "");
        email1 = preferences.getString(email ?? "");
        //print(email1);
      });

    }

    getUserDetail();



    return Scaffold(

      backgroundColor: background,
      body: Stack(
        children: <Widget>[

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, bottom: 15),
              child: ListTile(
                leading: Icon(Icons.exit_to_app,size: 20,),
                title: Text('Logout',
                  style: TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                logout()
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: Container(
                height: 250,
                child: Image(
                  height: 100,
                  fit: BoxFit.cover,
                  image:  AssetImage('assets/images/drawer_backround.jpg', ),
                ),
              ),
            ),
          ),
          Container
            (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: blackTransparent,
                  height: 250,
                  child: Center(
                    child: Container(
                      height: 100,
                        width: 100,
                        child: Image.asset('assets/images/profile.png'))
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 30),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: white,),

              ),
            ),
          ),
           Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 30, right: 20),
              child: IconButton(
                onPressed: (){

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(fName, lName, email1
                      ),
                    ),
                  );
                  //Navigator.pushNamed(context, '/edit');
                },
                icon: Icon(Icons.edit, color: white,),

              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:   Container(
              margin: EdgeInsets.only(top: 200, left: 20, right: 20),
              child: isLoading ? CircularProgressIndicator() : SizedBox(
                width: double.infinity,
                child: Card(
                  child: Container(
                    height: 175,

                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text('Basic Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: <Widget>[

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('First name',
                                  style: TextStyle(
                                      color: backgroundGrey,
                                      fontSize: 11
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Text(fName,
                                  style: TextStyle(
                                      color: lightText,
                                      fontSize: 17
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 40,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Last name',
                                  style: TextStyle(
                                      color: backgroundGrey,
                                      fontSize: 11
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Text(lName,
                                  style: TextStyle(
                                      color: lightText,
                                      fontSize: 17
                                  ),
                                ),
                              ],
                            )


                          ],
                        ),


                        SizedBox(height: 15,),
                        Text('Email',
                          style: TextStyle(
                              color: backgroundGrey,
                              fontSize: 11
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text(email1,
                          style: TextStyle(
                              color: lightText,
                              fontSize: 17
                          ),
                        ),
                        SizedBox(height: 15,),
                        /*Text('Phone',
                          style: TextStyle(
                              color: backgroundGrey,
                              fontSize: 11
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text('+1 987654321',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 17
                          ),
                        ),
                        SizedBox(height: 15,),*/

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child:   Container(
              margin: EdgeInsets.only(top: 388, left: 20, right: 20),
              child: isLoading ? CircularProgressIndicator() : SizedBox(
                width: double.infinity,
                child: Card(
                  child: Container(
                    height: 105,

                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text('History',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),),
                        ),
                        Text('Order Delivered',
                          style: TextStyle(
                              color: backgroundGrey,
                              fontSize: 11
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text(profileData[0]['total_orders'][0]['count'],
                          style: TextStyle(
                              color: lightText,
                              fontSize: 17
                          ),
                        ),
                        /*SizedBox(height: 15,),
                        Text('Ratings',
                          style: TextStyle(
                              color: backgroundGrey,
                              fontSize: 11
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text('4.8',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 17
                          ),
                        ),*/

                        SizedBox(height: 15,),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          )


          /*Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text("Profiles",
                style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )*/

        ],
      )

    );
  }



  bool isLoading = false;
  dynamic profileData = '';

  void getUserInfoFromServer(String username) async
  {
    var preferences = await SharedPreferences.getInstance();
    try
    {
      setState(() {
        isLoading = true;
      });
      print(userInfo+username);
      final response = await http.get(
        userInfo+username,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
        profileData = responseJson;
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        //preferences.setString(email, value)
        showToast(responseJson['message']);
        print(response.statusCode);
        Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e);
      isLoading = false;
      showToast('Something went wrong');
      Navigator.pop(context);

    }

  }



  void isLoggedIn() async
  {
    try
    {
      isLoading = true;
      var preferences = await SharedPreferences.getInstance();
      getUserInfoFromServer(preferences.getString(username ?? ''));
    }
    catch(e)
    {
      isLoading = false;
      showToast('Something went wrong');
    }

  }



}
