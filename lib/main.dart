import 'package:driver/scanner/mlkit_example.dart';
import 'package:flutter/material.dart';
import 'package:driver/screens/home.dart';
import 'package:driver/screens/splash.dart';
import 'package:driver/screens/login.dart';
import 'package:driver/screens/order_detail.dart';
import 'package:driver/screens/product_detail.dart';
import 'package:driver/screens/profile.dart';
import 'package:driver/screens/edit_profile.dart';
import 'package:driver/screens/change_password.dart';
import 'package:driver/screens/orders.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(

  /*theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.pink[800], //Changing this will change the color of the TabBar
    accentColor: Colors.cyan[600],
  ),*/
  routes: {
    //'/': (context) => ScannerClass(),
    '/': (context) => SplashScreen(),
    '/home': (context) => Home(),
    '/login': (context) => Login('home'),
    '/detail': (context) => OrderDetail(),
    '/prod': (context) => ProductDetail(),
    '/profile': (context) => Profile(),
    '/edit': (context) => EditProfile(null, null, null),
    '/password': (context) => ChangePassword(),
    '/orders': (context) => Orders(),
    //'/': (context) => Chat(),
  },

  theme: ThemeData(fontFamily: 'proxima'),
));
