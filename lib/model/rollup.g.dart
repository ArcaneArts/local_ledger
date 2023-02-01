// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rollup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rollup _$RollupFromJson(Map json) => $checkedCreate(
      'Rollup',
      json,
      ($checkedConvert) {
        final val = Rollup();
        $checkedConvert('value', (v) => val.value = (v as num?)?.toDouble());
        $checkedConvert(
            'transactions',
            (v) => val.transactions = (v as List<dynamic>?)
                ?.map((e) => TXN.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList());
        return val;
      },
    );

Map<String, dynamic> _$RollupToJson(Rollup instance) => <String, dynamic>{
      'value': instance.value,
      'transactions': instance.transactions?.map((e) => e.toJson()).toList(),
    };
