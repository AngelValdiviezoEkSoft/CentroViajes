import 'dart:convert';

class RegisterDeviceModel {
    int estado;
    String url;
    String database;
    String serverUrl;
    String key;
    String tocken;
    String bearer;
    DateTime tockenValidDate;

    RegisterDeviceModel({
        required this.estado,
        required this.url,
        required this.database,
        required this.serverUrl,
        required this.key,
        required this.tocken,
        required this.bearer,
        required this.tockenValidDate,
    });

    /*
    factory RegisterDeviceModel.fromRawJson(String str) => RegisterDeviceModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) => RegisterDeviceModel(
        estado: json["estado"],
        url: json["url"],
        database: json["database"],
        serverUrl: json["server_url"],
        key: json["key"],
        tocken: json["tocken"],
        bearer: json["bearer"],
        tockenValidDate: DateTime.parse(json["tocken_valid_date"]),
    );

    Map<String, dynamic> toJson() => {
        "estado": estado,
        "url": url,
        "database": database,
        "server_url": serverUrl,
        "key": key,
        "tocken": tocken,
        "bearer": bearer,
        "tocken_valid_date": tockenValidDate.toIso8601String(),
    };
    */

    factory RegisterDeviceModel.fromJson(String str) => RegisterDeviceModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterDeviceModel.fromMap(Map<String, dynamic> json) => RegisterDeviceModel(
      estado: json["estado"],
      url: json["url"],
      database: json["database"],
      serverUrl: json["server_url"],
      key: json["key"],
      tocken: json["tocken"],
      bearer: json["bearer"],
      tockenValidDate: DateTime.parse(json["tocken_valid_date"]),
    );

    Map<String, dynamic> toMap() => {
      "estado": estado,
        "url": url,
        "database": database,
        "server_url": serverUrl,
        "key": key,
        "tocken": tocken,
        "bearer": bearer,
        "tocken_valid_date": tockenValidDate.toIso8601String(),
    };
}
