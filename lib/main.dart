
import 'package:firbase/pages/home.dart';
import 'package:firbase/pages/login.dart';
import 'package:firbase/provider/auth_provider.dart';
import 'package:firbase/provider/store_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // for firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoreProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _view(context),
    );
  }

  Widget _view(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.authStatus) {
      case AuthStatus.authenticating:
      case AuthStatus.authenticated:
        return Home();
      case AuthStatus.unAuthenticated:
        return Login();
    }
    return Container();
  }
}
