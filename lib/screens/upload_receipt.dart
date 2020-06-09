import 'dart:convert';
import 'dart:io';

import 'package:driver/utils/common.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadReceipt extends StatefulWidget {
  dynamic entity_id;
  UploadReceipt(this.entity_id);
  @override
  _UploadReceiptState createState() => _UploadReceiptState();
}

class _UploadReceiptState extends State<UploadReceipt> {



File imageFile = null;
  void onPickImageSelected() async {

    try {
      final file =
      await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 640, maxHeight: 480);
      setState(() {
        imageFile = file;
      });
      if (file == null) {
        throw Exception('File is not available');
      }
    } catch(e) {
     // scaffold.showSnackBar(SnackBar(content: Text(e.toString()),));
      showToast(e.toString());
    }
  }




  @override
  Widget build(BuildContext context) {
    print(widget.entity_id);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: ()
            {
              loginRequest();
            },
            child:isLoading ? CircularProgressIndicator() : Text("UPLOAD")
          )
        ],
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Upload Receipt',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
                  onTap: (){
                      onPickImageSelected();
                    },
                    child: imageFile == null ? Card(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 200,
                        child: Row(
                        children: <Widget>[
                          Icon(Icons.add_a_photo,color: primaryColor,),
                          SizedBox(width: 10),
                          Text("Add Image",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                          ))
                        ],
                        )
                      ),
                    ) : Center(
                      child: Container(
                      
                        height: 200,
                        width: 200,
                        child: Stack(children: <Widget>
                        [
                          Image.file(imageFile),
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.delete, color: Colors.red[200],),
                          )
                        ],)
                        ),
                    )
                ),
                  SizedBox(height: 10,),

                  FadeInImage.assetNetwork(
                 width: 200,
                 height: 200,
                  placeholder: '',
                  image: "http://demo2.lanesopen.com/pub/media/order/receipts/"+widget.entity_id+".jpeg"
              ),
        ],
      ),
    );
  }





  bool isLoading = false;

  Future<void> loginRequest() async {

      
      String image64 = "";
      if(imageFile != null)
      {
        final imageBytes = imageFile.readAsBytesSync();
        image64 =  base64Encode(imageBytes);
        print(image64);
        //return;
      }
      else
      {
        showToast("Please add image");
        return;
      }

      Map addressInfo = {"base64_encoded_data": image64,
                            "type": "image/jpeg",
                            "name": widget.entity_id+".jpeg",};

      try
      {
        print(domainURL+ "index.php/rest/V1/Iorder/recieptupload/");
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            domainURL+ "index.php/rest/V1/Iorder/recieptupload/",
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          //showToast("Added");
          //saveData(responseJson);
          Navigator.pop(context);

          print(responseJson);
        }
        else
        {
         final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
          setState(() {
            isLoading = false;
          });
          print(response.statusCode);
          print(responseJson);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
    

  

}