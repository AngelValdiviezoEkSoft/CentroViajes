import 'dart:convert';

import 'package:cvs_ec_app/domain/domain.dart';

class AuthResponseModel {
    String jsonrpc;
    dynamic id;
    AuthModel? result;
    ErrorLoginResponseModel? error;

    AuthResponseModel({
        required this.jsonrpc,
        required this.id,
        this.result,
        this.error
    });
     
    factory AuthResponseModel.fromJson(String str) => AuthResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

//json.containsKey("result")

    /*
    factory AuthResponseModel.fromMap(Map<String, dynamic> json) {
      if(json.containsKey("result")){
        return AuthResponseModel(      
          jsonrpc: json["jsonrpc"] ?? '',
          id: json["id"] ?? null,
          result: AuthModel.fromJson(json["result"]),
          error: null,
        );
      }
      else {
        return AuthResponseModel(      
          jsonrpc: json["jsonrpc"] ?? '',
          id: json["id"]  ?? null,
          result: null,
          error: json["error"] != null ? ErrorLoginResponseModel.fromJson(json["error"])
                  : null,
        );
      }
    }
    */

      factory AuthResponseModel.fromMap(Map<String, dynamic> json) {
        return AuthResponseModel(
          jsonrpc: json['jsonrpc'] ?? '',
          id: json['id'],
          result: json['result'] != null ? AuthModel.fromJson(json['result']) : null,
          error: json['error'] != null ? ErrorLoginResponseModel.fromJson(json['error']) : null,
        );
      }

    Map<String, dynamic> toMap() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result?.toJson(),
    };

}

class AuthModel {
    int uid;
    bool isSystem;
    bool isAdmin;
    bool isPublic;
    bool isInternalUser;
    UserContextAuth userContext;
    String db;
    UserSettingsAuth userSettings;
    String serverVersion;
    List<dynamic> serverVersionInfo;
    String supportUrl;
    String name;
    String username;
    String partnerDisplayName;
    int partnerId;
    String webBaseUrl;
    int activeIdsLimit;
    dynamic profileSession;
    dynamic profileCollectors;
    dynamic profileParams;
    int maxFileUploadSize;
    bool homeActionId;
    CacheHashesAuth cacheHashes;
    CurrenciesAuth currencies;
    BundleParamsAuth bundleParams;
    List<int> userId;
    String websocketWorkerVersion;
    bool isQuickEditModeEnabled;
    int currentCompany;
    Map<String, CompanyAuth> allowedCompanies;
    DonePermissionsAuth donePermissions;
    String doneSupportUrl;
    String doneTermsOfUseUrl;

    AuthModel({
        required this.uid,
        required this.isSystem,
        required this.isAdmin,
        required this.isPublic,
        required this.isInternalUser,
        required this.userContext,
        required this.db,
        required this.userSettings,
        required this.serverVersion,
        required this.serverVersionInfo,
        required this.supportUrl,
        required this.name,
        required this.username,
        required this.partnerDisplayName,
        required this.partnerId,
        required this.webBaseUrl,
        required this.activeIdsLimit,
        required this.profileSession,
        required this.profileCollectors,
        required this.profileParams,
        required this.maxFileUploadSize,
        required this.homeActionId,
        required this.cacheHashes,
        required this.currencies,
        required this.bundleParams,
        required this.userId,
        required this.websocketWorkerVersion,
        required this.isQuickEditModeEnabled,
        required this.currentCompany,
        required this.allowedCompanies,
        required this.donePermissions,
        required this.doneSupportUrl,
        required this.doneTermsOfUseUrl,
    });


    factory AuthModel.fromJson(String str) => AuthModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AuthModel.fromMap(Map<String, dynamic> json) => AuthModel(
        uid: json["uid"] ?? 0,
        isSystem: json["is_system"],
        isAdmin: json["is_admin"],
        isPublic: json["is_public"],
        isInternalUser: json["is_internal_user"],
        userContext: json["user_context"] != null ? 
          UserContextAuth.fromJson(json["user_context"])
          :
          UserContextAuth(
            lang: '',
            tz: '',
            uid: 0
          ),
        db: json["db"],
        userSettings: json["user_settings"] != null ? 
          UserSettingsAuth.fromJson(json["user_settings"])
          :
          UserSettingsAuth(
            homemenuConfig: false,
            id: 0,
            isDiscussSidebarCategoryChannelOpen: false,
            isDiscussSidebarCategoryChatOpen: false,
            isDiscussSidebarCategoryLivechatOpen: false,
            isDiscussSidebarCategoryWhatsappOpen: false,
            livechatLangIds: [],
            livechatUsername: false,
            pushToTalkKey: false,
            usePushToTalk: false,
            userId: UserIdAuth (id: 0),
            voiceActiveDuration: 0,
            volumeSettingsIds: []
          ),
        serverVersion: json["server_version"],
        serverVersionInfo: List<dynamic>.from(json["server_version_info"].map((x) => x)),
        supportUrl: json["support_url"],
        name: json["name"],
        username: json["username"],
        partnerDisplayName: json["partner_display_name"],
        partnerId: json["partner_id"],
        webBaseUrl: json["web.base.url"],
        activeIdsLimit: json["active_ids_limit"],
        profileSession: json["profile_session"],
        profileCollectors: json["profile_collectors"],
        profileParams: json["profile_params"],
        maxFileUploadSize: json["max_file_upload_size"],
        homeActionId: json["home_action_id"],
        cacheHashes: json["cache_hashes"] != null ?
          CacheHashesAuth.fromJson(json["cache_hashes"])
          :
          CacheHashesAuth(
            translations: ''
          ),
        currencies: json["currencies"] != null ?
          CurrenciesAuth.fromJson(json["currencies"])
          :
          CurrenciesAuth(the1: The1Auth(digits: [], position: '', symbol: '')),
        bundleParams: json["bundle_params"] != null ? 
          BundleParamsAuth.fromJson(json["bundle_params"])
          :
          BundleParamsAuth(
            lang: ''
          ),
        userId: List<int>.from(json["user_id"].map((x) => x)),
        websocketWorkerVersion: json["websocket_worker_version"],
        isQuickEditModeEnabled: json["is_quick_edit_mode_enabled"],
        currentCompany: json["current_company"],
        allowedCompanies: Map.from(json["allowed_companies"]).map((k, v) => MapEntry<String, CompanyAuth>(k, CompanyAuth.fromJson(v))),
        donePermissions: json["done_permissions"] != null ? 
          DonePermissionsAuth.fromJson(json["done_permissions"])
          :
          DonePermissionsAuth(
            buttons: ButtonsAuth(btnCreateLead: false, btnProgressOfTheDay: false),
            mainMenu: MainMenuAuth(
              cardCollection: false,
              cardSales: false,
              itemListCatalog: false,
              itemListDistribution: false,
              itemListInventory: false,
              itemListLeads: false,
              itemListPartners: false,
              itemListPriceList: false,
              itemListPromotions: false,
              itemScheduledVisits: false
            )
          ),
        doneSupportUrl: json["done_support_url"],
        doneTermsOfUseUrl: json["done_terms_of_use_url"],
    );

    Map<String, dynamic> toMap() => {
        "uid": uid,
        "is_system": isSystem,
        "is_admin": isAdmin,
        "is_public": isPublic,
        "is_internal_user": isInternalUser,
        "user_context": userContext.toJson(),
        "db": db,
        "user_settings": userSettings.toJson(),
        "server_version": serverVersion,
        "server_version_info": List<dynamic>.from(serverVersionInfo.map((x) => x)),
        "support_url": supportUrl,
        "name": name,
        "username": username,
        "partner_display_name": partnerDisplayName,
        "partner_id": partnerId,
        "web.base.url": webBaseUrl,
        "active_ids_limit": activeIdsLimit,
        "profile_session": profileSession,
        "profile_collectors": profileCollectors,
        "profile_params": profileParams,
        "max_file_upload_size": maxFileUploadSize,
        "home_action_id": homeActionId,
        "cache_hashes": cacheHashes.toJson(),
        "currencies": currencies.toJson(),
        "bundle_params": bundleParams.toJson(),
        "user_id": List<dynamic>.from(userId.map((x) => x)),
        "websocket_worker_version": websocketWorkerVersion,
        "is_quick_edit_mode_enabled": isQuickEditModeEnabled,
        "current_company": currentCompany,
        "allowed_companies": Map.from(allowedCompanies).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "done_permissions": donePermissions.toJson(),
        "done_support_url": doneSupportUrl,
        "done_terms_of_use_url": doneTermsOfUseUrl,
    };
}

class CompanyAuth {
    int id;
    String name;
    int sequence;
    bool parentId;

    CompanyAuth({
        required this.id,
        required this.name,
        required this.sequence,
        required this.parentId,
    });

    factory CompanyAuth.fromJson(String str) => CompanyAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CompanyAuth.fromMap(Map<String, dynamic> json) => CompanyAuth(
        id: json["id"],
        name: json["name"],
        sequence: json["sequence"],
        parentId: json["parent_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "sequence": sequence,
        "parent_id": parentId,
    };
}

class BundleParamsAuth {
    String lang;

    BundleParamsAuth({
        required this.lang,
    });

    factory BundleParamsAuth.fromJson(String str) => BundleParamsAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BundleParamsAuth.fromMap(Map<String, dynamic> json) => BundleParamsAuth(
        lang: json["lang"],
    );

    Map<String, dynamic> toMap() => {
        "lang": lang,
    };
}

class CacheHashesAuth {
    String translations;

    CacheHashesAuth({
        required this.translations,
    });

    factory CacheHashesAuth.fromJson(String str) => CacheHashesAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CacheHashesAuth.fromMap(Map<String, dynamic> json) => CacheHashesAuth(
        translations: json["translations"],
    );

    Map<String, dynamic> toMap() => {
        "translations": translations,
    };
}

class CurrenciesAuth {
    The1Auth the1;

    CurrenciesAuth({
        required this.the1,
    });

    factory CurrenciesAuth.fromJson(String str) => CurrenciesAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CurrenciesAuth.fromMap(Map<String, dynamic> json) => CurrenciesAuth(
        the1: The1Auth.fromJson(json["1"]),
    );

    Map<String, dynamic> toMap() => {
        "1": the1.toJson(),
    };
}

class The1Auth {
    String symbol;
    String position;
    List<int> digits;

    The1Auth({
        required this.symbol,
        required this.position,
        required this.digits,
    });

    factory The1Auth.fromJson(String str) => The1Auth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory The1Auth.fromMap(Map<String, dynamic> json) => The1Auth(
        symbol: json["symbol"],
        position: json["position"],
        digits: List<int>.from(json["digits"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "symbol": symbol,
        "position": position,
        "digits": List<dynamic>.from(digits.map((x) => x)),
    };
}

class DonePermissionsAuth {
    MainMenuAuth mainMenu;
    ButtonsAuth buttons;

    DonePermissionsAuth({
        required this.mainMenu,
        required this.buttons,
    });

    factory DonePermissionsAuth.fromJson(String str) => DonePermissionsAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DonePermissionsAuth.fromMap(Map<String, dynamic> json) => DonePermissionsAuth(
        mainMenu: MainMenuAuth.fromJson(json["main_menu"]),
        buttons: ButtonsAuth.fromJson(json["buttons"]),
    );

    Map<String, dynamic> toMap() => {
        "main_menu": mainMenu.toJson(),
        "buttons": buttons.toJson(),
    };
}

class ButtonsAuth {
    bool btnProgressOfTheDay;
    bool btnCreateLead;

    ButtonsAuth({
        required this.btnProgressOfTheDay,
        required this.btnCreateLead,
    });

    factory ButtonsAuth.fromJson(String str) => ButtonsAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ButtonsAuth.fromMap(Map<String, dynamic> json) => ButtonsAuth(
        btnProgressOfTheDay: json["btn_progress_of_the_day"],
        btnCreateLead: json["btn_create_lead"],
    );

    Map<String, dynamic> toMap() => {
        "btn_progress_of_the_day": btnProgressOfTheDay,
        "btn_create_lead": btnCreateLead,
    };
}

class MainMenuAuth {
    bool cardSales;
    bool cardCollection;
    bool itemListPartners;
    bool itemScheduledVisits;
    bool itemListLeads;
    bool itemListCatalog;
    bool itemListInventory;
    bool itemListPriceList;
    bool itemListPromotions;
    bool itemListDistribution;

    MainMenuAuth({
        required this.cardSales,
        required this.cardCollection,
        required this.itemListPartners,
        required this.itemScheduledVisits,
        required this.itemListLeads,
        required this.itemListCatalog,
        required this.itemListInventory,
        required this.itemListPriceList,
        required this.itemListPromotions,
        required this.itemListDistribution,
    });

    factory MainMenuAuth.fromJson(String str) => MainMenuAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MainMenuAuth.fromMap(Map<String, dynamic> json) => MainMenuAuth(
        cardSales: json["card_sales"],
        cardCollection: json["card_collection"],
        itemListPartners: json["item_list_partners"],
        itemScheduledVisits: json["item_scheduled_visits"],
        itemListLeads: json["item_list_leads"],
        itemListCatalog: json["item_list_catalog"],
        itemListInventory: json["item_list_inventory"],
        itemListPriceList: json["item_list_price_list"],
        itemListPromotions: json["item_list_promotions"],
        itemListDistribution: json["item_list_distribution"],
    );

    Map<String, dynamic> toMap() => {
        "card_sales": cardSales,
        "card_collection": cardCollection,
        "item_list_partners": itemListPartners,
        "item_scheduled_visits": itemScheduledVisits,
        "item_list_leads": itemListLeads,
        "item_list_catalog": itemListCatalog,
        "item_list_inventory": itemListInventory,
        "item_list_price_list": itemListPriceList,
        "item_list_promotions": itemListPromotions,
        "item_list_distribution": itemListDistribution,
    };
}

class UserContextAuth {
    String lang;
    String tz;
    int uid;

    UserContextAuth({
        required this.lang,
        required this.tz,
        required this.uid,
    });

    factory UserContextAuth.fromJson(String str) => UserContextAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserContextAuth.fromMap(Map<String, dynamic> json) => UserContextAuth(
        lang: json["lang"],
        tz: json["tz"],
        uid: json["uid"],
    );

    Map<String, dynamic> toMap() => {
        "lang": lang,
        "tz": tz,
        "uid": uid,
    };
}

class UserSettingsAuth {
    int id;
    UserIdAuth userId;
    bool isDiscussSidebarCategoryChannelOpen;
    bool isDiscussSidebarCategoryChatOpen;
    bool pushToTalkKey;
    bool usePushToTalk;
    int voiceActiveDuration;
    List<List<dynamic>> volumeSettingsIds;
    bool homemenuConfig;
    bool isDiscussSidebarCategoryWhatsappOpen;
    bool livechatUsername;
    List<dynamic> livechatLangIds;
    bool isDiscussSidebarCategoryLivechatOpen;

    UserSettingsAuth({
        required this.id,
        required this.userId,
        required this.isDiscussSidebarCategoryChannelOpen,
        required this.isDiscussSidebarCategoryChatOpen,
        required this.pushToTalkKey,
        required this.usePushToTalk,
        required this.voiceActiveDuration,
        required this.volumeSettingsIds,
        required this.homemenuConfig,
        required this.isDiscussSidebarCategoryWhatsappOpen,
        required this.livechatUsername,
        required this.livechatLangIds,
        required this.isDiscussSidebarCategoryLivechatOpen,
    });

    factory UserSettingsAuth.fromJson(String str) => UserSettingsAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserSettingsAuth.fromMap(Map<String, dynamic> json) => UserSettingsAuth(
        id: json["id"],
        userId: UserIdAuth.fromJson(json["user_id"]),
        isDiscussSidebarCategoryChannelOpen: json["is_discuss_sidebar_category_channel_open"],
        isDiscussSidebarCategoryChatOpen: json["is_discuss_sidebar_category_chat_open"],
        pushToTalkKey: json["push_to_talk_key"],
        usePushToTalk: json["use_push_to_talk"],
        voiceActiveDuration: json["voice_active_duration"],
        volumeSettingsIds: List<List<dynamic>>.from(json["volume_settings_ids"].map((x) => List<dynamic>.from(x.map((x) => x)))),
        homemenuConfig: json["homemenu_config"],
        isDiscussSidebarCategoryWhatsappOpen: json["is_discuss_sidebar_category_whatsapp_open"],
        livechatUsername: json["livechat_username"],
        livechatLangIds: List<dynamic>.from(json["livechat_lang_ids"].map((x) => x)),
        isDiscussSidebarCategoryLivechatOpen: json["is_discuss_sidebar_category_livechat_open"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId.toJson(),
        "is_discuss_sidebar_category_channel_open": isDiscussSidebarCategoryChannelOpen,
        "is_discuss_sidebar_category_chat_open": isDiscussSidebarCategoryChatOpen,
        "push_to_talk_key": pushToTalkKey,
        "use_push_to_talk": usePushToTalk,
        "voice_active_duration": voiceActiveDuration,
        "volume_settings_ids": List<dynamic>.from(volumeSettingsIds.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "homemenu_config": homemenuConfig,
        "is_discuss_sidebar_category_whatsapp_open": isDiscussSidebarCategoryWhatsappOpen,
        "livechat_username": livechatUsername,
        "livechat_lang_ids": List<dynamic>.from(livechatLangIds.map((x) => x)),
        "is_discuss_sidebar_category_livechat_open": isDiscussSidebarCategoryLivechatOpen,
    };

}

class UserIdAuth {
    int id;

    UserIdAuth({
        required this.id,
    });

    factory UserIdAuth.fromJson(String str) => UserIdAuth.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserIdAuth.fromMap(Map<String, dynamic> json) => UserIdAuth(
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
    };

}
