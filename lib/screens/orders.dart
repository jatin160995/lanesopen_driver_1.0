import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/widgets/order_list_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  List<String> lista = new List();
  var items = List();

  var refreshKey = GlobalKey<RefreshIndicatorState>();




int justaNumber = 0;
  Timer timer;
  void valueSetter()
  {
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {  setState(() {
      justaNumber = 11;
     // print('valueSett');
    });});
    
  }

  @override
  void dispose()
  {
    timer.cancel();
    super.dispose();
  }

    @override
  void initState() {
    super.initState();
    valueSetter();
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
      //print(userInfo+username);
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
        //print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        //print(response.statusCode);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        actions: <Widget>[
          Container( height:40, margin: EdgeInsets.only(right: 15),child: Center(child: Text('Earnings: \$'+totalEarnings.toStringAsFixed(2),
            style:
            TextStyle(fontSize: 12,
                fontWeight: FontWeight.bold),
          )
          )
          )
        ],
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


  double totalEarnings = 0;
  Widget getDD(dynamic variable)
  {
    totalEarnings = 0;
    if(variable.length == 0)
    {
      return  Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
    }
    List<Widget> list = new List<Widget>();
    for(int i =0; i < variable.length; i++){
      if(variable[i]['status'] != "processing" && variable[i]['status'] != "pending")
      {
        List tiparray = variable[i]['driver_tip'] as List;
        String fee_amount = "0";
        try{
          //showToast(tiparray[0].toString());
          fee_amount = tiparray[0]['fee_amount'];
        }
        catch(e)
        {
          fee_amount = "0";
        }
        
        totalEarnings = totalEarnings + calculateEarnings(double.parse(fee_amount), double.parse(variable[i]['grand_total']));
       // print(totalEarnings);
        list.add(new OrderListCell(variable[i], false));
      }


    }
    if(list.length == 0)
    {
      return new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text('No Orders!',
              style:  TextStyle(
                  color: lightestText,
                  fontWeight: FontWeight.normal,
                  fontSize: 22
              ),),
            SizedBox(height: 20),
            
          ],
        ),
      );

    }
    else
      {
        
        return new Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: list);
      }

  }

}

