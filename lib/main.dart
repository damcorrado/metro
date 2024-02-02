import 'package:flutter/material.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/routes.dart';
import 'package:metro/theme/theme.dart';
import 'package:provider/provider.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MetroProvider>(create: (context) => MetroProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
      title: 'metro',
      theme: getTheme(darkMode: true),
      initialRoute: Routes.ROUTE_BOOTSTRAP,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
