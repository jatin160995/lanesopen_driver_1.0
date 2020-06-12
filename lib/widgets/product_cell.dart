import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:driver/utils/common.dart';
import 'package:driver/screens/product_detail.dart';
import 'package:driver/screens/order_detail.dart';

class ProductCell extends StatefulWidget {

  dynamic productDetail;
  int index;
  int itemIndex;
  String arrayType;
  Function function;


  ProductCell(this.productDetail, this.index, this.itemIndex, this.arrayType, this.function);

  @override
  _ProductCellState createState() => _ProductCellState();


}

class _ProductCellState extends State<ProductCell> {









  void _sendDataToOrderScreen(BuildContext context) async {
     dynamic textToSend = widget.productDetail;
     await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(productObject: textToSend, index: widget.index, itemIndex: widget.itemIndex,),
        )).then((value){});

  }


  @override
  Widget build(BuildContext context) {

       

    String quantity = '';
    if (widget.arrayType == isTodo){quantity = widget.productDetail['qty_ordered'];}
    else if(widget.arrayType == isPending){quantity = widget.productDetail[pendingQuantity];}
    else if(widget.arrayType == isDone){quantity = widget.productDetail[doneQuantity];}
    else if(widget.arrayType == "1"){quantity = widget.productDetail['qty_ordered'];}



     String instructionString = '';
        dynamic decodeInstruct = json.decode(widget.productDetail['product_options'].toString());
        try
        {
          instructionString = decodeInstruct['info_buyRequest']['options']['instruction'];
          //print();
        }
        catch(e){
          //instructionString = "N/A";
        }
    return GestureDetector(
      onTap: ()
      {
        //Navigator.pushNamed(context, '/prod');
        if(widget.arrayType == isTodo)
        {
          _sendDataToOrderScreen(context);
        }

      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(

            children: <Widget>[
              FadeInImage.assetNetwork(
                  height: 80,
                  width: 80,
                  placeholder: 'assets/images/grey_logo.jpg',
                  image: getImage()
              ),
              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.productDetail['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: darkText,
                          fontSize: 17,
                        )
                    ),
                    Text('Quantity: '+double.parse(quantity.toString()).toStringAsFixed(0),

                        style: TextStyle(
                          color: lightestText,
                          fontSize: 14,

                        )
                    ),

                    instructionString != "" ? Text('Notes: '+instructionString,

                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,

                        )
                    ) : Container(),
                    
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  String getImage()
  {
    String image ;
    try{
      image = imageUrl+widget.productDetail['thumbnail'];
    }
    catch(e)
    {
      image = "";
    }
    return image;
  }
}
