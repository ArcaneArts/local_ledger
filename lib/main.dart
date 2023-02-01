import 'dart:async';

import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:local_ledger/screen/home_screen.dart';
import 'package:local_ledger/service/ledger_service.dart';
import 'package:local_ledger/util/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late Box box;

void main() =>
    runZonedGuarded(() => initialize().then((_) => runApp(const LocalLedger())),
        (e, es) {
      error("Uncaught error: $e");
      error("Stack trace: $es");
    });

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    initStorage().then((value) => box = value),
  ]);
}

Future<Box> initStorage() async {
  if (!kIsWeb) {
    String path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    success("Initialized Non-Web Hive storage location: $path");
  }

  return hive("main").then((value) {
    return value;
  });
}

LedgerService get ledgerService => ctx().read<LedgerService>();

class LocalLedger extends StatelessWidget {
  const LocalLedger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            Provider<LedgerService>(
                create: (_) => LedgerService()..bind(), lazy: true),
          ],
          child: GetMaterialApp(
            themeMode: ThemeMode.system,
            darkTheme: ThemeData.dark(),
            theme: ThemeData.light(),
            initialRoute: "/",
            getPages: [
              GetPage(name: "/", page: () => const HomeScreen()),
            ],
          ));
}

BuildContext? tempContext;
BuildContext ctx() => (Get.context ?? tempContext)!;
final _monies = NumberFormat("#,##0.00", "en_US");
String formatMoney(double amount) => "\$${_monies.format(amount)}";
