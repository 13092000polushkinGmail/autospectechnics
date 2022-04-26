import 'package:autospectechnics/back4app.dart';
import 'package:autospectechnics/ui/app/my_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Back4App.initParse();
  const app = MyApp();
  runApp(app);
}


