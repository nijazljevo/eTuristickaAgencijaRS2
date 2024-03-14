import 'dart:convert';

class Uplata {
  late int? korisnikId;
  final double iznos;
  final String brojTransakcije;
  final DateTime datumTransakcije;

  Uplata(
      {this.korisnikId,
      required this.iznos,
      required this.brojTransakcije,
      required this.datumTransakcije});

  Map<String, dynamic> toJson() => {
        "korisnikId": korisnikId,
        "iznos": iznos,
        "brojTransakcije": brojTransakcije,
        "datumTransakcije": datumTransakcije.toString(),
      };
}