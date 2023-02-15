import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dialoger/dialoger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_ledger/main.dart';
import 'package:local_ledger/model/person.dart';
import 'package:local_ledger/model/txn.dart';
import 'package:padded/padded.dart';

class PersonScreen extends StatelessWidget {
  final Person person;

  const PersonScreen({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<Person>(
        stream:
            ledgerService.stream().map((event) => event.getPeople().firstWhere(
                  (element) => element.name == person.name,
                )),
        builder: (context, snap) => snap.hasData
            ? Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(snap.data!.name ?? "Anonymous"),
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1),
                        child: PaddingBottom(
                          padding: 9,
                          child: Text(
                            formatMoney(snap.data!.calculateBalance()),
                          ),
                        ))),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const AddTransactionCard())
                      .then((value) {
                    if (value is TXN) {
                      ledgerService
                          .patch(() => snap.data!.addTransaction(value));
                    }
                  }),
                  child: const Icon(Icons.add),
                ),
                body: ListView.builder(
                  reverse: true,
                  itemCount: snap.data!.getTransactions().length,
                  itemBuilder: (context, index) => TransactionTile(
                      person: snap.data!,
                      transaction: snap.data!.getTransactions()[index]),
                ),
              )
            : const Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              )),
      );
}

class TransactionTile extends StatelessWidget {
  final TXN transaction;
  final Person? person;

  const TransactionTile({Key? key, this.person, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(transaction.note ??
            (transaction.isBorrow() ? "Borrowed Money" : "Payment")),
        onLongPress: person != null
            ? () => dialogConfirm(
                context: context,
                title: "Reverse Transaction?",
                description: "This will be added to the ledger",
                descriptionWidget: TransactionTile(
                    transaction: TXN()
                      ..note =
                          "Reversal of ${transaction.note ?? "Transaction"}"
                      ..value = -(transaction.value ?? 0.0)
                      ..time = DateTime.now().millisecondsSinceEpoch),
                confirmButtonText: "Confirm",
                onConfirm: (_) =>
                    ledgerService.patch(() => person!.addTransaction(TXN()
                      ..note =
                          "Reversal of ${transaction.note ?? "Transaction"}"
                      ..value = -(transaction.value ?? 0.0)
                      ..time = DateTime.now().millisecondsSinceEpoch)))
            : null,
        leading: Icon(
            transaction.isBorrow()
                ? Icons.attach_money_rounded
                : Icons.account_balance_wallet_rounded,
            color: transaction.isBorrow() ? Colors.red : Colors.green),
        trailing: person != null
            ? Text(DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(transaction.time ?? 0)))
            : null,
        subtitle: Text(formatMoney(transaction.value ?? 0)),
      );
}

class AddTransactionCard extends StatefulWidget {
  const AddTransactionCard({Key? key}) : super(key: key);

  @override
  State<AddTransactionCard> createState() => _AddTransactionCardState();
}

class _AddTransactionCardState extends State<AddTransactionCard> {
  bool borrow = true;
  TextEditingController td = TextEditingController();
  TextEditingController tv = TextEditingController(text: "\$0.00");
  FocusNode tvFocus = FocusNode();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Add Transaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
                value: borrow,
                onChanged: (v) => setState(() => borrow = v),
                title: Text(borrow ? "Borrow" : "Payback")),
            if (borrow)
              TextField(
                autofocus: true,
                onSubmitted: (f) => tvFocus.requestFocus(),
                keyboardType: TextInputType.text,
                controller: td,
                maxLines: 1,
                minLines: 1,
                maxLength: 56,
                decoration:
                    const InputDecoration(hintText: "What is this for?"),
              ),
            TextField(
                focusNode: tvFocus,
                onSubmitted: (f) => submit(context),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                controller: tv,
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    enableNegative: false,
                    symbol: "\$",
                    decimalDigits: 2,
                  )
                ],
                maxLines: 1,
                minLines: 1,
                decoration: const InputDecoration(hintText: "How much?")),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
              child: const Text(
                "Done",
              ),
              onPressed: () => submit(context)),
        ],
      );

  double parse(String t) =>
      (borrow ? 1.0 : -1.0) *
      (double.tryParse(tv.text) ??
          double.tryParse(tv.text.substring(1)) ??
          double.tryParse(tv.text.replaceAll(",", "")) ??
          double.tryParse(tv.text.substring(1).replaceAll(",", "")) ??
          0.00);

  void submit(BuildContext context) {
    Navigator.pop(
        context,
        TXN()
          ..note = borrow ? td.text : "Payoff"
          ..value = parse(tv.text)
          ..time = DateTime.now().millisecondsSinceEpoch);
  }
}
