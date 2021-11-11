import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:soc_project/models/credit_card.dart';
import 'package:soc_project/models/credit_card_data.dart';


class NetworkHelper{

  Future getRequest({required Uri uri, }) async {

    http.Response response = await http.get(uri);

    if(response.statusCode == 200)
    {
      return jsonDecode(response.body);
    }

    return null;
  }


  Future postRequest({required Map body,required Uri uri}) async {

    var response = await http.post(
        uri,body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});

    return jsonDecode(response.body);

  }

  Future putRequest({required Map body, required Uri uri}) async
  {
    var response = await http.put(uri,body: jsonEncode(body),
        headers: {"Content-Type": "application/json"});

    return jsonDecode(response.body);

  }


  Future<dynamic> getCards(Map<String,dynamic> params,BuildContext context) async {

    final uri = Uri.http(Service.MAIN_URL, "/api/v1/cards/user/");

    var data = await postRequest(body:params, uri: uri);

    // Build credit card and add to the list;
     Provider.of<CreditCardData>(context,listen: false).clearCardList();

    for(Map map in data)
    {
      print(map['cardNumber']);

      Provider.of<CreditCardData>(context,listen: false).
      addCard(CreditCard(
          cardNumber: map['cardNumber'],
          cvv: map['cvv'],
          scheme: map['scheme'],
          bank: map['bank'],
          type: map['type'],
          branch: map['branch'],
          bankEmoji: map['bankEmoji']));

    }

    return data;

  }

  Future<dynamic> getCardData(String input) async {

    var data = await getRequest(uri: Uri.https(Service.BINLIST_URL, "/$input"));

    print(data);
    return data;

  }

  Future assignUserToCard(Map<String,dynamic> params,String cardNumber) async{

    return putRequest(body: params, uri: Uri.http(Service.MAIN_URL, "/api/v1/cards/$cardNumber/appUser/"));

  }


  Future addCardToNetwork( Map<String,dynamic> params,CreditCard creditCard) async {

    await postRequest(body: {
      "cardNumber":creditCard.cardNumber,
      "cvv":creditCard.cvv,
      "scheme":creditCard.scheme,
      "type":creditCard.type,
      "bank":creditCard.bank,
      "bankEmoji":creditCard.bankEmoji,
      "branch":creditCard.branch
    }, uri: Uri.http(Service.MAIN_URL, "/api/v1/cards/"));

    await assignUserToCard(params,creditCard.cardNumber);
  }
}

class Service{
  static const String MAIN_URL = "192.168.8.100:8080";
  static const String BINLIST_URL = "lookup.binlist.net";
}