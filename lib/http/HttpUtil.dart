import 'dart:core';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:dio_http_cache/dio_http_cache.dart';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");

Dio dio = new Dio();

class HttpUtil {
  // 工厂模式
  factory HttpUtil() => getInstance();

  static HttpUtil get instance => getInstance();
  static HttpUtil _instance;
  Map<String, dynamic> dataMap;
  final String tag = "HttpUtil";

  HttpUtil._internal() {
    if (!inProduction)
      dio.interceptors.add(LogInterceptor(responseBody: true)); //开启请求日志
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, String host, int port) {
        return true;
      };
    };
    dio.options.connectTimeout = 10000; // 服务器链接超时，毫秒
    dio.options.receiveTimeout = 30000; // 响应流上前后两次接受到数据的间隔，毫秒
    dio.options.followRedirects = true;
    if(this.dataMap!=null&&this.dataMap.length>0){
      dio.options.headers.addAll(this.dataMap); // 添加headers,如需设置统一的headers信息也可在此添加
    }

    dio.options.contentType = Headers.formUrlEncodedContentType;


  }

  static HttpUtil getInstance() {
    if (_instance == null) {
      _instance = new HttpUtil._internal();
    }
    return _instance;
  }



  void addHeader(Map<String, dynamic> data) {
    dataMap = data;
    if(this.dataMap!=null&&this.dataMap.length>0){
      dio.options.headers.addAll(this.dataMap); // 添加headers,如需设置统一的headers信息也可在此添加
    }
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


  void upload(String url,
      {FormData data,
        Map<String, dynamic> headers,
        Function success,
        Function error}) async {
    dio.options.contentType = 'multipart/form-data';
    // 发送post请求
    _sendRequest(url, 'post', (res){
      dio.options.contentType = Headers.formUrlEncodedContentType;
      success(res);
    },
        formData: data, headers: headers, error: error);
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

    Response response;

    response = await send(method, response, url, data??formData);

    response?.statusCode??=503;
    if (response.statusCode != 200) {
      _msg = '网络请求错误,状态码:' + response.statusCode.toString();
      _handError(error, _msg);
      return;
    }

    if (success != null) success(response.data);
  }

  // 返回错误信息
  Future _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
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

  Future postAwait(String url,
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
    // 配置dio请求信息
    Response response;
    try {
      response = await send(method, response, url, formData??data);
    } catch (e) {
      if (netConverter != null) netConverter.onError(e);
    }

    NetResponse item = NetResponse();

    response?.statusCode??=503;

    item.code = response.statusCode;

    if (response.statusCode != 200) {
      item.msg = response.statusCode.toString();
    }

    if (netConverter == null) {
      item.data = response.data;
      return item;
    } else {
      return netConverter?.converter(response.data);
    }

  }

  Future<Response> send(String method, Response response, String url, Map<String, dynamic> data) async {

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = baseUrl + url;
    }
    if (method == 'get') {
      response = await dio.get(url,
          options: buildCacheOptions(Duration(seconds: 5),
            maxStale: Duration(days: 7), ));
    } else {
      response = await dio.post(url,
          data: data,
          options: buildCacheOptions(Duration(seconds: 5),
            maxStale: Duration(days: 7),),queryParameters: data);
    }
    return response;
  }
}

class NetResponse<T> {
  int code;
  String msg;
  T data;
}

abstract class NetConverter<T> {
  T converter(Map data);

  onError(e) {
    print(e.toString());
  }
}
