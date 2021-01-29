
import 'package:firbase/business_logic/models/user.dart';
import 'package:firbase/business_logic/view_models/store_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUser extends StatefulWidget {
  User user;

  UpdateUser({this.user});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController nameCont = TextEditingController();
  String sname;
  TextEditingController ageCont = TextEditingController();
  int iage;
  TextEditingController cityCont = TextEditingController();
  String scity;

  var myKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    sname =  widget.user.name;
    nameCont.text = sname;
    iage = widget.user.age;
    ageCont.text = iage.toString();
    scity = widget.user.city;
    cityCont.text = scity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update User'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameCont,
              decoration: InputDecoration(labelText: 'name'),
              onChanged: (value) {
                setState(() {
                  sname = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: ageCont,
              decoration: InputDecoration(labelText: 'age'),
              onChanged: (value) {
                setState(() {
                  iage = int.parse(value);
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: cityCont,
              decoration: InputDecoration(labelText: 'city'),
              onChanged: (value) {
                setState(() {
                  scity = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            _Action(context),
          ],
        ),
      ),
    );
  }

  Widget _Action(BuildContext context) {
    Store_ViewModel provider = Provider.of<Store_ViewModel>(context);
    User _user = User(
        id: widget.user.id,
        name: sname,
        age: iage,
        city: scity
    );
    return RaisedButton(
      child: provider.updateStatus == UpdateStatus.Loading?
          CircularProgressIndicator(): Text('SAVE'),
      onPressed: () async{
        await provider.updateUser(_user).then((bool value) {
          if (value) {
            myKey.currentState..removeCurrentSnackBar()..showSnackBar(
                SnackBar(content: Text('User is updated successfully')));
          } else {
            myKey.currentState..removeCurrentSnackBar()..
                showSnackBar(SnackBar(content: Text(provider.errorMessage)));
          }
        });
      },
    );
  }
}
