import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void splashTimer() async
  {
    print('start');
    Future.delayed(Duration(seconds: 2) ,() {
      //Navigator.pushReplacementNamed(context, '/login');
      //SystemNavigator.pop();
      isLoggedIn();
      print('end');
    });
  }

  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
    //preferences.getBool(is_logged_in ?? false);
    try
    {
      if(!preferences.getBool(is_logged_in ?? false))
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login( 'home'),
            ));
      }
      else
      {
        Navigator.pushReplacementNamed(context, '/home');

      }
    }
    catch(e){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login( 'home'),
          ));
      print("exception");}

    //return preferences.getBool(is_logged_in ?? false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Image(
            image: AssetImage('assets/images/splash_white.png'),
          ),
        ),
      ),
    );
  }
}
