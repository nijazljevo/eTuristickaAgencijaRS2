// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hotel _$HotelFromJson(Map<String, dynamic> json) => Hotel(
      json['id'] as int?,
      json['naziv'] as String?,
      json['brojZvjezdica'] as int?,
      json['slika'] as String?,
      json['gradId'] as int?,
    );

Map<String, dynamic> _$HotelToJson(Hotel instance) => <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'brojZvjezdica': instance.brojZvjezdica,
      'slika': instance.slika,
      'gradId': instance.gradId,
    };
