import 'dart:convert';
import 'dart:io';

import 'package:driver/utils/common.dart';
import 'package:driver/utils/regex_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;

class FindItem extends StatefulWidget {
  dynamic productData;
  dynamic index;
  dynamic itemIndex;
  dynamic itemId;
  FindItem(this.productData, this.index, this.itemId, this.itemIndex);

  @override
  _FindItemState createState() => _FindItemState();
}

class _FindItemState extends State<FindItem> {
  int currentPage = 1;

  bool ischanged = false;
  TextEditingController textEditingController = new TextEditingController();

  String query = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Container(
            child: Row(
          children: <Widget>[
            Image(
              height: 40,
              width: 40,
              image: NetworkImage(imageUrl + widget.productData['thumbnail']),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.productData['name'],
                maxLines: 2,
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: lightGrey,
            padding: EdgeInsets.all(8),
            child: Card(
              child: Container(
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  color: white,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: textEditingController,
                            enabled: true,
                            //textCapitalization: TextCapitalization.characters,
                            onChanged: (text) {
                              query = text;
                              // print(query);
                              ischanged = true;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
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
                                child: IconButton(
                              onPressed: () {
                                print(textEditingController.text);
                                productFromServer = new List();
                                currentPage = 1;
                                getProducts();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              icon: Icon(Icons.search),
                              color: white,
                            ))),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: ListView(
                children: isLoading && currentPage == 1
                    ? [
                        Center(
                            child: Container(
                                margin: EdgeInsets.only(top: 80),
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator()))
                      ]
                    : getChildren()),
          )
        ],
      ),
    );
  }

  bool isDialogLoading = false;

  void _settingModalBottomSheet(context, dynamic productData) {
    int itemCount = 0;
    bool isupdaingPrice = false;
    print(widget.productData);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              Future<void> getCartItems() async {
                print('cartItems');
                Map itemInfo = {
                  "cartItem": {
                    "sku": productData['sku'],
                    "qty": itemCount,
                    "quoteId": quote_id
                  }
                };
                setModalState(() {
                  isDialogLoading = true;
                });
                try {
                  print(getCartInfo + quote_id + "/items");
                  final response =
                      await http.post(getCartInfo + quote_id + "/items",
                          headers: {
                            HttpHeaders.authorizationHeader: auth,
                            HttpHeaders.contentTypeHeader: contentType
                          },
                          body: json.encode(itemInfo));
                  // response.add(utf8.encode(json.encode(itemInfo)));

                  if (response.statusCode == 200) {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    //productData[]
                    productData[isTodo] = 0;
                    productData[isPending] = 0;
                    productData[isDone] = 1;
                    productData[doneQuantity] = (itemCount).toString();
                    productData[pendingQuantity] = (0).toString();
                    productData['thumbnail'] = productData['custom_attributes']
                            [0]['value']
                        .toString()
                        .replaceAll(domainURL, "");

                    doneAddedList.add(productData);
                    //orderProductList[widget.index][0]['items'][widget.itemIndex]=(productData);
                    print(orderProductList[widget.index][0]['items']
                        [widget.itemIndex]);
                    orderProductList[widget.index][0]['items'][widget.itemIndex]
                        [isTodo] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex]
                        [isPending] = 1;
                    orderProductList[widget.index][0]['items'][widget.itemIndex]
                        [isDone] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex]
                        [doneQuantity] = (0).toString();
                    orderProductList[widget.index][0]['items'][widget.itemIndex]
                            [pendingQuantity] =
                        "0"; //double.parse(orderProductList[widget.index]['qty_ordered']).toStringAsFixed(0);
                    print(quote_id);

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    //cartId = responseJson;
                    setModalState(() {
                      isDialogLoading = false;
                      //isSuccess = true;
                    });
                  } else {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    setModalState(() {
                      isDialogLoading = false;
                    });
                  }
                } catch (e) {
                  print(e);
                  setModalState(() {
                    isDialogLoading = false;
                  });
                }
              }

              Future<void> deleteItemFromCart() async {
                try {
                  setModalState(() {
                    isDialogLoading = true;
                  });
                  print(deleteItemFromCartUrl(
                      quote_id, widget.productData['quote_item_id']));
                  final response = await http.delete(
                    deleteItemFromCartUrl(quote_id, widget.itemId.toString()),
                    headers: {
                      HttpHeaders.authorizationHeader: auth,
                      HttpHeaders.contentTypeHeader: contentType
                    },
                  );

                  if (response.statusCode == 200) {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    getCartItems();
                    setModalState(() {
                      //isDialogLoading = false;
                    });
                  } else {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    //getCartItems();
                    //getCartItems();
                    showToast(responseJson['message']);
                    setModalState(() {
                      isDialogLoading = true;
                    });
                  }
                } catch (e) {
                  print(e);
                  setModalState(() {
                    print(e);
                    showToast('Something went wrong');
                    isDialogLoading = false;
                  });
                }
              }

              
              print(productData['sku']);

              Future<void> updatePriceToServer(String price) async {
                Map productInfo = {
                  "product": {"price": double.parse(price)}
                };
                try {
                  print(productInfo);
                  setModalState(() {
                    isupdaingPrice = true;
                  });

                  final response = await http.put(
                      domainURL +
                          "index.php/rest/V1/products/" +
                          productData['sku'],
                      headers: {
                        HttpHeaders.authorizationHeader: auth,
                        HttpHeaders.contentTypeHeader: contentType
                      },
                      body: json.encode(productInfo));
                  if (response.statusCode == 200) {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    setModalState(() {
                      isupdaingPrice = false;
                    });
                     productData['price'] = double.parse(price);
                              setModalState((){});
                  } else {
                    showToast('Something went wrong');
                    setModalState(() {
                      isupdaingPrice = false;
                    });
                    print(response.statusCode);
                  }
                } catch (e) {
                  print(e);
                  setModalState(() {
                    isupdaingPrice = false;
                  });
                }
              }

              editPriceDialog() async {
                TextEditingController priceController =
                    new MoneyMaskedTextController(
                        decimalSeparator: '.', thousandSeparator: ',');
                final _amountValidator = RegExInputFormatter.withRegex(
                    '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

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
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                              //padding: EdgeInsets.all(10),
                                              child: Text(
                                            " \$",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ))),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: white,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 20),
                                          padding: EdgeInsets.all(10),
                                          child: TextField(
                                            inputFormatters: [_amountValidator],
                                            controller: priceController,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true,
                                                    signed: false),
                                            enabled: true,

                                            //textCapitalization: TextCapitalization.characters,
                                            onChanged: (text) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Price",
                                            ),
                                            style: TextStyle(
                                              fontSize: 20,
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
                              if (priceController.text.trim() == "") {
                                showToast("Please enter price!");
                                return;
                              }

                              updatePriceToServer(priceController.text);
                             
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      );
                    });
              }

              return Container(
                child: new Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        color: white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  color: white,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FadeInImage.assetNetwork(
                                      height:
                                         100,
                                      width:
                                          100,
                                      placeholder:
                                          'assets/images/loading.gif',
                                      image: productData['custom_attributes']
                                          [0]['value'],
                                    ),
                                  ),
                                ),
                                 Expanded(
                              child: Padding(
                              padding:EdgeInsets.only(left: 5.0, right: 15),
                              child: Text(productData['name'],
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: lightestText,
                                        fontSize: 18)
                                        ),
                                    ),
                                 ),
                              ],
                            ),
                           
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child:isupdaingPrice ? CircularProgressIndicator() : Text(
                                        '\$' +
                                            productData['price']
                                                .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontSize: 20))),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  width: 121,
                                  child: FlatButton(
                                    onPressed: () {
                                      editPriceDialog();
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.edit,
                                            size: 15, color: iconColor),
                                        SizedBox(width: 3),
                                        Text("Change Price",
                                            style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        setModalState(() {
                                          if (itemCount == 0) {
                                            return;
                                          } else {
                                            itemCount--;
                                          }
                                        });
                                      },
                                    ),
                                    Text(itemCount.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: lightestText,
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        setModalState(() {
                                          itemCount++;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                          height: 70,
                                          child: FlatButton(
                                            color: primaryColor,
                                            onPressed: itemCount == 0
                                                ? null
                                                : () {
                                                    deleteItemFromCart();
                                                  },
                                            disabledColor: iconColor,
                                            child: isDialogLoading
                                                ? CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(white),
                                                  )
                                                : Text(
                                                    "REPLACE ITEM",
                                                    style:
                                                        TextStyle(color: white),
                                                  ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            //SizedBox(height: 50,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  List<Widget> getChildren() {
    List<Widget> productList = new List();
    for (int i = 0; i < productFromServer.length; i++) {
      productList.add(new SearchedItem(productFromServer[i], () {
        _settingModalBottomSheet(context, productFromServer[i]);
      }));
    }
    if (productList.length > 0) {
      productList.add(new FlatButton(
          onPressed: isLoading
              ? () {}
              : () {
                  currentPage++;
                  productList.remove(productList.length - 1);
                  productList.add(CircularProgressIndicator());
                  setState(() {});
                  getProducts();
                },
          child: isLoading
              ? Container(
                  height: 40, width: 40, child: CircularProgressIndicator())
              : Text('Load More')));
    }

    return productList;
  }

  dynamic productFromServer = new List();

  bool isLoading = false;
  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });

    print(textEditingController.text);
    try {
      /* print(categoriesURLPre+'index.php/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]='+orderInfoObject[0]['storeInfo'][0]['category_id'].toString()+
           '&searchCriteria[filter_groups][0][filters][0][conditionType]=eq&searchCriteria[filter_groups][0][filters][1][field]=name&searchCriteria[filter_groups][0][filters][1][value]=%25'
           +textEditingController.text+'%25&searchCriteria[filter_groups][0][filters][1][conditionType]=like&searchCriteria[pageSize]=30&searchCriteria[currentPage]='+currentPage.toString());
      */
      final response = await http.get(
        categoriesURLPre +
            'index.php/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=' +
            orderInfoObject[0]['storeInfo'][0]['category_id'].toString() +
            '&searchCriteria[filter_groups][0][filters][0][conditionType]=eq&searchCriteria[filter_groups][0][filters][1][field]=name&searchCriteria[filter_groups][0][filters][1][value]=%25' +
            textEditingController.text +
            '%25&searchCriteria[filter_groups][0][filters][1][conditionType]=like&searchCriteria[pageSize]=30&searchCriteria[currentPage]=' +
            currentPage.toString(),
        headers: {
          HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      //print(json.decode(response.body));
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        // print(responseJson);
        if (currentPage > 1) {
          productFromServer.removeAt(productFromServer.length - 1);
        }
        print(responseJson['items']);
        productFromServer.addAll(responseJson['items'] as List); //;
        // productFromServer.add({'isLast':'1'});
        setState(() {
          isLoading = false;
          //createProduct();
          print('setstate');
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      showToast('Something went wrong');
    }
  }
}

class SearchedItem extends StatefulWidget {
  dynamic productData;
  Function openDialog;
  SearchedItem(this.productData, this.openDialog);
  @override
  _SearchedItemState createState() => _SearchedItemState();
}

class _SearchedItemState extends State<SearchedItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.productData['custom_attributes'][0]['value']);
    return GestureDetector(
      onTap: widget.openDialog,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              FadeInImage.assetNetwork(
                height: 70,
                width: 70,
                placeholder: 'assets/images/loading.gif',
                image: widget.productData['custom_attributes'][0]['value'],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.productData['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: lightestText,
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text('\$' + widget.productData['price'].toStringAsFixed(2),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
