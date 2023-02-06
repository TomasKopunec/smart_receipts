import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:smart_receipts/helpers/requests/http_exception.dart';
import 'package:smart_receipts/helpers/requests/response.dart';

enum RequestType { post, get, patch, put, delete }

class RequestHelper {
  final String host = "digitalreceipts.azurewebsites.net";
  final String functionKey =
      "nDDhMcGI64BL0foQDGp8t-9D9URyyi1mlvEHvpK2rn1tAzFuA86DDw==";

  /// Sends any type of request
  Future<Response> _send(
    RequestType requestType,
    String path, {
    String? authToken,
    Object? body,
  }) async {
    Future<http.Response>? future;
    // final Uri uri = Uri.https(host, "/api/$path");
    final Uri uri = Uri(scheme: 'https', host: host, path: '/api/$path');

    final Map<String, String> headers = {
      'x-functions-key': functionKey,
      'Authorization': authToken ?? "",
      'Content-Type': 'application/json'
    };

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

  /// Sends a request and logs
  Future<Response> send(String name, RequestType type, String path, Object body,
      {String? authToken}) async {
    log(name.toUpperCase(), body, true);
    final Response response =
        await _send(type, path, body: body, authToken: authToken);
    log(name.toUpperCase(), response, false);
    return response;
  }

  Future<Response> get(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.get, path, body: body, authToken: authToken);
  }

  Future<Response> post(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.post, path, body: body, authToken: authToken);
  }

  Future<Response> put(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.put, path, body: body, authToken: authToken);
  }

  Future<Response> patch(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(RequestType.patch, path, body: body, authToken: authToken);
  }

  Future<Response> delete(
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

  void log(String methodName, Object body, bool isRequest) {
    print("[API] $methodName ${isRequest ? 'request' : 'response'}: $body");
  }

  static void showErrorDialog(BuildContext context,
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
