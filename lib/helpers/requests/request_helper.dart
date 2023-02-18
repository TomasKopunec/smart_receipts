import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:smart_receipts/helpers/requests/http_exception.dart';
import 'package:smart_receipts/helpers/requests/response.dart';
import 'package:smart_receipts/utils/logger.dart';

enum RequestType { post, get, patch, put, delete }

class RequestHelper {
  final Logger logger = Logger(RequestHelper);

  final String host = "digitalreceipts.azurewebsites.net";
  final String functionKey =
      "nDDhMcGI64BL0foQDGp8t-9D9URyyi1mlvEHvpK2rn1tAzFuA86DDw==";

  /// Sends a request and logs
  Future<Response> send(
      {required String name,
      required RequestType type,
      required String path,
      Object? body,
      String? authToken}) async {
    final Map<String, String> headers = {
      'x-functions-key': functionKey,
      'Authorization': authToken ?? "",
      'Content-Type': 'application/json'
    };

    _log(name.toUpperCase(), headers, body, true);

    final Response response = await _send(type, path,
        body: body, headers: headers, authToken: authToken);

    _log(name.toUpperCase(), response.headers, response.body, false,
        statusCode: response.code, exception: response.exception);
    return response;
  }

  /// Sends any type of request
  Future<Response> _send(
    RequestType requestType,
    String path, {
    String? authToken,
    Object? body,
    Map<String, String>? headers,
  }) async {
    Future<http.Response>? future;
    // final Uri uri = Uri.https(host, "/api/$path");
    final Uri uri = Uri(scheme: 'https', host: host, path: '/api/$path');

    switch (requestType) {
      case RequestType.post:
        future = http.post(uri, body: body, headers: headers);
        break;
      case RequestType.get:
        future = http.get(uri, headers: headers);
        break;
      case RequestType.patch:
        future = http.patch(uri, body: body, headers: headers);
        break;
      case RequestType.put:
        future = http.put(uri, body: body, headers: headers);
        break;
      case RequestType.delete:
        future = http.delete(uri, body: body, headers: headers);
        break;
    }

    final response = await future
        .timeout(const Duration(seconds: 20)) // Default of 15s timeout
        .onError((err, stackTrace) {
      print('${err.runtimeType.toString()} occured sending a request!');
      print('Message: $err');
      throw Exception(
          '${err.runtimeType.toString()} occured sending a request! \n Message: $err');
    });

    return _getResponse(response);
  }

  Future<Response> _get(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.get, path, body: body, authToken: authToken);
  }

  Future<Response> _post(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.post, path, body: body, authToken: authToken);
  }

  Future<Response> _put(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.put, path, body: body, authToken: authToken);
  }

  Future<Response> _patch(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.patch, path, body: body, authToken: authToken);
  }

  Future<Response> _delete(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.delete, path, body: body, authToken: authToken);
  }

  Response _getResponse(http.Response httpResponse) {
    final Response response = Response(
        code: httpResponse.statusCode,
        headers: httpResponse.headers,
        body: httpResponse.body,
        exception: httpResponse.reasonPhrase);

    if (response.code >= 200 && response.code < 500) {
      // Success
      return response;
    } else {
      throw HttpException(ExceptionType.serverError, response.exception!);
    }
  }

  void _log(
    String methodName,
    Object? headers,
    Object? body,
    bool isRequest, {
    int? statusCode,
    String? exception,
  }) {
    const JsonDecoder decoder = JsonDecoder();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

    String? formattedHeaders;
    String? formattedBody;

    try {
      formattedHeaders = encoder.convert(headers);
    } catch (e) {}

    try {
      formattedBody = encoder.convert(decoder.convert(body.toString()));
    } catch (e) {}

    logger.log("$methodName ${isRequest ? 'request' : 'response'}",
        name: 'API');

    if (!isRequest) {
      if (statusCode != null) {
        logger.log("Status Code: $statusCode", name: 'API');
      }

      if (exception != null && exception != "OK") {
        logger.log("Exception: $exception", name: 'API');
      }
    }

    if (formattedHeaders == null || formattedHeaders.contains('null')) {
      logger.log("HEADERS: {}", name: 'API');
    } else {
      logger.log("HEADERS: ", name: 'API');
      formattedHeaders
          .split('\n')
          .forEach((dynamic element) => logger.log("$element", name: 'API'));
    }

    if (formattedBody == null || formattedBody.contains('null')) {
      logger.log("BODY: {}", name: 'API');
    } else {
      logger.log("BODY: ", name: 'API');
      formattedBody
          .split('\n')
          .forEach((dynamic element) => logger.log("$element", name: 'API'));
    }

    logger.log(
        "----------------------------------------------------------------- \n",
        name: 'API');
  }

  static void showNetworkErrorDialog(BuildContext context,
      {String title = "Network Exception", Object err = ''}) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unexpected Exception"),
          content: SingleChildScrollView(child: Text(err.toString())),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Center(child: Text("Okay")))
          ],
        );
      },
    );
  }
}
