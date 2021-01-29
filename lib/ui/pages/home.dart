
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase/business_logic/models/user.dart';
import 'package:firbase/business_logic/view_models/auth_viewmodel.dart';
import 'package:firbase/business_logic/view_models/store_viewmodel.dart';
import 'package:firbase/ui/pages/login.dart';
import 'package:firbase/ui/pages/showUser.dart';
import 'package:firbase/ui/pages/updateUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth_ViewModel auth_viewModel = Provider.of<Auth_ViewModel>(context);
    Store_ViewModel store_viewModel = Provider.of<Store_ViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth_viewModel.log_out();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return Login();
                },
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: store_viewModel.getAllUsers(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return LinearProgressIndicator();
          }else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }else{
            return _buildList(context, snapshot.data.docs);
          }
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          User user = User.fromSnapshot(snapshot[index]);
          return ListTile(
             title: Text(user.name + ' - ' + user.age.toString()),
            subtitle: Text(user.city),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return UpdateUser(user: user,);
                },));
              },
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ShowUser(documentId: user.id,);
            },)),
          );
        },);
  }
}
