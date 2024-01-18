

import 'dart:io';

class Config{

  static String profileImage = "";
  static String emailId = "";
  static String name = "";

  static String accessToken = "";


  static Map<String, String> headers(){
    return {
      HttpHeaders.contentTypeHeader : "application/json",
    };
  }
  static Map<String, String> authHeaders() {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      "x-access-token" :Config.accessToken
    };
  }
}