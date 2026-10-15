import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await init();

  runApp(
    ChangeNotifierProvider<AuthProvider>(
      create: (_) =>sl<AuthProvider>(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartBus Kerala',
      home: const LoginPage(),
        // Scaffold(
        //   body: Center(
        //     child: Text("SmartBus Kerala"),
        //   ),
        // ),
    );
  }
}