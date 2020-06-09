import 'package:driver/screens/start_shopping.dart';
import 'package:driver/screens/user/user_order_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/screens/order_detail.dart';
import 'package:driver/dialog/custom_dialog.dart';

class OrderListCell extends StatefulWidget {

  dynamic orderData1;
  bool isClickable;
  OrderListCell(dynamic orderData, bool isClickable){
    this.orderData1 = orderData;
    this.isClickable = isClickable;

   // print(this.orderData1['base_currency_code']);
  }

  @override
  _OrderListCellState createState() => _OrderListCellState();

  void _sendDataToOrderScreen(BuildContext context) {

    //orderTodo = orderData1['items'];
    //orderPending = orderData1['items'];
    //orderDone = new List();

   /* for(int i =0; i < orderData1['items'].length; i++)
    {
      orderTodo.add(orderData1['items'][i]);
      orderPending.add(orderData1['items'][i]);
      print(orderData1['items'][i]);
    }*/

    dynamic textToSend = orderData1;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StartShopping(orderData1['entity_id'].toString(), orderData1['increment_id'].toString()),
        ));
  }


}





class _OrderListCellState extends State<OrderListCell> {

 /* void showDialog()
  {
    Navigator.of(context).push(
        CupertinoPageRoute(
            fullscreenDialog: false,
            builder: (context) => CustomDialog(title: "Success",
              description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              buttonText: "Accept",)
        )
    );
  }*/

 void orderDialog()
 {
   showDialog(context: context, child:
   new AlertDialog(
     title: new Text("Order"),
     content: new Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Row(
           children: <Widget>[
             Text
               (
                 "Order Id:",
                 style: TextStyle(
                     fontSize: 12,
                     color: darkText
                 )
             ),
             SizedBox(width: 5,),
             Text
               (
                 '#' + widget.orderData1['increment_id'].toString(),
                 style: TextStyle(
                     fontSize: 13,
                     color: accent,
                     fontWeight: FontWeight.bold
                 )
             ),
           ],
         ),
         SizedBox(height: 10,),
         Row(
           children: <Widget>[
             /*Expanded(
               child: Text
                 (
                   "Customer Address: " +widget.orderData1['billing_address']['street'][0] + ', ' + widget.orderData1['billing_address']['city']+ ', ' +
                       widget.orderData1['billing_address']['region'] + ', '+ widget.orderData1['billing_address']['postcode'],
                   maxLines: 5,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                       fontSize: 14,
                       color: darkText
                   )
               ),
             ),*/
             SizedBox(width: 5,),

           ],
         ),
         SizedBox(height: 10,),
         Text
           (
             "Store: "+ widget.orderData1['store_name'].toString().replaceAll('\n', " "),
             style: TextStyle(
                 fontSize: 13,
                 color: darkText
             )
         ),
       ],
     ),
     actions: <Widget>[
       FlatButton(
         onPressed: (){
           Navigator.pop(context);
         },
         child: Text("CANCEL",
             style: TextStyle(
                 color: primaryColor
             )),
       ),
       FlatButton(
         color: primaryColor,
         onPressed: (){
           Navigator.pop(context);
           widget._sendDataToOrderScreen(context);
         },
         child: Text("ACCEPT",
             style: TextStyle(
                 color: white
             )),
       )
     ],
   )
   );
 }

  @override
  Widget build(BuildContext context) {
  // print(widget.orderData1);
    return GestureDetector(
      onTap: (){
        print('pressed');
        //widget._sendDataToSecondScreen(context);
        //Navigator.pop(context);
        if(widget.isClickable)
        {
          widget._sendDataToOrderScreen(context);
        }
        else
          {
            Navigator.of(context).push(
                CupertinoPageRoute(
                    //fullscreenDialog: true,
                    builder: (context) => (UserOrderDetail(widget.orderData1['entity_id'].toString()))
                )
            );
          }


        //Navigator.pushNamed(context, '/order', arguments: widget.orderData1);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Text
                          (
                            "Order Id:",
                            style: TextStyle(
                                fontSize: 12,
                                color: darkText
                            )
                        ),
                        SizedBox(width: 5,),
                        Text
                          (
                            '#' + widget.orderData1['increment_id'].toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: accent,
                                fontWeight: FontWeight.bold
                            )
                        ),

                        SizedBox(width: 20,),
                        Text
                          (
                            '('+widget.orderData1['state'].toString() + ')',
                            style: TextStyle(
                                fontSize: 12,
                                color: darkText,
                                fontWeight: FontWeight.normal
                            )
                        ),
                      ],
                    ),
                    Text
                      (
                        widget.orderData1['customer_firstname'] + " " + widget.orderData1['customer_lastname'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: lightestText
                        )
                    ),
                    /*SizedBox(height: 5,),
                    Text
                      (
                        widget.orderData1['billing_address']['street'][0] + ', ' + widget.orderData1['billing_address']['city']+ ', ' +
                        widget.orderData1['billing_address']['region'] + ', '+ widget.orderData1['billing_address']['postcode'],
                        style: TextStyle(
                            fontSize: 12,
                            color: lightText
                        )
                    ),*/
                    /*SizedBox(height: 5,),
                    Text
                      (
                        "Store: "+ widget.orderData1['store_name'].toString().replaceAll('\n', " "),
                        style: TextStyle(
                            fontSize: 11,
                            color: blue
                        )
                    ),*/
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text
                      (
                        widget.orderData1['updated_at'].toString().split(' ')[0],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                          fontSize: 13
                        )
                    ),
                    SizedBox(height: 5,),
                    Text
                      (
                        "\$" + widget.orderData1['base_grand_total'].toString() ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: accent
                        )
                    ),
                    SizedBox(height: 5,),
                    Text
                      (
                        "Total Items: "+ widget.orderData1['total_qty_ordered'].length.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: lightText
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
