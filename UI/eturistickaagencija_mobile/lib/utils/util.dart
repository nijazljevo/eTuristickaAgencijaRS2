import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class Authorization {
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64Image){
  return Image.memory(base64Decode(base64Image));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  
  return f.format(dynamic);
}