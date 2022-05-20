import 'package:hive/hive.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  BoxManager._();

  Future<Box<T>> openBox<T>({
    required String name,
    required int typeId,
    required TypeAdapter<T> adapter,
  }) async {
    //TODO Hive видимо создает box при этом делает имя в lowerCase, потому что до открытия box с помощью функции Hive.openBox имя доходит как пришло
    //с цифрами и разным регистром букв, добавляется в словарь с нормальным регистром, но потом при вызове функции closeBox он ищет в словаре ключ-имя коробки в lowerCase
    name = name.toLowerCase();
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return await Hive.openBox<T>(name);
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;

    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }
}
