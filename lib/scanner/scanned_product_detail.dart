import 'dart:convert';
import 'dart:io';

import 'package:driver/screens/add_new_item_from_store.dart';
import 'package:driver/screens/find_item.dart';
import 'package:driver/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;


class ProductDetail extends StatefulWidget {

  String scannedCode;

  ProductDetail(this.scannedCode);

  @override
  _ProductDetailState createState() => _ProductDetailState();


}

class _ProductDetailState extends State<ProductDetail> {

  var qtyController = TextEditingController();
  var priceController = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  int itemCount = 1;

  var foundQuantity = 0;


  @override
  void initState() {
    // TODO: implement initState

    print(widget.scannedCode);
    getItemFromScannedCode();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //print(widget.index);
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          title: Text('Enter Quantity'),
        ),
        body:isLoading? Center(child: Container(width: 40,child: CircularProgressIndicator())) :  ListView(
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
                                placeholder: 'assets/images/grey_logo.jpg',
                                image: getImage(),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(productData[0]['title'],
                                  style: TextStyle(
                                      color: lightText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  )),
                            )
                          ],
                        ),
                      ),

                      /*Container(
                          padding: EdgeInsets.all(15),
                          child: Text('Try to match the requested size and quantity. How many did you get?',
                              style: TextStyle(
                                  color: lightestText,
                                  fontSize: 15.5
                              ))
                      ),*/
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
                                      if(itemCount == 1)
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

                                IconButton(
                                  icon: Icon(Icons.add, color: primaryColor,),
                                  onPressed: (){
                                    setState(() {
                                      itemCount ++;
                                    });


                                  },
                                ),



                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(flex: 1,child: Container(
                            //padding: EdgeInsets.all(10),
                            child: Text("   \$", 
                            style: TextStyle(
                              fontSize: 20
                            ),))),
                          Expanded(
                            flex: 10,
                                                      child: Container(
                              color: white,
                    
                              margin: EdgeInsets.only(left: 20, right: 20),
                              padding: EdgeInsets.all(10),
                              child:TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                enabled:  true,
                                //textCapitalization: TextCapitalization.characters,
                                onChanged: (text)
                                {

                                  //query = text;
                                  // print(query);
                                  //ischanged = true;
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
                          addProduct();

                        },
                        child: Text('ADD ITEM',
                          style: TextStyle(
                            color: white,
                          ),),
                      ),
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



dynamic addedProduct;
Future<void> addProduct() async {


      if(priceController.text.trim() == "")
      {
        showToast("Please add price");
        return;
      }
    
      Map productInfo = {
                    "product": {
                      "sku": productData[0]['ean']+"1",
                      "name": productData[0]['title'],
                      "price": double.parse(priceController.text),
                      "status": 1,
                      "type_id": "simple",
                      "visibility": 1,
                      "attribute_set_id":4,
                      "weight": 1, 
                      "extension_attributes": {
                        "stock_item": {
                                "qty": "10",
                                "is_in_stock": true
                            }
                      },"custom_attributes": [
                            {
                                "attribute_code": "product_brand",
                                "value": "custom"
                            }
                            ]

                      }
                    };


      try
      {
        print(addProductURL);
        print(productInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            addProductURL,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(productInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          addedProduct = responseJson;
          print(responseJson);
          //String productId = responseJson['id'];
          String sku = responseJson['sku'];
          getCartItems( sku);
          
          //saveData(responseJson);
          
         
        }
        else
        {
          showToast('Something went wrong');
          setState(() {
            isLoading = false;
          });
          print(response.statusCode);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
   

  



Future<void> getCartItems(String sku) async {
                print('cartItems');
                Map itemInfo = { "cartItem" : { "sku" : sku, "qty" : itemCount, "quoteId" : quote_id } };
                setState(() {
                  isLoading = true;
                });
                try
                {
                  print(itemInfo);
                  print(getCartInfo+quote_id+"/items");
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
                    print(responseJson);
                    //productData[]
                    addedProduct[isTodo] = 0;
                    addedProduct[isPending] = 0;
                    addedProduct[isDone] = 1;
                    addedProduct[doneQuantity] =(itemCount).toString();
                    addedProduct[pendingQuantity] =(0).toString();
                    addedProduct['thumbnail'] = getImage();

                    doneAddedList.add(addedProduct);


                    //orderProductList[widget.index][0]['items'][widget.itemIndex]=(productData);
                    //print(orderProductList[widget.index][0]['items'][widget.itemIndex]);
                    /*orderProductList[widget.index][0]['items'][widget.itemIndex][isTodo] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][isPending] = 1;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][isDone] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][doneQuantity] =(0).toString();
                    orderProductList[widget.index][0]['items'][widget.itemIndex][pendingQuantity] ="0";*///double.parse(orderProductList[widget.index]['qty_ordered']).toStringAsFixed(0);
                    print(quote_id);

                    Navigator.pop(context);


                    //cartId = responseJson;
                    setState(() {
                      isLoading = false;
                      //isSuccess = true;
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




  bool isLoading = false;
  bool isSuccess = false;
  dynamic productData;
  Future<void> getItemFromScannedCode() async {
    print('cartItems');
    setState(() {
      isLoading = true;
    });
    try
    {
      final response = await http.get(
          "https://api.upcitemdb.com/prod/trial/lookup?upc="+widget.scannedCode,

      );
      // response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        productData = responseJson["items"] as List;
        if(productData.length > 0)
        {
          setState(() {

          });
        }
        else
          {
            showToast("No product found");
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (context) => AddNewProduct()
              )
            );
          }
        print(responseJson);

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
    String imageURL = '';
    try
    {
      imageURL = productData[0]['images'][0];
    }
    catch(e)
    {
      imageURL ="";
    }
    return imageURL;
  }







}
