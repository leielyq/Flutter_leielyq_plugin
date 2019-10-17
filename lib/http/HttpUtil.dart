import 'package:dio/dio.dart';
import 'dart:convert';

class HttpUtil {
  // 工厂模式
  factory HttpUtil() => getInstance();

  static HttpUtil get instance => getInstance();
  static HttpUtil _instance;

  HttpUtil._internal() {}

  static HttpUtil getInstance() {
    if (_instance == null) {
      _instance = new HttpUtil._internal();
    }
    return _instance;
  }

  Map<String, dynamic> dataMap;

  void addHeader(Map<String, dynamic> data) {
    dataMap = data;
  }

  String baseUrl = '';

  void changBaseUrl(String url) {
    baseUrl = url;
  }

  void get(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function success,
      Function error}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }

    // 发送get请求
    await _sendRequest(url, 'get', success, headers: headers, error: error);
  }

  void post(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function success,
      Function error}) async {
    // 发送post请求
    _sendRequest(url, 'post', success,
        data: data, headers: headers, error: error);
  }

  // 请求处理
  Future _sendRequest(String url, String method, Function success,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function error}) async {
    int _code;
    String _msg;
    var _backData;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = baseUrl + url;
    }
    print("=========================================");
    print("-----------------------------------------");
    print(method + " " + url);
    print(data);
    try {
      Map<String, dynamic> dataMap = data == null ? new Map() : data;
      Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

      headersMap.addAll(this.dataMap);

      // 配置dio请求信息
      Response response;
      Dio dio = new Dio();
      dio.options.connectTimeout = 10000; // 服务器链接超时，毫秒
      dio.options.receiveTimeout = 3000; // 响应流上前后两次接受到数据的间隔，毫秒
      dio.options.headers
          .addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

      if (method == 'get') {
        response = await dio.get(url);
      } else {
        response = await dio.post(url, data: dataMap, queryParameters: dataMap);
      }

      if (response.statusCode != 200) {
        _msg = '网络请求错误,状态码:' + response.statusCode.toString();
        _handError(error, _msg);
        return;
      }

      print(response.data);

      // 返回结果处理
      Map<String, dynamic> resCallbackMap = response.data;
      _code = resCallbackMap['code'];
      _msg = resCallbackMap['errmsg'];
      _backData = resCallbackMap['data'];

      bool _flag = resCallbackMap['flag'];

      if (success != null) {
        if (_flag) {
          success(_backData);
        } else {
          String errorMsg = _code.toString() + ':' + _msg;
          _handError(error, errorMsg);
        }
      }
    } catch (exception) {
      _handError(error, '数据请求错误：' + exception.toString());
    }
  }

  // 返回错误信息
  Future _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
      print(errorMsg);
    }
  }
}
