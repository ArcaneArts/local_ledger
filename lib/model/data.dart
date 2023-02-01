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
import 'package:local_ledger/model/person.dart';

part 'data.g.dart';

@JsonSerializable()
class Data with EquatableMixin {
  List<Person>? people;
  int? lid;

  Data();

  List<Person> getPeople() {
    people ??= [];
    return people!;
  }

  void addPerson(Person person) => getPeople().add(person..id = getNextId());

  int getNextId() {
    lid ??= 0;
    int id = lid!;
    lid = lid! + 1;
    return id;
  }

  @override
  List<Object?> get props => [people];

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  void removePerson(Person person) {
    getPeople().removeWhere((element) => element.id == person.id);
  }
}
