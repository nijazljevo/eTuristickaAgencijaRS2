// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['id'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['korisnikoIme'] as String?,
      json['slika'] as String?,
      json['email'] as String?,
      json['password'] as String?,
      json['passwordPotvrda'] as String?,
      json['ulogaId'] as int?,
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'korisnikoIme': instance.korisnikoIme,
      'slika': instance.slika,
      'email': instance.email,
      'password': instance.password,
      'passwordPotvrda': instance.passwordPotvrda,
      'ulogaId': instance.ulogaId,
    };
