/*
 * Copyright (c) 2022-2023. MyGuide
 *
 * MyGuide is a closed source project developed by Arcane Arts.
 * Do not copy, share, distribute or otherwise allow this source file
 * to leave hardware approved by Arcane Arts unless otherwise
 * approved by Arcane Arts.
 */

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'txn.g.dart';

@JsonSerializable()
class TXN with EquatableMixin {
  double? value;
  int? time;
  String? note;

  bool isBorrow() => (value ?? 0.0) > 0;

  bool isValid() => value != null && time != null && value != 0.0;

  TXN();

  @override
  List<Object?> get props => [value, time, note];

  factory TXN.fromJson(Map<String, dynamic> json) => _$TXNFromJson(json);

  Map<String, dynamic> toJson() => _$TXNToJson(this);
}
