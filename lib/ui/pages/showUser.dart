
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase/business_logic/models/user.dart';
import 'package:firbase/business_logic/view_models/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUser extends StatefulWidget {
  String documentId;

  ShowUser({this.documentId});
  @override
  _ShowUserState createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  var myKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Store_ViewModel store_viewModel = Provider.of<Store_ViewModel>(context);
    return Scaffold(
      key: myKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Show'),
      ),
      body: FutureBuilder(
        future: store_viewModel.getUser(widget.documentId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text(snapshot.error),);
          }else{
            return _view(context, snapshot.data);
          }
        },
      ),
    );
  }

  Widget _view(context, DocumentSnapshot snapshot){
    User user = User.fromSnapshot(snapshot);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 60.0,
              child: CircleAvatar(
                radius: 58.0,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: user.imgUrl != null ?
                          NetworkImage(user.imgUrl) :
                          AssetImage('assets/images/profile.png'),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 25,),
            Text(user.name),
            SizedBox(height: 15,),
            Text(user.age.toString()),
            SizedBox(height: 15,),
            Text(user.city),
          ],
        ),
      ),
    );
  }

}

