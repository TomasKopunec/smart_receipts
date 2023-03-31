// ignore_for_file: avoid_print, empty_catches

import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_receipts/helpers/requests/response.dart';
import 'package:smart_receipts/utils/logger.dart';

enum RequestType { post, get, patch, put, delete }

class RequestHelper {
  final bool apiLoggingEnabled = true;

  final Logger logger = Logger(RequestHelper);

  final String host = "smartreceipts.azurewebsites.net";
  final String functionKey =
      "8eyGwo2N-0KVQVL6RcggvIs4E63fQRyC-9MN5DBr_TNDAzFuNtFr8g==";

  /// Sends a request and logs
  Future<Response> send({
    required RequestType type,
    required String path,
    Object? body,
    String? authToken,
  }) async {
    final Map<String, String> headers = {
      'x-functions-key': functionKey,
      'Authorization': authToken ?? "",
      'Content-Type': 'application/json'
    };

    _log(type, "/$path", headers, body, true);

    final Response response = await _send(type, path,
        body: body, headers: headers, authToken: authToken);

    _log(type, "/$path", response.headers, response.body, false,
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

    final response = await future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception("Connection timeout of 30s has been reached.");
      },
    ) // Default of 30s timeout
        .onError((err, stackTrace) {
      final str =
          'Exception occured while sending a request to the API! \n$err';
      print(str);
      return Future.value(http.Response("", 500, reasonPhrase: str));
    });

    return _getResponse(response);
  }

  Response _getResponse(http.Response httpResponse) {
    final Response response = Response(
      code: httpResponse.statusCode,
      headers: httpResponse.headers,
      body: httpResponse.body,
      exception: httpResponse.reasonPhrase,
    );

    return response;
  }

  void _log(
    RequestType type,
    String path,
    Object? headers,
    Object? body,
    bool isRequest, {
    int? statusCode,
    String? exception,
  }) {
    if (!apiLoggingEnabled) {
      return;
    }

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

    if (formattedBody == null && body is Map) {
      try {
        formattedBody = encoder.convert(body);
      } catch (e) {}
    }

    logger.log(
        "----------------------------------------------------------------- \n",
        name: 'API');

    logger.log(
        "${type.name.toUpperCase()} ${isRequest ? 'REQUEST' : 'RESPONSE'} $path",
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
  }

  static void showNetworkErrorDialog(BuildContext context,
      {String title = "Network Exception", Object? err}) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: err == null
              ? Container()
              : SingleChildScrollView(child: Text(err.toString())),
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
