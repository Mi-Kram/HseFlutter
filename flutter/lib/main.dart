import 'package:catotinder/src/di/app_dependencies.dart';
import 'package:catotinder/src/presentation/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  AppDependencies di = AppDependencies.fromEnvEnvironment();

  runApp(
    AppWidget(
      catService: di.catService,
      catDataManager: di.catDataManager,
      breedDataManager: di.breedDataManager,
      authService: di.authService,
    ),
  );
}
