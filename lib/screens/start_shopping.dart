import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/order_detail.dart';
import 'package:driver/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';



class StartShopping extends StatefulWidget {


  String orderId;
  String incrementId;
  StartShopping(this.orderId, this.incrementId);

  @override
  _StartShoppingState createState() => _StartShoppingState();
}


dynamic orderInfoJson;


class _StartShoppingState extends State<StartShopping> {

  @override
  void initState() {
    super.initState();
    orderProductList = new List();
    getOrderInfo();
  }



  @override
  Widget build(BuildContext context) {

    String timeToShow = '';
    String commentToShow = '';

    Future<void> _launched;

    try
    {
      timeToShow = orderInfoJson[0]['delivery_details'][0]['delivery_day']+"    ("+ orderInfoJson[0]['delivery_details'][0]['delivery_hours_from']+":"+
          orderInfoJson[0]['delivery_details'][0]['delivery_minutes_from']+"-"+orderInfoJson[0]['delivery_details'][0]['delivery_hours_to']+":"+
          orderInfoJson[0]['delivery_details'][0]['delivery_minutes_to']+")";
      commentToShow =orderInfoJson[0]['delivery_details'][0]['delivery_comment'] != null ? orderInfoJson[0]['delivery_details'][0]['delivery_comment'] : 'N/A';

    }
    catch(e)
    {
      timeToShow = "N/A";
      commentToShow = "N/A";
      print(e);
    }


    String imageUrl = "";
    try{
      imageUrl = orderInfoJson[0]['storeInfo'][0]['image'].toString();
    }
    catch(e){imageUrl = "";}
    String titleString = "";
    try{
      titleString = orderInfoJson[0]['storeInfo'][0]['name'];
    }
    catch(e)
    {
      titleString = "";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        title: Text(titleString, style: TextStyle(
          color: white
        ),),
      ),
      body: isLoading ? Container(width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width-(MediaQuery.of(context).size.width/2)-20),child: CircularProgressIndicator()) :
      ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[

                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              height: 200,
                              child: Image(
                                height: 100,
                                fit: BoxFit.cover,
                                image:  AssetImage('assets/images/drawer_backround.jpg', ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          color: blackTransparent,
                        ),
                        Align(
                          alignment: Alignment.center ,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              height: 100,
                              width: 100,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/app_icon.png',
                                image: domainURL+imageUrl,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Text("",
                              style: TextStyle(
                                  color: lightestText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    color: white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /* SizedBox(height: 20,),
                    *//*Text('You have 1 order waiting',
                      style: TextStyle(
                          color: lightText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),*//*
                    SizedBox(height: 10,),
                    Divider(),*/
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top:15.0, left: 15, right: 15),
                                child: Text(orderInfoJson[0]['customer_firstname']+ ' '+ orderInfoJson[0]['customer_lastname'],
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Text(double.parse(orderInfoJson[0]['total_qty_ordered']).toStringAsFixed(0)+' total items',
                                  style: TextStyle(
                                      color: lightText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 15, right: 15),
                                child: Text("ADDRESS: "  +orderInfoJson[0]['addresses'][0]['street']+', '+
                                    orderInfoJson[0]['addresses'][0]['city']+', '+
                                    orderInfoJson[0]['addresses'][0]['region']+', '+
                                    orderInfoJson[0]['addresses'][0]['postcode'],
                                  style: TextStyle(
                                      color: lightText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Text('Email ',
                                  style: TextStyle(
                                      color: lightestText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top:5.0, left: 15, right: 15),
                                    child: Text(orderInfoJson[0]['customer_email'],
                                      style: TextStyle(
                                          color: darkText,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Text('Telephone ',
                                  style: TextStyle(
                                      color: lightestText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:5.0, left: 15, right: 15),
                                child:
                                AutolinkText(
                                    text: orderInfoJson[0]['addresses'][0]['telephone'],
                                    textStyle: TextStyle(color: Colors.black),
                                    linkStyle: TextStyle(color: Colors.blue),
                                    onWebLinkTap: (link) => setState(() {
                                      _launched = _makePhoneCall('tel:${link}');
                                    }),
                                    onPhoneTap: (link) =>  setState(() {
                                      _launched = _makePhoneCall('tel:${link}');
                                    })
                                )
                                /*Text(orderInfoJson[0]['addresses'][0]['telephone'],
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15
                                  ),
                                ),*/
                              ),


                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Text('Instruction',
                                  style: TextStyle(
                                      color: lightestText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Text(commentToShow,
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                                child: Text('Delivery Date',
                                  style: TextStyle(
                                      color: lightestText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                                child: Text(timeToShow,
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),

                            ],
                          ),
                        )

                      ],
                    ),

                  ),

                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.only(bottom:20, top: 30),
                          padding: EdgeInsets.all(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              child: FlatButton(
                                onPressed: ()
                                {
                                  activeOrder();

                                },
                                color: accent,
                                child: isActivatingORder ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color> (white)) :Text('START SHOPPING',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                      color: white,
                                      fontSize: 16
                                  ),),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),



            ],
          )
        ],
      ),
    );
  }


  Future<void> _makePhoneCall(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isActivatingORder = false;
  Future<void> activeOrder() async {

    Map addressInfo ={"quoteId":quote_id};

    try
    {
      print(changeStatus);
      print(addressInfo);

      setState(() {
        isActivatingORder = true;
      });

      final response = await http.post(
          changeStatus,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        ///saveData(responseJson);
        print(responseJson.toString());
        

        setState(() {
          isActivatingORder = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetail(orderObject: orderInfoObject, incrementId: widget.incrementId,),
            ));

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        Navigator.pop(context);
        print(response.statusCode);
      }
      setState(() {
        isActivatingORder = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        //Navigator.pop(context);
        setState(() {
          isActivatingORder = false;
        });
        showToast("Something went wrong");
      });
    }


  }



  /*String unitCount()
  {
    double units = 0;
    for(var item in orderInfoJson[0]['items'])
    {
      units = units + double.parse(item['qty_ordered']);
    }
    return units.toStringAsFixed(0);

  }*/


  bool isLoading = false;

  void getOrderInfo() async
  {
    try
    {
      setState(() {
        isLoading = true;
      });
      print(orderInfo+widget.orderId);
      final response = await http.get(
        orderInfo+widget.orderId,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        orderInfoJson = responseJson;
        quote_id = responseJson[0]['quote_id'].toString();
        orderInfoObject = responseJson;

        orderProductList = responseJson[0]['products'] as List;
        print(orderProductList.length);
        for (int i = 0 ; i < orderProductList.length; i ++)
        {
            setItemsArray(orderProductList[i]);
        }

        //saveData(responseJson);
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
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


  setItemsArray (dynamic productsArray )
  {

    List itemsArray  = productsArray[0]['items'];
    for (int i = 0; i < itemsArray.length; i ++)
    {
          itemsArray[i][isTodo] = 1;
          itemsArray[i][isPending] = 0;
          itemsArray[i][isDone] = 0;
          itemsArray[i][pendingQuantity] = "0";
          itemsArray[i][doneQuantity] = "0";
    }


  }



}

