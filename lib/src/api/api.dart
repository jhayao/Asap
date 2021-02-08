import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi{
      final String _url = 'https://ssc.codes/api/';

      postData(data,apiUrl) async {
          var fullUrl = _url + apiUrl;
          var response;
            response =  http.post(
                fullUrl,
                body: jsonEncode(data),
                headers: _setHeaders()
            ).timeout(
              Duration(seconds: 3),
              onTimeout: (){
                return throw TimeoutException("Error");
              },
            );

        return response;
      }

      getData(apiUrl) async{
        var fullUrl = _url +apiUrl;
        return await http.get(
          fullUrl,
            headers: _setHeaders()
        );
      }

      _setHeaders() => {
          'Content-Type' : 'application/json',
          'Accept' : 'application/json'
      };

}

