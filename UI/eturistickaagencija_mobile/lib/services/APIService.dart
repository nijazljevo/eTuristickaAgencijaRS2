import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/destinacija.dart';
import '../model/hotel.dart';
import '../model/korisnik.dart';
import '../model/ocjena.dart';
import '../model/rezervacija.dart';
import 'package:intl/intl.dart';


class APIService {
  static String? username;
  static String? password;
  static int? korisnikId;
  static const String baseRoute = "http://10.0.2.2:7073/";
  String? route;

  APIService({this.route});

  static Future<Korisnik?> prijava() async {
    // ignore: prefer_interpolation_to_compose_strings
    String baseUrl = baseRoute + "Korisnici/";

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
        

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData is List) {
        if (responseData.isNotEmpty) {
          for (var korisnikData in responseData) {
            if (korisnikData['korisnikoIme'] == username  ) {
              return Korisnik.fromJson(korisnikData);
            }
          }
        }
      }
    }

    return null;
  }

  static Future<Korisnik?> fetchKorisnik(int id) async {
    // ignore: prefer_interpolation_to_compose_strings
    String baseUrl = baseRoute + "Korisnici/" + id.toString();

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );

    if (response.statusCode == 200) {
      return Korisnik.fromJson(json.decode(response.body));
    }

    return null;
  }

  // ignore: non_constant_identifier_names
  static Future<dynamic> GetById(String route, int id) async {
    // ignore: prefer_interpolation_to_compose_strings
    String baseUrl = baseRoute + route + "/" + id.toString();

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return null;
  }

  static Future<List<dynamic>?> get(String route, dynamic object) async {
    String queryString;
    String baseUrl = baseRoute + route;

    if (object != null) {
      if (object is int) {
        // ignore: prefer_interpolation_to_compose_strings
        baseUrl = baseUrl + '/' + object.toString();
      } else {
        queryString = Uri(queryParameters: object).query;
        // ignore: prefer_interpolation_to_compose_strings
        baseUrl = baseUrl + '?' + queryString;
      }
    }

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(Uri.parse(baseUrl),
        headers: {HttpHeaders.authorizationHeader: basicAuth});
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('Status code [GET] -> ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    }
    return null;
  }
  static Future<List<dynamic>?> getPreporuceno(String route, dynamic object) async {
  String queryString;
  String baseUrl = baseRoute + route;

  if (object != null) {
    if (object is int) {
      // ignore: prefer_interpolation_to_compose_strings
      baseUrl = baseUrl + '/' + object.toString();
    } else {
      queryString = Uri(queryParameters: object).query;
      // ignore: prefer_interpolation_to_compose_strings
      baseUrl = baseUrl + '?' + queryString;
    }
  }

  final String basicAuth =
      // ignore: prefer_interpolation_to_compose_strings
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  final response = await http.get(Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: basicAuth});
  // ignore: prefer_interpolation_to_compose_strings, avoid_print
  print('Status code [GET] -> ' + response.statusCode.toString());
  if (response.statusCode == 200) {
    return json.decode(response.body) as List<dynamic>?; 
  }
  return null;
}


  static Future<dynamic> post(String route, String body) async {
    String baseUrl = baseRoute + route;

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: basicAuth
      },
      body: body,
    );

    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('Status code [POST] -> ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }

  static Future<dynamic> put(String route, int id, String body) async {
    // ignore: prefer_interpolation_to_compose_strings
    String baseUrl = baseRoute + route + "/" + id.toString();

    final String basicAuth =
        // ignore: prefer_interpolation_to_compose_strings
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: basicAuth
      },
      body: body,
    );

    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('Status code [PUT] -> ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      return json.decode(response.body.toString());
    } else {
      return null;
    }
  }
  
   static Future<bool> updateKorisnik(int id, Korisnik updatedKorisnik) async {
  // ignore: prefer_interpolation_to_compose_strings
  String baseUrl = baseRoute + "Korisnici/" + id.toString();

  final String basicAuth =
      // ignore: prefer_interpolation_to_compose_strings
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  final response = await http.put(
    Uri.parse(baseUrl),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: basicAuth
    },
    body: json.encode(updatedKorisnik.toJson()),
  );

  if (response.statusCode == 200) {
    return true;
  }

  return false;
}

static Future<List<Hotel>?> getHoteli() async {
  final List<dynamic>? responseData = await get('Hoteli', null);
  if (responseData != null) {
    return responseData.map((data) => Hotel.fromJson(data)).toList();
  }
  return null;
}
static Future<List<Ocjena>?> getOcjene() async {
  final responseData = await get('Ocjene', null); 
  if (responseData != null) {
    List<Ocjena> ocjene = responseData.map((data) => Ocjena.fromJson(data)).toList();
    return ocjene;
  }
  return null;
  
}
static Future<List<Rezervacije>?> getReservationsForUserAndDate(int userId, DateTime date) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final queryParams = {
    'korisnikId': userId.toString(),
    'datumRezervacije': formattedDate,
  };
  final List<dynamic>? responseData = await get('Rezervacija', queryParams);
  if (responseData != null) {
    List<Rezervacije> rezervacije = responseData.map((data) => Rezervacije.fromJson(data)).toList();
    return rezervacije;
  }
  return null;
}





static Future<Destinacija?> getDestinacija(int? destinacijaId) async {
  final responseData = await GetById('Destinacije', destinacijaId!); 
  if (responseData != null) {
    return Destinacija.fromJson(responseData);
  }
  return null;
}


}
