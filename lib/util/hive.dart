import 'package:fast_log/fast_log.dart';
import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';

Box hiveNow(String box) => Hive.box("mg$box");

Lock _lock = Lock();

Future<Box> hive(String box) async {
  if (Hive.isBoxOpen("mg$box")) {
    return Hive.box("mg$box");
  }

  return Hive.openBox("mg$box").then((value) {
    success(
        "Initialized Hive Box ${value.name} with ${value.keys.length} keys");
    return value;
  });
}

Future<LazyBox> hiveLazy(String box) => _lock.synchronized(() async {
      if (Hive.isBoxOpen("mg$box")) {
        return Hive.lazyBox("mg$box");
      }

      return Hive.openLazyBox("mg$box").then((value) {
        success(
            "Initialized Lazy Hive Box ${value.name} with ${value.keys.length} keys");
        return value;
      });
    });
