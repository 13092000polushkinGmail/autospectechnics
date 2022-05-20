import 'package:autospectechnics/back4app.dart';
import 'package:autospectechnics/ui/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Back4App.initParse();
  await Hive.initFlutter();
  const app = MyApp();
  runApp(app);
}


