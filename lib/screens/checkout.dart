import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/user/user_order_item_cell.dart';
import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:http/http.dart' as http;


class CheckoutPage extends StatefulWidget {

  String orderId;
  CheckoutPage(this.orderId);


  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {



  bool isLoaded = false;

  String dropdownValue = '5';

  double subTotal = 0;
  double grandTotal = 0;
  double driverTip = 0;
  double shipping = 7.99;
  double serviceFeePercent = 10;
  double serviceFee = 0;
  double taxPercent = 6;
  double tax = 0;

  dynamic prodList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, "/chat");
            },
            child: Row(
              children: <Widget>[
                Icon((Icons.chat), color: primaryColor,),
                SizedBox(width: 4,),
                Text("Chat",
                    style: TextStyle(
                        color: primaryColor
                    ))
              ],
            ),
          )
        ],
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        title: Text(
            'Order Detail',
            style: TextStyle(
                color: darkText,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: ListView(
        children:
        createProduct(prodList),

      ),
    );
  }


  List<Widget> createProduct(List products)
  {
    // subTotal = 0;
    List<Widget> productList = new List();

    if(products.length > 0){
      for(int i =0; i < products.length; i++)
      {
        productList.add(UserOrderDetailCell(
          productData :products[i],
          addQuant: (){
            //setState(() {cartList[i]['quantity'] = (int.parse(cartList[i]['quantity']) + 1).toString();});
            print('add quant');
          },
          delQuant: ()
          {
            setState(() {
              /*if(cartList[i]['quantity'] == '1')
                {
                  return;
                }
                cartList[i]['quantity'] = (int.parse(cartList[i]['quantity']) - 1).toString();*/
              print('minus');
            });
          },
          delItem: ()
          {
            setState(() {
              //cartList.remove(cartList[i]);
              print('minus');
            });
          },
        )
        );
        //  subTotal = subTotal + (double.parse(products[i]['price'].toString()) * double.parse(products[i]['qty'].toString()));
      }
      //grandTotal = subTotal;
      //serviceFee = calculateDriverTip(serviceFeePercent);
      //tax = calculateTax(taxPercent, subTotal + shipping + serviceFee);

      var couponDesign = new Card(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  //textCapitalization: TextCapitalization.characters,
                  onChanged: (text)
                  {
                    //postalCode = text;
                  },
                  decoration : InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Discount Code',
                  ),
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Expanded(
              flex: 3,

              child: GestureDetector(
                onTap: ()
                {

                },
                child: Container(
                    height: 50,
                    decoration: new BoxDecoration(
                      color: primaryColor,
                      borderRadius: new BorderRadius.only(
                        bottomRight: const Radius.circular(4.0),
                        topRight: const Radius.circular(4.0),
                      ),
                    ),
                    child: Center(
                      child: Text('Apply',
                        style: TextStyle(
                          color: white,
                          fontSize: 14,

                        ),),
                    )),
              ),
            )
          ],
        ),
      );
      //productList.add(couponDesign);
      var pricesDesign = new Container(
        margin: EdgeInsets.all(15),
        color: lightGrey,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('SubTotal:'),
                Text('\$'+ subTotal.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipping:'),
                Text('\$'+ shipping.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Service Fee:'),
                Text('\$'+ serviceFee.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Tax:'),
                Text('\$'+ tax.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Driver\'s tip:'),

                Text('\$' + driverTip.toStringAsFixed(2))
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                Text('\$' + grandTotal.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            )
          ],
        ),
      );

      productList.add(pricesDesign);
      productList.add(SizedBox(height: 50));
      setState(() {

      });
      //subTotal = subTotal + driverTip;
      print(driverTip);

      var submitButton = Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: FlatButton(
          onPressed: (){
            /*Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ShippingAddress()
                )
            );*/
            //showCheckoutMethodDialog();
            // createOrder();
          },
          color: primaryColor,
          child: isLoading ?  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white)) : Text('Create Order',
            style: TextStyle(
                color: white,
                fontSize: 16
            ),),
        ),
      );
      // productList.add(submitButton);

    }
    else{
      if(isLoaded)
      {
        productList.add(new Container(
            height: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children: <Widget>[
                  Text('Cart is empty!',
                    style:  TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 22
                    ),),
                  Container(
                    height: 48,
                    width: 48,
                    child: Image.asset("assets/images/empty_cart.png"),
                  )
                ],
              ),
            )
        ));
      }
      else
      {
        productList.add(new Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/images/loading.gif'),
        ));
      }

    }
    return productList;
  }



  bool isLoading = false;

  dynamic orderInfoJson;
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
        subTotal = double.parse(double.parse(responseJson[0]['base_subtotal']).toStringAsFixed(2));
        grandTotal = double.parse(double.parse(responseJson[0]['grand_total']).toStringAsFixed(2));
        tax = double.parse(double.parse(responseJson[0]['base_tax_amount']).toStringAsFixed(2));
        driverTip = double.parse(responseJson[0]['subtotal_incl_tax'])  - double.parse(responseJson[0]['subtotal_invoiced']);
        serviceFee = double.parse(double.parse(responseJson[0]['base_fee']).toStringAsFixed(2));
        shipping = double.parse(double.parse(responseJson[0]['shipping_amount']).toStringAsFixed(2));
        //saveData(responseJson);
        prodList = responseJson[0]['items'] as List;
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
      setState(() {
        isLoading = false;
      });

      showToast('Something went wrong');
     // Navigator.pop(context);

    }

  }
}
