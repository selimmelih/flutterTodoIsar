import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app2/screens/home_screen.dart';
import 'package:todo_app2/services/database_service.dart';

void main() async {
  // flutterı hazırlar
  WidgetsFlutterBinding.ensureInitialized();

  // veritabanını başlatıyoruz.
  await DatabaseService.initialize();

  // Widgetleri cizdiren fonnks bu alttaki.
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DatabaseService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      locale: const Locale('tr'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
