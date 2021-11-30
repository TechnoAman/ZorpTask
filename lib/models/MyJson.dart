import 'dart:convert';

List<MyJson> myJsonFromJson(String str) =>
    List<MyJson>.from(json.decode(str).map((x) => MyJson.fromJson(x)));

String myJsonToJson(List<MyJson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyJson {
  MyJson({
    this.type,
    this.mandatory,
    this.maxLengthInSeconds,
  });

  String? type;
  bool? mandatory;
  int? maxLengthInSeconds;

  factory MyJson.fromJson(Map<String, dynamic> json) => MyJson(
        type: json["type"],
        mandatory: json["mandatory"],
        maxLengthInSeconds: json["maxLengthInSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "mandatory": mandatory,
        "maxLengthInSeconds": maxLengthInSeconds,
      };
}
