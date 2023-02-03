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
  Future<Response> send(
    RequestType requestType,
    String path, {
    String? authToken,
    Object? body,
  }) async {
    Future<http.Response>? future;
    final Uri uri = Uri.https(host, "/api/$path");

    final Map<String, String> headers = {
      'x-functions-key': functionKey,
      'Authorization': authToken ?? "",
      'Content-Type': 'application/json'
    };

    if (requestType == RequestType.post) {
      future = http.post(uri, body: body, headers: headers);
    } else if (requestType == RequestType.get) {
      future = http.get(uri, headers: headers);
    } else if (requestType == RequestType.patch) {
      future = http.patch(uri, body: body, headers: headers);
    } else if (requestType == RequestType.put) {
      future = http.put(uri, body: body, headers: headers);
    } else if (requestType == RequestType.delete) {
      future = http.delete(uri, body: body, headers: headers);
    }

    final response = await future!
        .timeout(const Duration(seconds: 20)) // Default of 15s timeout
        .onError((error, stackTrace) {
      print("$error, stacktrace: $stackTrace");
      throw Exception("$error, stacktrace: $stackTrace");
    });

    return _getResponse(response);
  }

  Future<Response> get(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(RequestType.get, path, body: body, authToken: authToken);
  }

  Future<Response> post(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(RequestType.post, path, body: body, authToken: authToken);
  }

  Future<Response> put(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(RequestType.put, path, body: body, authToken: authToken);
  }

  Future<Response> patch(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(RequestType.patch, path, body: body, authToken: authToken);
  }

  Future<Response> delete(
    String path, {
    String? authToken,
    Map<String, String>? headers,
    Object? body,
  }) {
    return send(RequestType.delete, path, body: body, authToken: authToken);
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

  static void showErrorDialog(BuildContext context, Object err) {
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
