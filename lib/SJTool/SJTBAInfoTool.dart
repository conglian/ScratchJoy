import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';


void sj_session_fire() async {
  var baseBody = await SJRequestHelpers().baseBody();
  baseBody["coax"] = 'chandler';
  SJRequestHelpers().post(baseBody, 2);
}

void sj_ad_fire(Map<String, dynamic> body) async {
  var baseBody = await SJRequestHelpers().baseBody();
  baseBody["taciturn"] = body;
  SJRequestHelpers().post(baseBody, 3);
}

void sj_event_fire(String name, Map<String, dynamic> body) async {
  var baseBodys = await SJRequestHelpers().baseBody();
  baseBodys["coax"] = name;
  for (String key in body.keys){
    baseBodys['calais@$key'] = body[key];
  }
  SJRequestHelpers().post(baseBodys, 0);
}

void sj_install_fire() async {
  var baseBody = await SJRequestHelpers().baseBody();
  var map = await FlutterTbaInfo.instance.getReferrerMap();
  Map<String, dynamic> leibniz = {
    'covert' : map['build'],
    'yell' : map['referrer_url'],
    'fermium' : map['install_version'],
    'grosset' : map['user_agent'],
    'menorca' : 'oatmeal',
    'moreland' : map['referrer_click_timestamp_seconds'],
    'honest' : map['install_begin_timestamp_seconds'],
    'soak' : map['referrer_click_timestamp_server_seconds'],
    'fraud' : map['install_begin_timestamp_server_seconds'],
    'whee' : map['install_first_seconds'],
    'bimini' : map['last_update_seconds'],
  };
  baseBody["leibniz"] = leibniz;
  SJRequestHelpers().post(baseBody, 1);
}

class SJRequestHelpers {
  static final SJRequestHelpers _instance = SJRequestHelpers._internal();

  factory SJRequestHelpers() {
    return _instance;
  }

  SJRequestHelpers._internal();

  static String cloak_Url =
      "https://angstrom.crazerushscrajoy.com/buttrick/distal/inherent";

  // static String tba_event_Url =
  //     "https://test-gallup.crazerushscrajoy.com/shoemake/mango/row";

  static String tba_event_Url =
      "https://gallup.crazerushscrajoy.com/ps/parish/grackle";

  final Map<String, String> normalHeader = {
    'Content-Type': 'application/json',
  };

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> getCloak() async {
    var url = Uri.parse("${cloak_Url}?${await getConfigQueryString()}");
    "scratch play land config request ${url}".log();
    try {
      var response = await http.get(
        url,
        headers: normalHeader,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  Future<dynamic> post(dynamic data, int type) async {
    var eventName = "";
    if (type == 0) {
      eventName = "event";
    } else if (type == 1) {
      eventName = "install";
    } else if (type == 2) {
      eventName = "session";
    } else {
      eventName = "ad";
    }
    var url = Uri.parse(
        "${tba_event_Url}");
    "upload event [${eventName}] url ${url} \n ${data}".log();
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode(data),
      );
      print("upload event [${eventName}] success ${response.body}");
      // "upload event [${eventName}] success ${response.body}".log();
      return _handleResponse(response);
    } catch (e) {
      "upload event [${eventName}] faild".log();
      throw Exception('Failed to perform POST request: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  void _refreshHeader() async {
    eventHeader = {
      'Content-Type': 'application/json',
    };
  }

  void init() {
    _refreshHeader();
  }


}
// request parmerters
extension RequestHelpersExtension on SJRequestHelpers {
  Future<String> getConfigQueryString() async {
    var queryBody = {
      "cab": await FlutterTbaInfo.instance.getBundleId(),
      "afghan": 'fleming',
      "merry": await FlutterTbaInfo.instance.getAppVersion(),
    };
    return Uri(queryParameters: queryBody).query;
  }

  Future<Map<String, dynamic>> baseBody() async {
    Map<String, dynamic> baseBody = {};
    Map<String, dynamic> genuine = {
      'aaron' : await FlutterTbaInfo.instance.getBrand(),
      'leftmost' : await FlutterTbaInfo.instance.getOsCountry(),
      'graceful' : await FlutterTbaInfo.instance.getDistinctId(),
      'afghan' : 'fleming',
      "against": await FlutterTbaInfo.instance.getLogId(),
      'eidetic' : await FlutterTbaInfo.instance.getManufacturer(),
      "durance": await FlutterTbaInfo.instance.getNetworkType(),
      'anglican' : await FlutterTbaInfo.instance.getOsVersion(),
      "solace": await FlutterTbaInfo.instance.getGaid(),
      'jennifer' : await FlutterTbaInfo.instance.getSystemLanguage(),
      "puffery": await FlutterTbaInfo.instance.getOperator(),
      'mystery' : await FlutterTbaInfo.instance.getAndroidId(),
      'merry' : await FlutterTbaInfo.instance.getAppVersion(),
      'archaic' : DateTime.now().millisecondsSinceEpoch,
      "cab": await FlutterTbaInfo.instance.getBundleId(),
      "ah": await FlutterTbaInfo.instance.getDeviceModel(),
    };
    baseBody['genuine'] = genuine;

    return baseBody;
  }

}