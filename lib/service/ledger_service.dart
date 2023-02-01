import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_compress/json_compress.dart';
import 'package:local_ledger/main.dart';
import 'package:local_ledger/model/data.dart';
import 'package:local_ledger/model/person.dart';
import 'package:local_ledger/util/service.dart';

class LedgerService extends Service {
  late Data _data;
  late StreamController<Data> _dataStream;

  @override
  void bind() {
    _data = loadData();
    _dataStream = StreamController.broadcast(onListen: () {
      _dataStream.add(_data);
    });
  }

  void patch(VoidCallback callback) {
    callback();
    _dataStream.add(_data);
    saveData(_data);
  }

  Stream<Person> streamPerson(int id) => _dataStream.stream.map((event) => event
      .getPeople()
      .firstWhere((element) => element.id == id,
          orElse: () => Person()..name = "OH NO?"));

  Stream<Data> stream() {
    Stream<Data> s = _dataStream.stream;
    Future.delayed(
        const Duration(milliseconds: 5), () => _dataStream.add(_data));
    return s;
  }

  Data loadData() => Data.fromJson(
      decompressJson(jsonDecode(box.get("data", defaultValue: "{}"))));

  void saveData(Data data) => box.put(
      "data", jsonEncode(compressJson(data.toJson(), forceEncode: true)));

  void deletePerson(Person person) {
    patch(() {
      _data.removePerson(person);
    });
  }

  void load(String s) {
    _data = Data.fromJson(decompressJson(jsonDecode(s)));
    _dataStream.add(_data);
    saveData(_data);
  }
}
