
import 'package:firbase/business_logic/view_models/auth_viewmodel.dart';
import 'package:firbase/ui/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  var loginKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Auth_ViewModel>(context);
    return Scaffold(
      key: loginKey,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'email',
                ),
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: prov.authStatus == AuthStatus.authenticating
                      ? CircularProgressIndicator()
                      : Text('Login'),
                  onPressed: () async {
                    if (!await prov.login(emailController.text.toString(),
                        passController.text.toString())) {
                      loginKey.currentState
                          .showSnackBar(SnackBar(content: Text(prov.message)));
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }
                  }),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Register();
                    },
                  ));
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

