import 'dart:convert';

class ProspectoRegistroResponseModel {
    String mensaje;
    String jsonrpc;
    dynamic id;
    ProspectoRegistroModel result;

    ProspectoRegistroResponseModel({
        required this.jsonrpc,
        required this.id,
        required this.result,
        required this.mensaje,
    });

    factory ProspectoRegistroResponseModel.fromJson(String str) => ProspectoRegistroResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoRegistroResponseModel.fromMap(Map<String, dynamic> json) => ProspectoRegistroResponseModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: ProspectoRegistroModel.fromMap(json["result"]),
        mensaje: ''
    );

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result.toJson(),
    };
}

class ProspectoRegistroModel {
    int estado;
    String mensaje;
    //List<DatumProspectoRegistro> data; //DESCOMENTAR AEVG

    ProspectoRegistroModel({
        required this.estado,
        required this.mensaje,
        //required this.data,
    });

    factory ProspectoRegistroModel.fromJson(String str) => ProspectoRegistroModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProspectoRegistroModel.fromMap(Map<String, dynamic> json) => ProspectoRegistroModel(
        estado: json["estado"],
        mensaje: json["mensaje"],
        //data: List<DatumProspectoRegistro>.from(json["data"].map((x) => DatumProspectoRegistro.fromJson(x))),
    );

    Map<String, dynamic> toMap() => {
        "estado": estado,
        "mensaje": mensaje,
        //"data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DatumProspectoRegistro {
    int id;
    List<dynamic> activityIds;
    CampaignIdPrsp campaignId;
    CampaignIdPrsp countryId;
    DateTime dateOpen;
    int dayClose;
    CampaignIdPrsp lostReasonId;
    CampaignIdPrsp mediumId;
    String name;
    CampaignIdPrsp partnerId;
    String phone;
    String priority;
    CampaignIdPrsp sourceId;
    StageIdPrsp stageId;
    CampaignIdPrsp stateId;
    List<dynamic> tagIds;
    CampaignIdPrsp title;
    String type;

    DatumProspectoRegistro({
        required this.id,
        required this.activityIds,
        required this.campaignId,
        required this.countryId,
        required this.dateOpen,
        required this.dayClose,
        required this.lostReasonId,
        required this.mediumId,
        required this.name,
        required this.partnerId,
        required this.phone,
        required this.priority,
        required this.sourceId,
        required this.stageId,
        required this.stateId,
        required this.tagIds,
        required this.title,
        required this.type,
    });

    factory DatumProspectoRegistro.fromJson(String str) => DatumProspectoRegistro.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DatumProspectoRegistro.fromMap(Map<String, dynamic> json) => DatumProspectoRegistro(
        id: json["id"],
        activityIds: List<dynamic>.from(json["activity_ids"].map((x) => x)),
        campaignId: CampaignIdPrsp.fromJson(json["campaign_id"]),
        countryId: CampaignIdPrsp.fromJson(json["country_id"]),
        dateOpen: DateTime.parse(json["date_open"]),
        dayClose: json["day_close"],
        lostReasonId: CampaignIdPrsp.fromJson(json["lost_reason_id"]),
        mediumId: CampaignIdPrsp.fromJson(json["medium_id"]),
        name: json["name"],
        partnerId: CampaignIdPrsp.fromJson(json["partner_id"]),
        phone: json["phone"],
        priority: json["priority"],
        sourceId: CampaignIdPrsp.fromJson(json["source_id"]),
        stageId: StageIdPrsp.fromJson(json["stage_id"]),
        stateId: CampaignIdPrsp.fromJson(json["state_id"]),
        tagIds: List<dynamic>.from(json["tag_ids"].map((x) => x)),
        title: CampaignIdPrsp.fromJson(json["title"]),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "activity_ids": List<dynamic>.from(activityIds.map((x) => x)),
        "campaign_id": campaignId.toJson(),
        "country_id": countryId.toJson(),
        "date_open": dateOpen.toIso8601String(),
        "day_close": dayClose,
        "lost_reason_id": lostReasonId.toJson(),
        "medium_id": mediumId.toJson(),
        "name": name,
        "partner_id": partnerId.toJson(),
        "phone": phone,
        "priority": priority,
        "source_id": sourceId.toJson(),
        "stage_id": stageId.toJson(),
        "state_id": stateId.toJson(),
        "tag_ids": List<dynamic>.from(tagIds.map((x) => x)),
        "title": title.toJson(),
        "type": type,
    };
}

class CampaignIdPrsp {
  int id;
    String name;

    CampaignIdPrsp({
        required this.id,
        required this.name,
    });

    factory CampaignIdPrsp.fromJson(String str) => CampaignIdPrsp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CampaignIdPrsp.fromMap(Map<String, dynamic> json) => CampaignIdPrsp(
      id: json["id"] ?? 0,
        name: json["name"] ?? '',
    );

    Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
    };
}

class StageIdPrsp {
    int id;
    String name;

    StageIdPrsp({
        required this.id,
        required this.name,
    });

    factory StageIdPrsp.fromJson(String str) => StageIdPrsp.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StageIdPrsp.fromMap(Map<String, dynamic> json) => StageIdPrsp(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}
