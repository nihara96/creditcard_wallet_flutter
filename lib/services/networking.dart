import 'dart:convert';

import 'package:http/http.dart' as http;


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

}


class Service{
  static const String MAIN_URL = "192.168.8.156:8080";
  static const String BINLIST_URL = "lookup.binlist.net";
}