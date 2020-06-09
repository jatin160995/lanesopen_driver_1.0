import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/upload_receipt.dart';
import 'package:driver/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:maps_launcher/maps_launcher.dart';

import 'package:url_launcher/url_launcher.dart';


class ThankyouScreen extends StatefulWidget {

  dynamic orderObject;
  ThankyouScreen(this.orderObject);
  @override
  _ThankyouScreenState createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {

  @override
  void initState() {
    getOrderInfo();
    super.initState();
  }

  String totalEarning = "";
  @override
  Widget build(BuildContext context) {


String timeToShow = '';
String commentToShow = '';
   


    try
    {
      timeToShow = widget.orderObject[0]['delivery_details'][0]['delivery_day']+"    ("+ widget.orderObject[0]['delivery_details'][0]['delivery_hours_from']+":"+
          widget.orderObject[0]['delivery_details'][0]['delivery_minutes_from']+"-"+widget.orderObject[0]['delivery_details'][0]['delivery_hours_to']+":"+
          widget.orderObject[0]['delivery_details'][0]['delivery_minutes_to']+")";
      commentToShow =widget.orderObject[0]['delivery_details'][0]['delivery_comment'] != null ? widget.orderObject[0]['delivery_details'][0]['delivery_comment'] : 'N/A';

    }
    catch(e)
    {
      timeToShow = "N/A";
      commentToShow = "N/A";
      print(e);
    }
    homeNeedRefresh = true;
    //print(widget.orderObject);
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 120),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Thanks for Shopping!',
                        style: TextStyle(
                            color: darkText,
                            fontSize: 22,
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10),
                        Text(totalEarning,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                    /*Text('Order has been placed',
                        style: TextStyle(
                            color: iconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )),*/
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: 200,
                      height: 45,
                      child: FlatButton(
                        onPressed: (){
                          Navigator.popUntil(context, ModalRoute.withName('/home'));
                        },
                        color: primaryColor,
                        child: Text('Continue Shopping',
                            style: TextStyle(
                                color: white
                            )),
                      ),
                    ),

                      
                    SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                            Padding(
                                padding: const EdgeInsets.only(top:15.0, left: 15, right: 15),
                                child: Text("Delivery Information",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(top:15.0, left: 15, right: 15),
                                child: Text(widget.orderObject[0]['customer_firstname']+ ' '+ widget.orderObject[0]['customer_lastname'],
                                  style: TextStyle(
                                      color: darkText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              
                              GestureDetector(
                                onTap: (){
                                  MapsLauncher.launchQuery(widget.orderObject[0]['addresses'][0]['street']+', '+
                                      widget.orderObject[0]['addresses'][0]['city']+', '+
                                      widget.orderObject[0]['addresses'][0]['region']+', '+
                                      widget.orderObject[0]['addresses'][0]['postcode']);
                                },
                                  child: Padding(
                                  padding: const EdgeInsets.only(top:5.0, left: 15, right: 15),
                                  child: Text("ADDRESS: "  +widget.orderObject[0]['addresses'][0]['street']+', '+
                                      widget.orderObject[0]['addresses'][0]['city']+', '+
                                      widget.orderObject[0]['addresses'][0]['region']+', '+
                                      widget.orderObject[0]['addresses'][0]['postcode'],
                                    style: TextStyle(
                                        color: lightText,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.only(top:0.0, left: 15, right: 15),
                                child: Container()
                               /* AutolinkText(
                                    text: orderInfoJson[0]['addresses'][0]['telephone'],
                                    textStyle: TextStyle(color: Colors.black),
                                    linkStyle: TextStyle(color: Colors.blue),
                                    onWebLinkTap: (link) => setState(() {
                                      _launched = _makePhoneCall('tel:${link}');
                                    }),
                                    onPhoneTap: (link) =>  setState(() {
                                      _launched = _makePhoneCall('tel:${link}');
                                    })
                                )*/
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
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.call, color: primaryColor),
                                    onPressed: (){
                                      //Navigator.popUntil(context, ModalRoute.withName('/home'));
                                      _makePhoneCall('tel:${widget.orderObject[0]['addresses'][0]['telephone']}');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.location_on, color: primaryColor),
                                    onPressed: (){
                                      MapsLauncher.launchQuery(widget.orderObject[0]['addresses'][0]['street']+', '+
                                      widget.orderObject[0]['addresses'][0]['city']+', '+
                                      widget.orderObject[0]['addresses'][0]['region']+', '+
                                      widget.orderObject[0]['addresses'][0]['postcode']);
                                    },
                                  ),
                                ],
                              ),
                  ],
                ),
              )
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 120,
              margin: EdgeInsets.only(bottom: 30,),
                child: Image.asset('assets/images/logo.png')),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 15),
              decoration: new BoxDecoration(
                  color: lightGrey,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                  )
              ),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
              ),
            ),
          ),
          Align(
             alignment: Alignment.topRight,
             child: Container(
               margin: EdgeInsets.only(top: 40),
               child: FlatButton(
                 color: white,
                 child: Text("Upload Receipt",
                 style: TextStyle(
                   fontWeight: FontWeight.bold
                 ),),
                 onPressed: ()
                 {
                   Navigator.of(context).push(
                      CupertinoPageRoute(
                          //fullscreenDialog: true,
                          builder: (context) => (UploadReceipt(widget.orderObject[0]["entity_id"]))
                            )
                      );
                 },
               ),
             )
          ),
        ],
      )
    );
  }



_launchMap(BuildContext context, lat, lng) async {
}



  bool isLoading = false;

  void getOrderInfo() async
  {
    try
    {
      setState(() {
        isLoading = true;
      });
      print(orderInfo+widget.orderObject[0]["entity_id"]);
      final response = await http.get(
        orderInfo+widget.orderObject[0]["entity_id"],
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        List tiparray = responseJson[0]['driver_tip'] as List;
        String fee_amount = "0";
        try{
          //showToast(tiparray[0].toString());
          fee_amount = tiparray[0]['fee_amount'];
        }
        catch(e)
        {
          fee_amount = "0";
        }
        setState(() {
        totalEarning = "Total Earning: \$" + calculateEarnings(double.parse(fee_amount), double.parse(responseJson[0]['grand_total'])).toStringAsFixed(2);
        });
        //showToast(responseJson.toString());
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
      //showToast('Something went wrong');
      Navigator.pop(context);

    }

  }


Future<void> _makePhoneCall(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}











