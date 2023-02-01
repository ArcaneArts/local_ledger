// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map json) => $checkedCreate(
      'Data',
      json,
      ($checkedConvert) {
        final val = Data();
        $checkedConvert(
            'people',
            (v) => val.people = (v as List<dynamic>?)
                ?.map(
                    (e) => Person.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList());
        return val;
      },
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'people': instance.people?.map((e) => e.toJson()).toList(),
    };
