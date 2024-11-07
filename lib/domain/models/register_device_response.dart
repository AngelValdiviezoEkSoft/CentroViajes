import 'dart:convert';

import 'package:cvs_ec_app/domain/models/models.dart';

class RegisterDeviceResponseModel {
    String jsonrpc;
    dynamic id;
    RegisterDeviceModel result;

    RegisterDeviceResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
    });

    factory RegisterDeviceResponseModel.fromJson(String str) => RegisterDeviceResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterDeviceResponseModel.fromMap(Map<String, dynamic> json) => RegisterDeviceResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: RegisterDeviceModel.fromJson(json["result"]),
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };

}
