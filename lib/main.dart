import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe/src/screen/game_screen.dart';
import 'package:tictactoe/theme.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TicTacToe Demo');
    setWindowMinSize(const Size(360, 740));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const GameScreen());
  }
}
