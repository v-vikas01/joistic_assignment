

import 'dart:convert';

List<ListData> listDataFromJson(String str) => List<ListData>.from(json.decode(str).map((x) => ListData.fromJson(x)));

String listDataToJson(List<ListData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListData {
  String? albumId;
  String? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  ListData({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  factory ListData.fromJson(Map<String, dynamic> json) => ListData(
    albumId: json["albumId"]?.toString()??"",
    id: json["id"]?.toString()??"",
    title: json["title"]?.toString()??"",
    url: json["url"]?.toString()??"",
    thumbnailUrl: json["thumbnailUrl"]?.toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId,
    "id": id,
    "title": title,
    "url": url,
    "thumbnailUrl": thumbnailUrl,
  };
}
