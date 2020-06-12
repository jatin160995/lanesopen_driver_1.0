import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:driver/drawer/nav_drawer.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/widgets/order_list_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*dynamic orderTodo;
dynamic orderPending;
dynamic orderDone;*/


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

List<String> lista = new List();

var items = List();



var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoggedIn();
  }



bool isLoading = false;

void getUserInfoFromServer(String username) async
{
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
      items =  responseJson[0]['items'] as List;
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
    isLoading = false;
    isLoggedIn();
    //Navigator.pop(context);

  }

}



Future<void> isLoggedIn() async
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

  /*Future<void> fetchData() async {
    print('fetchdata');

    final response = await http.get(
      'https://lanesopen.com/index.php/rest/V1/orders?searchCriteria[page_size]=30&searchCriteria[current_page]=1&searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC',
      headers: {HttpHeaders.authorizationHeader: "Bearer 64tdnqc6cuwr56a3yk2qlazwt1n8bmgf",
        HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final responseJson = json.decode(response.body);
    items = responseJson["items"] as List;
    setState(() {
      print('setstate');
    });
  }
*/
  @override
  Widget build(BuildContext context) {

    if(homeNeedRefresh)
    {
      isLoggedIn();
      homeNeedRefresh = false;
    }
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: isLoggedIn,
        child: ListView(
          children: <Widget>[

            getDD(items),

          ],
        ),
      ),
    );
  }

  Widget getDD(dynamic variable)
  {
    if(isLoading)
    {
      return  Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
    }
    List<Widget> list = new List<Widget>();
    for(int i =0; i < variable.length; i++){
      if(variable[i]['status'] == "processing" || variable[i]['status'] == "pending")
      {
        list.add(new OrderListCell(variable[i], true));
      }
    }
    if(list.length == 0)
    {
      list.add(Center(child: Container(
        margin: EdgeInsets.all(35),
        child: Text("No Orders",
        style: TextStyle(
          color: lightestText,
          fontSize: 17
        )))));
    }

   
    return new Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: list);
  }

}

