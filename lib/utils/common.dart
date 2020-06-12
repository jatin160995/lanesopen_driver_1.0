import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const primaryColor = Color(0xFF62A308);
const darkChatPrimaryColor = Color(0xFF365904);
const white = Color(0xffffffff);
const accent = Color(0xFF62A308);
const darkText = Color(0xFF222222);
const backgroundGrey = Color(0xFF90a4ae);
const background = Color(0xFFf8f8f8);
const lightText = Color(0xFF454545);
const lightestText = Color(0xFF656565);
const blue = Color(0xFF5391cf);
const transparent = Color(0x005391cf);
const blackTransparent = Color(0x80000000);
const lightGrey = Color(0xa0d8d8d8);
const iconColor = Color(0xa0888888);
var val = 'heloo';


const auth = 'Bearer 64tdnqc6cuwr56a3yk2qlazwt1n8bmgf';
const contentType = 'application/json';
const domainURL = 'https://demo3.lanesopen.com/';
const imageUrl = 'https://demo3.lanesopen.com/pub/media/catalog/product/';
String loginUrl = domainURL+'index.php/rest/V1/integration/admin/token';
String userInfo = domainURL+ 'index.php/rest/V1/hello/name/';
String orderInfo = domainURL+ 'index.php/rest/V1/Iorder/details/';
String changeStatus = domainURL+ 'index.php/rest/V1/yello/details/';
String getCartInfo = domainURL+ 'index.php/rest/V1/carts/';
String checkoutURL = domainURL+ 'index.php/rest/V1/carts/';
String finalChangeValues = domainURL+ 'index.php/rest/V1/orderedit/details/';
String editProfileUrl = domainURL+ 'index.php/rest/V1/driver/editprofile';
String changePasswordUrl = domainURL+ 'index.php/rest/V1/driver/changepassword';
String categoriesURLPre =  domainURL+'index.php/rest/V1/mstore/products/?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=';
String addProductURL = domainURL + "rest/V1/products/"; 

String driverOrderInfo = domainURL+ 'index.php/rest/V1/Iorder/groupitems/';
String deleteItemFromCartUrl(String qouteID, String itemId)
{
  String deleteItemCart = domainURL+ 'index.php/rest/V1/carts/'+qouteID+'/items/'+itemId;
  return deleteItemCart;
}

// shared Prefrence
String user_token = 'user_token';
String is_logged_in = 'is_logged_in';
String username = 'username';
String password = 'password';
String firstname = 'firstname';
String user_id = 'user_id';
String lastname = 'lastname';
String email = 'email';
bool homeNeedRefresh = false;


//order flags
String quote_id = '';
dynamic orderInfoObject ;
dynamic cartInfoObject ;




// iuser
dynamic orderProductList ;

String isTodo = 'isTodo';
String isPending = 'isPending';
String isDone = 'isDone';

String doneQuantity = 'doneQuantity';
String pendingQuantity = 'pendingQuantity';


List doneAddedList;



double calculateEarnings(double tip, double total)
{
  double earning = 0;
  earning = tip *(95/100);
  double earningFromTotal = 0;
  if(total <= 100.00 )
  {
    earningFromTotal = 10;
  }
  else if (total <= 200)
  {
earningFromTotal = 15;
  }
  else if (total <= 300)
  {
    earningFromTotal = 20;
  }
  else if (total > 300)
  {
    earningFromTotal = 25;
  }

  earning = earning + earningFromTotal;
  //print(total);
  //print(earningFromTotal);

  return earning; 
}

void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0
  );
}