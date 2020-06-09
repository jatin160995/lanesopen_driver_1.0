import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:driver/chat/chat.dart';
import 'package:driver/scanner/scanned_product_detail.dart';
import 'package:driver/screens/user/thankyou_screen.dart';
import 'package:driver/utils/common.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:driver/widgets/product_cell.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_new_item_from_store.dart';



class OrderDetail extends StatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();

  dynamic orderObject;
  String incrementId;
  OrderDetail({Key key, @required this.orderObject, this.incrementId}) : super(key: key);


}


class _OrderDetailState extends State<OrderDetail> {

  Widget createProduct (List<dynamic> items, String arrayType)
  {
    List<Widget> productWidget = new List();
   
    for (int i =0 ; i < items.length; i++)
    {
      dynamic singleProductCategory = items[i];
      bool isAdded = false;
      //print(singleProductCategory[0]['category_name']);
    
      
      List singleCategoryItems = singleProductCategory[0]['items'];
      for (int itemIndex = 0; itemIndex< singleCategoryItems.length; itemIndex ++)
      {
        if(singleCategoryItems[itemIndex][arrayType] == 1)
        {
          for(int x = 0; x< cartInfoObject['items'].length; x++)
          {
            if(cartInfoObject['items'][x]['sku'] == singleCategoryItems[itemIndex]['sku'])
            {
              if(arrayType != isDone && !isAdded)
              {
                productWidget.add(new Container(
                padding: EdgeInsets.only(left: 10, top: 7, bottom: 7),
                child: Text(singleProductCategory[0]['category_name'],
                style: TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )),
                ));
                isAdded = true;
              }
              productWidget.add(new ProductCell(singleCategoryItems[itemIndex], i, itemIndex,  arrayType, (){
                setState(() {
                  print('here');
                });
              }));
            }
          }
        }
      }
      
      /*if(items[i][arrayType] == 1)
      {
        for(int x = 0; x< cartInfoObject['items'].length; x++)
        {
          if(cartInfoObject['items'][x]['sku'] == items[i]['sku'])
          {
            productWidget.add(new ProductCell(items[i], i, arrayType, (){
              setState(() {
                print('here');
              });
            }));
          }
        }

      }*/

    }

if(arrayType == isDone)
{
for(int doneIndex = 0; doneIndex < doneAddedList.length; doneIndex++)
    {
      productWidget.add(new ProductCell(doneAddedList[doneIndex], 0, 0,  isDone, (){
                setState(() {
                  print('here');
                });
        }));
    }
}
    
    if(productWidget.length > 0)
    {
      return new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: productWidget,);
    }
    else
      {
        if(arrayType != isDone)
        {
          productWidget.add(FlatButton(
              onPressed: (){},
              child: Text('Already Edited this order. Please checkout')
          ));
        }

        return new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: productWidget,);
      }

  }



  bool isLoading = false;
  Future<void> getCartInfoFromServer() async {
    print('cartFromServer');
    // Map itemInfo = { "cartItem" : { "item_id" : 2946, "qty" : quantity, "quoteId" : quote_id } };
    setState(() {
      isLoading = true;
    });
    try
    {
      final response = await http.get(
          getCartInfo+quote_id,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          //body: json.encode(itemInfo)
      );
      // response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //cartId = responseJson;
        print(responseJson);
        cartInfoObject = responseJson;
        setState(() {
          isLoading = false;
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


  @override
  void initState() {
    doneAddedList = new List();
    getCartInfoFromServer();
    valueSetter();
    super.initState();
  }


  @override
  void dispose()
  {
    timer.cancel();
    super.dispose();
  }




  bool isCheckOutLoading = false;

  Future<void> setCartItems() async {
    print('cartItems');
    Map itemInfo ={"quoteId":quote_id , "orderId" : widget.orderObject[0]['entity_id']};
    print(itemInfo);
    //return;
    //print(itemInfo);
    setState(() {
      isCheckOutLoading = true;
    });
    try
    {
      final response = await http.post(
          finalChangeValues,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(itemInfo)
      );
      // response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //print( "helloJAtin"+responseJson);
        //productData[]


        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThankyouScreen(widget.orderObject)//CheckoutPage(widget.orderObject[0]['entity_id']),
            ));
        //cartId = responseJson;
        setState(() {
          isCheckOutLoading = false;
          //isSuccess = true;
        });
      }
      else
      {
        final responseJson = json.decode(response.body);
        //print("hello jatin"+responseJson);
        print(response.statusCode);
        setState(() {
          isCheckOutLoading = false;
        });
      }
    }
    catch(e){
      print(e);
      setState(() {
        isCheckOutLoading = false;
      });
    }
  }






  goToCheckout()
  {

    int isTodoCount = 0;
    

    for (int i =0 ; i < orderProductList.length; i++)
    {
    dynamic singleProductCategory = orderProductList[i];
     
      
      List singleCategoryItems = singleProductCategory[0]['items'];
      for (int itemIndex = 0; itemIndex< singleCategoryItems.length; itemIndex ++)
      {
        if(singleCategoryItems[itemIndex][isTodo] == 1)
        {
          for(int x = 0; x< cartInfoObject['items'].length; x++)
          {
            if(cartInfoObject['items'][x]['sku'] == singleCategoryItems[itemIndex]['sku'])
            {
              isTodoCount ++;
            }
          }
        }
      }
    }
    /*for (int i =0; i < orderProductList.length; i++)
    {
       if(orderProductList[i][isTodo] == 1)
       {
         for(int x = 0; x< cartInfoObject['items'].length; x++)
         {
           if(cartInfoObject['items'][x]['sku'] == orderProductList[i]['sku']) {
             isTodoCount ++;
           }}
       }
    }*/
    if(isTodoCount > 0){
        print("There are "+isTodoCount.toString()+" items in TO-DO list.");
        print(isTodoCount);
        showToast("There are "+isTodoCount.toString()+" items in TO-DO list.");
    }
    else
      {
        print("Go to checkout");
        setCartItems();
      }
  }


  FirebaseVisionBarcodeDetector barcodeDetector = FirebaseVisionBarcodeDetector.instance;
  List<VisionBarcode> _currentBarcodeLabels = <VisionBarcode>[];

  void onPickImageSelected() async {

    try {
      final file =
      await ImagePicker.pickImage(source: ImageSource.camera);
      if (file == null) {
        throw Exception('File is not available');
      }

      Timer(Duration(milliseconds: 1000), () {
        this.analyzeLabels(file);
      });
     /* Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => DetailWidget(file, "BARCODE_SCANNER")),
      );
*/
    } catch(e) {
     // scaffold.showSnackBar(SnackBar(content: Text(e.toString()),));
      showToast(e.toString());
    }
  }

  void analyzeLabels(File file) async {
    try {
      var currentLabels;

        currentLabels = await barcodeDetector.detectFromPath(file.path);
        setState(() {
          _currentBarcodeLabels = currentLabels;
        });

        if(_currentBarcodeLabels.length > 0)
        {
          /*for(int i = 0; i< _currentBarcodeLabels.length; i++)
          {*/
            //_currentBarcodeLabels[i].
            print("Raw Value: ${_currentBarcodeLabels[0].rawValue}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(_currentBarcodeLabels[0].rawValue)//CheckoutPage(widget.orderObject[0]['entity_id']),
                ));
          //}
        }
        else
          {
            showToast("Unable to scan barcode");
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => AddNewProduct()
              )
            );
          }


    } catch (e) {
      print(e.toString());
    }
  }



  
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
  Widget build(BuildContext context) {

    //print(widget.orderObject.toString() + 'hello');
    return  WillPopScope(
        onWillPop: () async {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Do you really want to exit?'),
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

                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
      );

      return value == true;
    },
    child:  DefaultTabController(
      length: 2,
      child: Scaffold(

        floatingActionButton: FabCircularMenu(
          fabColor: primaryColor,
          ringColor: primaryColor,
          //fabOpenColor: white,
          fabOpenIcon: Icon(Icons.menu,color: white,),
          fabCloseIcon: Icon(Icons.close, color: white),
          children: <Widget>[
            IconButton(icon: Icon(Icons.chat, color: white), onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(widget.incrementId)//CheckoutPage(widget.orderObject[0]['entity_id']),
                ));
            }),
            IconButton(icon: Icon(Icons.call,  color: white), onPressed: () {
              _makePhoneCall('tel:${widget.orderObject[0]['addresses'][0]['telephone']}');
            })
          ]
        ),
        
        appBar: AppBar(
          leading:  FlatButton(
            onPressed: ()
            {
             // goToCheckout();
              onPickImageSelected();
              //showToast("message");
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.add_box, color: white,),
                //Text("add")
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              width: 120,
              child: FlatButton(
                onPressed: ()
                {
                  goToCheckout();
                },
                child:isCheckOutLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(white),):  Text("Checkout",
                 style: TextStyle(
                   color: white,
                   fontWeight: FontWeight.bold,
                   fontSize: 18
                 )),
              ),
            ),
          ],
          title: Text(widget.orderObject[0]['customer_firstname'] + '\'s order',
          style: TextStyle(
            fontSize: 17
          )),
          backgroundColor: primaryColor,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: white,
            labelPadding: EdgeInsets.only(bottom: 10),
            tabs: [
              Text('TO-DO'),
              //Text('PENDING'),
              Text('DONE'),
            ],
          ),
        ),
        body: isLoading ? new Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/images/loading.gif'),
        ) : TabBarView(
          children: [
            ListView(
              children: <Widget>[
                createProduct(orderProductList, isTodo)
              ],
            ),
            /*ListView(
              children: <Widget>[
                createProduct(orderProductList, isPending)
              ],
            ),*/
            ListView(
              children: <Widget>[
                //if(orderProductList.length > 0)
                createProduct(orderProductList, isDone)


              ],
            ),
          ],
        ),
      ),
    )

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
}
