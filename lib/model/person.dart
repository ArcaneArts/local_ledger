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
import 'package:local_ledger/model/rollup.dart';
import 'package:local_ledger/model/txn.dart';

part 'person.g.dart';

@JsonSerializable()
class Person with EquatableMixin {
  String? name;
  int? id;
  List<TXN>? transactions;
  List<Rollup>? rollups;

  Person();

  List<TXN> getTransactions() {
    transactions ??= [];
    return transactions!;
  }

  List<Rollup> getRollups() {
    rollups ??= [];
    return rollups!;
  }

  void addTransaction(TXN txn) {
    getTransactions().add(txn);
    optimize();
  }

  int countTransactions() =>
      getTransactions().length +
      getRollups().fold(0, (a, b) => a + (b.transactions?.length ?? 0));

  double calculateBalance() =>
      getTransactions().fold(0.0, (a, b) => a + (b.value ?? 0)) +
      getRollups().fold(0.0, (a, b) => a + (b.value ?? 0));

  void optimize() {
    getTransactions().removeWhere((element) => !element.isValid());
    while (getTransactions().length > 100) {
      List<TXN> roll = getTransactions().take(100).toList();
      getTransactions().removeRange(0, 100);
      getRollups().add(Rollup()
        ..transactions = roll
        ..value = roll.fold(0, (a, b) => (a ?? 0) + (b.value ?? 0)));
    }
  }

  Iterable<TXN> iterateTransactions() sync* {
    if (transactions != null) {
      yield* transactions!;
    }

    if (rollups != null) {
      for (Rollup rollup in rollups!) {
        if (rollup.transactions != null) {
          yield* rollup.transactions!;
        }
      }
    }
  }

  @override
  List<Object?> get props => [name, transactions, rollups];

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
