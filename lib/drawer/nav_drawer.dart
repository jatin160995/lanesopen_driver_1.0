import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {





    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
         /* DrawerHeader(
            child: Text(
              'Lanesopen Driver',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: primaryColor,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/splash.png'))),
          ),*/

          Container(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image(
                      height: 150,
                      fit: BoxFit.cover,
                      image:  AssetImage('assets/images/drawer_backround.jpg', ),
                    ),
                  )
                ),
                Container(
                  color: blackTransparent,
                  height: 150,
                  padding: EdgeInsets.only(left:10, right: 10, bottom: 10, top: 60),
                  child: Row(
                    children: <Widget>[
                      Image(
                        height: 30,
                        image: AssetImage('assets/images/splash_white.png'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text('Lanesopen Driver Menu',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: white
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30,),
          ListTile(
            leading: Icon(Icons.dashboard, size: 20,),
            title: Text('Dashboard',
            style: TextStyle(
              color: darkText,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),),
            onTap: () => {
              Navigator.pop(context)
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user, size: 20,),
            title: Text('Profile',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {

                Navigator.pushNamed(context, '/profile')
            },
          ),
          ListTile(
            leading: Icon(Icons.list, size: 20,),
            title: Text('Orders',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {

              Navigator.pushNamed(context, '/orders',
                )
            },
          ),
          /*ListTile(
            leading: Icon(Icons.chat, size: 20,),
            title: Text('Chat',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chat(
                ),
              ),
            )
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 20,),
            title: Text('Settings',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color, size: 20,),
            title: Text('Feedback',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {Navigator.of(context).pop()},
          ),*/
         /* ListTile(
            leading: Icon(Icons.exit_to_app,size: 20,),
            title: Text('Logout',
              style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
            onTap: () => {Navigator.of(context).pop()},
          ),*/
        ],
      ),
    );
  }








}