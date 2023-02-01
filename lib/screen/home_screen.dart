import 'dart:convert';

import 'package:dialoger/dialoger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_compress/json_compress.dart';
import 'package:local_ledger/main.dart';
import 'package:local_ledger/model/data.dart';
import 'package:local_ledger/model/person.dart';
import 'package:local_ledger/screen/person_screen.dart';
import 'package:snackbar/snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => StreamBuilder<Data>(
        stream: ledgerService.stream(),
        builder: (context, snap) => snap.hasData
            ? Scaffold(
                appBar: AppBar(
                  title: Text(formatMoney(snap.data!
                      .getPeople()
                      .fold(0, (a, b) => a + b.calculateBalance()))),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.upload_rounded),
                      onPressed: () => Clipboard.setData(ClipboardData(
                              text: jsonEncode(compressJson(snap.data!.toJson(),
                                  forceEncode: true))))
                          .then(
                              (value) => snack("Copied App Data to Clipboard")),
                    ),
                    IconButton(
                        icon: const Icon(Icons.download_rounded),
                        onPressed: () => dialogConfirm(
                            context: context,
                            title: "Import Data from Clipboard?",
                            description:
                                "This will overwrite your current data!",
                            confirmButtonText: "Import from Clipboard",
                            onConfirm: (_) {
                              Clipboard.getData(Clipboard.kTextPlain)
                                  .then((value) {
                                if (value != null) {
                                  try {
                                    ledgerService.load(value.text!);
                                  } catch (e) {
                                    snack("Invalid App Data");
                                  }
                                }
                              });
                            })),
                  ],
                ),
                body: ListView.builder(
                  itemCount: snap.data!.getPeople().length,
                  itemBuilder: (context, index) =>
                      PersonTile(person: snap.data!.getPeople()[index]),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => dialogText(
                      context: context,
                      title: "Add Person",
                      submitButtonText: "Done",
                      onSubmit: (_, name) => ledgerService.patch(() {
                            Person p = Person()..name = name;
                            snap.data!.addPerson(p);
                            Future.delayed(const Duration(milliseconds: 250),
                                () => Get.to(() => PersonScreen(person: p)));
                          })),
                  child: const Icon(Icons.add),
                ),
              )
            : const Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              )),
      );
}

class PersonTile extends StatelessWidget {
  final Person person;

  const PersonTile({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(person.name ?? "Anonymous"),
        onTap: () => Get.to(() => PersonScreen(person: person)),
        onLongPress: () => dialogConfirm(
            context: context,
            title: "Delete ${person.name}?",
            description: "Are you sure you want to delete this person?",
            confirmButtonText: "Delete",
            onConfirm: (_) => ledgerService.deletePerson(person)),
        subtitle: Text(formatMoney(person.calculateBalance())),
      );
}
