import 'dart:core';

import 'package:dio/dio.dart';
import 'dart:convert';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class HttpUtil {
  // 工厂模式
  factory HttpUtil() => getInstance();

  static HttpUtil get instance => getInstance();
  static HttpUtil _instance;

  final String tag = "HttpUtil";

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

  /*FormData formData = new FormData.from({
    "file": new UploadFileInfo(new File(path), name)
  });*/

  void upload(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function success,
      Function error}) async {
    FormData formData = FormData.from(data);

    // 发送post请求
    _sendRequest(url, 'post', success,
        formData: formData, headers: headers, error: error);
  }

  // 请求处理
  Future _sendRequest(String url, String method, Function success,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      FormData formData,
      Function error}) async {
    String _msg;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = baseUrl + url;
    }
    netPrint("=========================================");
    netPrint("-----------------------------------------");
    netPrint(method + " " + url);
    netPrint(data);

    Map<String, dynamic> dataMap = data == null ? new Map() : data;
    Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

    headersMap.addAll(this.dataMap);

    // 配置dio请求信息
    Response response;
    Dio dio = new Dio();
    dio.options.connectTimeout = 10000; // 服务器链接超时，毫秒
    dio.options.receiveTimeout = 30000; // 响应流上前后两次接受到数据的间隔，毫秒
    dio.options.headers.addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

    if (method == 'get') {
      response = await dio.get(url);
    } else {
      response = await dio.post(url, data: formData, queryParameters: dataMap);
    }

    if (response.statusCode != 200) {
      _msg = '网络请求错误,状态码:' + response.statusCode.toString();
      netPrint(response.data);
      _handError(error, _msg);
      return;
    }

    netPrint(response.data);
    if (success != null) success(response.data);
  }

  // 返回错误信息
  Future _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
      netPrint(errorMsg);
    }
  }

  netPrint(res) {
    if (!inProduction) print('$tag ===> $res');
  }

  //开始使用dart的方式进行网络请求
  Future getAwait(
    String url, {
    Map<String, dynamic> data,
    Map<String, dynamic> headers,
  }) async {
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
    return await _awaitRequest(url, 'get', headers: headers);
  }

  Future<NetResponse> postAwait(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      NetConverter netConverter}) async {
    // 发送post请求
    return await _awaitRequest(
      url,
      'post',
      data: data,
      netConverter: netConverter,
      headers: headers,
    );
  }

  // 请求处理
  Future _awaitRequest(String url, String method,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      NetConverter netConverter,
      FormData formData}) async {
    String _msg;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = baseUrl + url;
    }
    netPrint("================= await  ========================");
    netPrint("-----------------------------------------");
    netPrint(method + " " + url);
    netPrint(data);

    Map<String, dynamic> dataMap = data == null ? new Map() : data;
    Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

    headersMap.addAll(this.dataMap);

    // 配置dio请求信息
    Response response;
    Dio dio = new Dio();
    dio.options.connectTimeout = 10000; // 服务器链接超时，毫秒
    dio.options.receiveTimeout = 30000; // 响应流上前后两次接受到数据的间隔，毫秒
    dio.options.headers.addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

    if (method == 'get') {
      response = await dio.get(url);
    } else {
      response = await dio.post(url, data: formData, queryParameters: dataMap);
    }

    NetResponse item = NetResponse();
    item.code = response.statusCode;

    if (response.statusCode != 200) {
      item.msg = response.statusCode.toString();
    }

    netPrint(response.data);

//    item.data = response.data;

    item.data = netConverter?.converter(response.data) ?? response.data;

    netPrint("-------------------- end ---------------------");
    netPrint("================= await  ========================");

    return item;
  }
}

class NetResponse<T> {
  int code;
  String msg;
  T data;
}

abstract class NetConverter<T> {
  T converter(Map data);
}
