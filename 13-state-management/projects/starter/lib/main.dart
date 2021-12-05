// ignore_for_file: prefer_relative_imports

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recipes/data/moor/moor_repository.dart';
import 'package:recipes/data/repository.dart';
import 'package:recipes/data/sqlite/bookmarks.dart';
import 'package:recipes/network/service_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'network/mock_service.dart';

import 'ui/main_screen.dart';

typedef Json = Map<String, dynamic>;

Future<void> main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  //Sqflite.setDebugModeOn(kDebugMode);
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MyApp(repo: MoorRepository()..init()));
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required Repository this.repo,
  })  : bookmarks = Bookmarks(repo),
        super(key: key);

  final Repository repo;
  final Bookmarks bookmarks;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => repo,
          dispose: (_, repo) => repo.close(),
          lazy: false,
        ),
        Provider<ApiService>(
          create: (_) => MockService()..create(),
          lazy: false,
        ),
        Provider<Bookmarks>(
          create: (_) => bookmarks,
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'Recipes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
