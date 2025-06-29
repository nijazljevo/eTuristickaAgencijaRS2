import 'dart:convert';
import 'dart:typed_data';
import 'package:eturistickaagencija_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/search_result.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7073/");
  }
  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      print("url: $url");
      print("headers: $headers");
      var response = await http.get(uri, headers: headers);
    } catch (e) {
      print("Error printing URL or headers: $e");
    }
    var response = await http.get(uri, headers: headers);
    print(
        "response: ${response.request} ${response.statusCode} ${response.body}");
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<T>();
      // result.count=data['count'];
      for (var item in data) {
        result.result.add(fromJson(item));
      }
      return result;
    } else {
      // ignore: unnecessary_new
      throw new Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    // Dodajte provjeru je li request null prije slanja
    var jsonRequest = request != null ? jsonEncode(request) : null;

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      // ignore: unnecessary_new
      throw Exception("Unknown error");
    }
  }

  Future<T> insertMultipart({
    required Map<String, String> fields,
    Map<String, Uint8List>? fileBytes, // key: field name, value: file bytes
    Map<String, String>? fileNames, // key: field name, value: file name
  }) async {
    var url = "$_baseUrl$_endpoint/form";
    var uri = Uri.parse(url);

    var request = http.MultipartRequest('POST', uri);

    // Add headers except Content-Type (it will be set automatically)
    var headers = createHeaders();
    headers.remove("Content-Type");
    request.headers.addAll(headers);

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files from bytes
    if (fileBytes != null) {
      for (var entry in fileBytes.entries) {
        final fileName =
            fileNames != null ? fileNames[entry.key] ?? 'file.jpg' : 'file.jpg';

        final httpImage = http.MultipartFile.fromBytes(
          entry.key, // <-- use the actual field name
          entry.value,
          filename: fileName,
        );
        request.files.add(httpImage);
      }
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      }
    } catch (e) {
      print("Error in multipart request: $e");
      throw Exception("Error in multipart request: $e");
    }
    throw Exception("Unknown error in insertMultipart");
  }

  Future<T> updateMultipart({
    required Map<String, String> fields,
    Map<String, Uint8List>? fileBytes, // key: field name, value: file bytes
    Map<String, String>? fileNames, // key: field name, value: file name
  }) async {
    var url = "$_baseUrl$_endpoint/form";
    var uri = Uri.parse(url);

    var request = http.MultipartRequest('PUT', uri);

    // Add headers except Content-Type (it will be set automatically)
    var headers = createHeaders();
    headers.remove("Content-Type");
    request.headers.addAll(headers);

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files from bytes
    if (fileBytes != null) {
      for (var entry in fileBytes.entries) {
        final fileName =
            fileNames != null ? fileNames[entry.key] ?? 'file.jpg' : 'file.jpg';

        final httpImage = http.MultipartFile.fromBytes(
          entry.key, // <-- use the actual field name
          entry.value,
          filename: fileName,
        );
        request.files.add(httpImage);
      }
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      }
    } catch (e) {
      print("Error in multipart request: $e");
      throw Exception("Error in multipart request: $e");
    }
    throw Exception("Unknown error in updateMultipart");
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      // ignore: unnecessary_new
      throw new Exception("Unknown error");
    }
  }

  Future<void> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
    } else {
      // ignore: unnecessary_new
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }
    return false;
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    print("passed creds: $username, $password");

    String baseAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": baseAuth
    };
    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
