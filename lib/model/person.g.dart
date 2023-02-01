// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map json) => $checkedCreate(
      'Person',
      json,
      ($checkedConvert) {
        final val = Person();
        $checkedConvert('name', (v) => val.name = v as String?);
        $checkedConvert(
            'transactions',
            (v) => val.transactions = (v as List<dynamic>?)
                ?.map((e) => TXN.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList());
        $checkedConvert(
            'rollups',
            (v) => val.rollups = (v as List<dynamic>?)
                ?.map(
                    (e) => Rollup.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList());
        return val;
      },
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'name': instance.name,
      'transactions': instance.transactions?.map((e) => e.toJson()).toList(),
      'rollups': instance.rollups?.map((e) => e.toJson()).toList(),
    };
