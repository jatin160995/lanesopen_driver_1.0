import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/find_item.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/utils/regex_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();

  dynamic productObject;
  dynamic index;
  dynamic itemIndex;
  ProductDetail({Key key, @required this.productObject, this.index, this.itemIndex}) : super(key: key);
}

class _ProductDetailState extends State<ProductDetail> {

  var qtyController = TextEditingController();
  int itemCount = 0;

  var foundQuantity = 0;

  
  @override
  Widget build(BuildContext context) {

    String instructionString = '';
        dynamic decodeInstruct = json.decode(widget.productObject['product_options'].toString());
        try
        {
          instructionString = decodeInstruct['info_buyRequest']['options']['instruction'];
          //print();
        }
        catch(e){
          instructionString = "N/A";
        }
    print(widget.index);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text('Enter Quantity'),
      ),
      body:  ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: white,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: getImage(),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(widget.productObject['name'],
                                style: TextStyle(
                                    color: lightText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )),
                          ),
                           isupdaingPrice ? CircularProgressIndicator() :Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               //Container(height: 18,width: 120,),
                               Container(
                                //margin: EdgeInsets.only(top: 10),
                                child: Text("\$"+double.parse(widget.productObject['price']).toStringAsFixed(2),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                    )),
                                ),
                                Container(
                                  width: 121,
                                  child: FlatButton(
                                    
                                    onPressed: ()
                                    {
                                      editPriceDialog();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.edit, size: 15, color: iconColor),
                                        SizedBox(width: 3),
                                        Text("Change Price",
                                        style: TextStyle(
                                          fontSize: 12
                                        )),
                                      ],
                                    ),

      
                                  ),
                                )
                             ],
                           ),
                           SizedBox(
                             width: double.infinity,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text("Note:", 
                                 style: TextStyle(
                                   fontSize: 17,
                                   color: lightestText,
                                   fontWeight: FontWeight.bold
                                 ),),
                                 SizedBox(height: 5,),
                                 Text(instructionString, 
                                 style: TextStyle(
                                   fontSize: 14,
                                   color: Colors.blueGrey,
                                   fontWeight: FontWeight.normal
                                 ),),
                               ],
                             ),
                           )
                        ],
                      ),
                    ),

                    Container(
                        padding: EdgeInsets.all(15),
                        child: Text('Try to match the requested size and quantity. How many did you get?',
                            style: TextStyle(
                                color: lightestText,
                                fontSize: 15.5
                            ))
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              IconButton(
                                icon: Icon(Icons.remove, color: primaryColor,),
                                onPressed: (){
                                  setState(() {
                                    if(itemCount == 0)
                                    {
                                      return;
                                    }
                                    else
                                    {
                                      itemCount --;
                                    }
                                  });
                                },
                              ),

                              Text(itemCount.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: lightestText,
                                      fontWeight: FontWeight.bold
                                  )),
                              Text('/'+double.parse(widget.productObject['qty_ordered']).toStringAsFixed(0),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: darkText,
                                      fontWeight: FontWeight.bold
                                  )),
                              IconButton(
                                icon: Icon(Icons.add, color: primaryColor,),
                                onPressed: (){
                                  setState(() {
                                    if(itemCount == int.parse(double.parse(widget.productObject['qty_ordered']).toStringAsFixed(0)))
                                    {
                                      return;
                                    }
                                    else
                                    {
                                      itemCount ++;
                                    }
                                  });


                                },
                              ),



                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FlatButton(
                      color: primaryColor,
                      onPressed: (){
                          foundItemDialog();

                      },
                      child: isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(white),): Text('FOUND ITEM',
                        style: TextStyle(
                          color: white,
                        ),),
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: ()
                {
                  _settingModalBottomSheet(context);
                },
                child: Text('Not Found',
                style: TextStyle(
                  color: primaryColor,
                ),
                ),
              ),
              SizedBox(height: 50)

            ],
          )
        ],
      )
    );
  }


foundItemDialog() async
{


                  final value = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Are you sure you are done?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                            // clearCartFromServer();
                              
                              Navigator.of(context).pop(true);
                              int orderedQuantity = int.parse(double.parse(widget.productObject['qty_ordered']).toStringAsFixed(0));
                        print(itemCount);

                        if(itemCount == 0)
                        {
                          showToast("Please add quantity!");
                          return;
                        }
                        if(orderedQuantity == itemCount)
                        {
                          print(widget.itemIndex);
                          orderProductList[widget.index][0]['items'][widget.itemIndex][isTodo] = 0;
                          orderProductList[widget.index][0]['items'][widget.itemIndex][isPending] = 0;
                          orderProductList[widget.index][0]['items'][widget.itemIndex][isDone] = 1;
                          orderProductList[widget.index][0]['items'][widget.itemIndex][doneQuantity] =(itemCount).toString();
                          Navigator.pop(context, [1]);
                        }
                        else if (orderedQuantity > itemCount)
                        {
                         /**/

                          dynamic cartItemsArray = cartInfoObject['items'] as List;
                          print(cartInfoObject);
                          for (int i = 0; i < cartItemsArray.length; i++)
                          {
                            print(widget.productObject['sku']);
                            print(cartItemsArray[i]['sku']);
                            if(widget.productObject['sku'] == cartItemsArray[i]['sku'])
                            {

                              getCartItems(itemCount, cartItemsArray[i]['item_id'], orderedQuantity);
                              print(cartItemsArray[i]['item_id']);
                              print(widget.productObject['product_id']);
                              //print(widget.productObject['product_id']);
                              //break;
                            }
                          }



                        }

                            },
                          ),
                        ],
                      );
                    }
                );
                        



}

  bool isDialogLoading = false;
  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState)
          {

            Future<void> deleteItemFromCart( String itemId) async {
              try
              {
                setModalState(() {
                  isDialogLoading = true;
                });
                print(deleteItemFromCartUrl(quote_id, itemId));
                final response = await http.delete(
                  deleteItemFromCartUrl(quote_id, itemId),
                  headers: {HttpHeaders.authorizationHeader: auth,
                    HttpHeaders.contentTypeHeader: contentType},
                );

                if(response.statusCode == 200)
                {
                  final responseJson = json.decode(response.body);
                  print(responseJson);
                  //getCartItems();

                  orderProductList[widget.index][0]['items'][widget.itemIndex][isTodo] = 0;
                  orderProductList[widget.index][0]['items'][widget.itemIndex][isPending] = 1;
                  orderProductList[widget.index][0]['items'][widget.itemIndex][isDone] = 0;
                  orderProductList[widget.index][0]['items'][widget.itemIndex][doneQuantity] =(0).toString();
                  orderProductList[widget.index][0]['items'][widget.itemIndex][pendingQuantity] = "0";//double.parse(orderProductList[widget.index]['qty_ordered']).toStringAsFixed(0);
                  Navigator.pop(context, [1]);
                  Navigator.pop(context, [1]);
                  setModalState(() {
                    //isDialogLoading = false;
                  });
                }
                else
                {
                  final responseJson = json.decode(response.body);
                  print(responseJson);
                  //getCartItems();
                  //getCartItems();
                  showToast(responseJson['message']);
                  setModalState(() {
                    isDialogLoading = true;
                  });
                }
              }
              catch(e){
                print(e);
                setModalState(() {
                  print(e);
                  showToast('Something went wrong');
                  isDialogLoading = false;
                });

              }
            }

           return Container(
              child: new Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text('Find Replacement',
                              style: TextStyle(
                                  color: backgroundGrey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: Text(
                              'You can find a replacement for this product and add it to the order. ',
                              style: TextStyle(
                                  color: lightestText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                              )),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(
                                top: 20, bottom: 10, right: 15, left: 15),
                            child: FlatButton(
                                color: primaryColor,
                                onPressed: () {
                                  print(widget.productObject);
                                  dynamic cartItemsArray = cartInfoObject['items'] as List;
                                  print(cartInfoObject);
                                  for (int i = 0; i < cartItemsArray.length; i++) {
                                    print(widget.productObject['sku']);
                                    print(cartItemsArray[i]['sku']);
                                    if (widget.productObject['sku'] ==
                                        cartItemsArray[i]['sku']) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FindItem(widget.productObject,
                                                    widget.index,
                                                    cartItemsArray[i]['item_id']
                                                        .toString(), widget.itemIndex),
                                          ));
                                      print(cartItemsArray[i]['item_id']);
                                      //print(widget.productObject['product_id']);
                                      //print(widget.productObject['product_id']);
                                      //break;
                                    }
                                  }
                                },
                                child: Text("Let's Find",
                                    style: TextStyle(
                                        color: white
                                    )
                                )
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              left: 40, right: 40, bottom: 20, top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Divider(
                                    thickness: 1,

                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text('OR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: lightestText,
                                        fontSize: 14,

                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Divider(
                                    thickness: 1,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatButton(
                            color: white,
                            onPressed: () {
                              dynamic cartItemsArray = cartInfoObject['items'] as List;
                              print(cartInfoObject);
                              for (int i = 0; i < cartItemsArray.length; i++) {
                                print(widget.productObject['sku']);
                                print(cartItemsArray[i]['sku']);
                                if (widget.productObject['sku'] ==
                                    cartItemsArray[i]['sku']) {
                                    deleteItemFromCart(cartItemsArray[i]['item_id']
                                        .toString());
                                }
                              }
                            },
                            child: isDialogLoading ? CircularProgressIndicator() : Text("Refund",
                                style: TextStyle(
                                    color: darkText
                                )
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        }
    );
  }

  




  editPriceDialog() async
  {
    TextEditingController priceController = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Wrap(
              children: <Widget>[
                Column(
              children: <Widget>[
                Text('Add new price'),
                Card(
                          child: Row(
                          children: <Widget>[
                            Expanded(flex: 4,child: Container(
                              //padding: EdgeInsets.all(10),
                              child: Text(" \$", 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20
                              ),))),
                            Expanded(
                              flex: 10,
                                child: Container(
                                color: white,
                                margin: EdgeInsets.only(left: 10, right: 20),
                                padding: EdgeInsets.all(10),
                                child:TextField(
                                inputFormatters: [_amountValidator],
                                  controller: priceController,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false
                                  ),
                                  enabled:  true,
                                
                                  //textCapitalization: TextCapitalization.characters,
                                  onChanged: (text)
                                  {
                                    
                                  },
                                  decoration : InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Price",
                                  ),
                                  style: TextStyle(fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
              ],
            ),
            actions: <Widget>[
             
              FlatButton(
                color: primaryColor,
                child: Text('Change Price'),
                onPressed: () {
                 // clearCartFromServer();
                 // cartId = '';
                  if(priceController.text.trim() == "")
                                    {
                                      showToast("Please enter price!");
                                      return;
                                    }
                                    else if(double.parse(priceController.text.trim()) < double.parse(widget.productObject['price']))
                                    {
                                      showToast("Price must be greater than current price!");
                                      return;
                                    }
                                    updatePriceToServer(priceController.text);
                                    Navigator.of(context).pop(false);

                },
              ),
            ],
          );
        }
    );

  
  }


bool isupdaingPrice = false;

Future<void> updatePriceToServer(String price) async {


     
      
      Map productInfo = {
  "product": {
    "price": double.parse(price)
  }
};


      try
      {
        print(domainURL+"index.php/rest/V1/products/"+widget.productObject['sku']);
        print(productInfo);

        setState(() {
          isupdaingPrice = true;
        });

        final response = await http.put(
            domainURL+"index.php/rest/V1/products/"+widget.productObject['sku'],
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(productInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          //String productId = responseJson['id'];
          setState(() {
            isupdaingPrice = false;
            widget.productObject['price'] = price;
          });
          

          //saveData(responseJson);
          
         
        }
        else
        {
          showToast('Something went wrong');
          setState(() {
            isupdaingPrice = false;
          });
          print(response.statusCode);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isupdaingPrice = false;
        });}
    }
   



  bool isLoading = false;
  bool isSuccess = false;
  Future<void> getCartItems(int quantity, int itemid, int orderedQuantity) async {
    print('cartItems');
    Map itemInfo = { "cartItem" : { "item_id" : itemid, "qty" : quantity, "quoteId" : quote_id } };
    setState(() {
      isLoading = true;
    });
    try
    {
      final response = await http.post(
        getCartInfo+quote_id+"/items",
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        body: json.encode(itemInfo)
      );
     // response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);

        orderProductList[widget.index][0]['items'][widget.itemIndex][isTodo] = 0;
        orderProductList[widget.index][0]['items'][widget.itemIndex][isPending] = 1;
        orderProductList[widget.index][0]['items'][widget.itemIndex][isDone] = 1;
        orderProductList[widget.index][0]['items'][widget.itemIndex][doneQuantity] =(itemCount).toString();
        orderProductList[widget.index][0]['items'][widget.itemIndex][pendingQuantity] =(orderedQuantity -  itemCount).toString();
        print(quote_id);
        Navigator.pop(context, [1]);


        //cartId = responseJson;
        setState(() {
          isLoading = false;
          isSuccess = true;
        });
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    }
    catch(e){
      print(e);
      setState(() {
          isLoading = false;
      });
    }

  }



  String getImage()
  {
    String image ;
    try{
      image = imageUrl+widget.productObject['thumbnail'];
    }
    catch(e)
    {
      image = "";
    }
    return image;
  }




}
