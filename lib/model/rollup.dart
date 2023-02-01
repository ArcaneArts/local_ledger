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
import 'package:local_ledger/model/txn.dart';

part 'rollup.g.dart';

@JsonSerializable()
class Rollup with EquatableMixin {
  double? value;
  List<TXN>? transactions;

  Rollup();

  Iterable<TXN> iterateTransactions() sync* {
    if (transactions != null) {
      yield* transactions!;
    }
  }

  @override
  List<Object?> get props => [value, transactions];

  factory Rollup.fromJson(Map<String, dynamic> json) => _$RollupFromJson(json);

  Map<String, dynamic> toJson() => _$RollupToJson(this);
}
