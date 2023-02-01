// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TXN _$TXNFromJson(Map json) => $checkedCreate(
      'TXN',
      json,
      ($checkedConvert) {
        final val = TXN();
        $checkedConvert('value', (v) => val.value = (v as num?)?.toDouble());
        $checkedConvert('time', (v) => val.time = v as int?);
        $checkedConvert('note', (v) => val.note = v as String?);
        return val;
      },
    );

Map<String, dynamic> _$TXNToJson(TXN instance) => <String, dynamic>{
      'value': instance.value,
      'time': instance.time,
      'note': instance.note,
    };
