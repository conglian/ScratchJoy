import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';


void sj_session_fire() async {
  var baseBody = await SJRequestHelpers().baseBody();
  baseBody["cobra"] = 'method';
  SJRequestHelpers().post(baseBody, 2);
}

void sj_ad_fire(Map<String, dynamic> body) async {
  var baseBody = await SJRequestHelpers().baseBody();
  for (String key in body.keys){
    baseBody[key] = body[key];
  }
  baseBody["cobra"] = 'bisque';
  SJRequestHelpers().post(baseBody, 3);
}

void sj_event_fire(String name, Map<String, dynamic> body) async {
  var baseBodys = await SJRequestHelpers().baseBody();
  baseBodys["cobra"] = name;
  baseBodys[name] = body;
  SJRequestHelpers().post(baseBodys, 0);
}

void sj_install_fire() async {
  var baseBody = await SJRequestHelpers().baseBody();
  var map = await FlutterTbaInfo.instance.getReferrerMap();
  Map<String, dynamic> nagasaki = {
    'irish' : map['build'],
    'beg' : map['referrer_url'],
    'john' : map['install_version'],
    'usia' : map['user_agent'],
    'ntis' : 'injunct',
    'racket' : map['referrer_click_timestamp_seconds'],
    'tripoli' : map['install_begin_timestamp_seconds'],
    'microbe' : map['referrer_click_timestamp_server_seconds'],
    'crop' : map['install_begin_timestamp_server_seconds'],
    'upset' : map['install_first_seconds'],
    'swirly' : map['last_update_seconds'],
    // 'wu' : map['google_play_instant'],
  };
  baseBody["nagasaki"] = nagasaki;
  SJRequestHelpers().post(baseBody, 1);
}

class SJRequestHelpers {
  static final SJRequestHelpers _instance = SJRequestHelpers._internal();
  static const MethodChannel _nativeHelper = MethodChannel('Scratch_Win_channel');

  factory SJRequestHelpers() {
    return _instance;
  }

  SJRequestHelpers._internal();

  static String cloak_Url =
      "https://aisle.scratchplayland.com/topmost/humus/tress";

  // static String tba_event_Url =
  //     "https://test-fugue.scratchplayland.com/forum/adobe/ductwork";

  static String tba_event_Url =
      "https://fugue.scratchplayland.com/cookbook/dose";

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
      "comment": await FlutterTbaInfo.instance.getBundleId(),
      "allen": 'iodinate',
      "cupful": await FlutterTbaInfo.instance.getAppVersion(),
    };
    return Uri(queryParameters: queryBody).query;
  }

  Future<Map<String, dynamic>> baseBody() async {
    Map<String, dynamic> baseBody = {};
    Map<String, dynamic> vinci = {
      'inapt' : await FlutterTbaInfo.instance.getBrand(),
      'tingle' : await FlutterTbaInfo.instance.getOsCountry(),
      'ala' : await FlutterTbaInfo.instance.getDistinctId(),
      'allen' : 'iodinate',
      "antic": await FlutterTbaInfo.instance.getLogId(),
      'constant' : await FlutterTbaInfo.instance.getManufacturer(),
      "hedge": await FlutterTbaInfo.instance.getNetworkType(),
      'confide' : await FlutterTbaInfo.instance.getOsVersion(),
    };
    baseBody['vinci'] = vinci;

    Map<String, dynamic> insult = {
      "isle": await FlutterTbaInfo.instance.getGaid(),
      'sauna' : await FlutterTbaInfo.instance.getSystemLanguage(),
      "carmela": await FlutterTbaInfo.instance.getOperator(),
      'epiphyte' : await FlutterTbaInfo.instance.getAndroidId(),
      'cupful' : await FlutterTbaInfo.instance.getAppVersion(),
      'dream' : DateTime.now().millisecondsSinceEpoch,
      "comment": await FlutterTbaInfo.instance.getBundleId(),
      "frilly": await FlutterTbaInfo.instance.getDeviceModel(),
    };
    baseBody['insult'] = insult;
    return baseBody;
  }

}