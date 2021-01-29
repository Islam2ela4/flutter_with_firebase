
import 'package:firbase/business_logic/view_models/auth_viewmodel.dart';
import 'package:firbase/business_logic/view_models/store_viewmodel.dart';
import 'package:firbase/ui/pages/home.dart';
import 'package:firbase/ui/pages/login.dart';
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
          create: (context) => Auth_ViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => Store_ViewModel(),
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
    var auth_viewmodel = Provider.of<Auth_ViewModel>(context);
    switch (auth_viewmodel.authStatus) {
      case AuthStatus.authenticating:
      case AuthStatus.authenticated:
        return Home();
      case AuthStatus.unAuthenticated:
        return Login();
    }
    return Container();
  }
}
