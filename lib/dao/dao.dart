import 'package:http/http.dart' as http;

import '../helper/custom_log.dart';

class FetchDataDetails {
  Future fetchDetails() async {
    var url = 'https://jsonplaceholder.typicode.com/albums/1/photos';

    final response = await http.get(
      Uri.parse(url),
    );

    customLog("Response Status Code : ${response.statusCode}");
    customLog("Response of fetchFetchSiteDetails: ${response.body}");

    return response;
  }
}
