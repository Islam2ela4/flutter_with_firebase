import 'dart:io';

import 'package:firbase/business_logic/models/user.dart';
import 'package:firbase/business_logic/view_models/auth_viewmodel.dart';
import 'package:firbase/business_logic/view_models/store_viewmodel.dart';
import 'package:firbase/ui/pages/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  var myKey = GlobalKey<ScaffoldState>();

  //
  File _image;
  final picker = ImagePicker();
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myKey,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: chooseFile,
                  child: CircleAvatar(
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
                              image: _image != null ?
                                    FileImage(_image)
                                    : AssetImage('assets/images/profile.png'),
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    labelText: 'name',
                  ),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    hintText: 'Enter your age',
                    labelText: 'age',
                  ),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter your city',
                    labelText: 'city',
                  ),
                ),
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
                _Action(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Action(BuildContext context){
    Auth_ViewModel auth_viewModel = Provider.of<Auth_ViewModel>(context);
    Store_ViewModel store_viewModel = Provider.of<Store_ViewModel>(context);
    return RaisedButton(
      child: auth_viewModel.authStatus == AuthStatus.authenticating
          ? CircularProgressIndicator()
          : Text('Register'),
      onPressed: () async {
        await auth_viewModel
            .registeration(
                email: emailController.text.toString(),
                password: passController.text.toString())
            .then((bool value) async {
          if (!value) {
            myKey.currentState
                .showSnackBar(SnackBar(content: Text(auth_viewModel.message)));
          } else {
            await uploadFile();
            // print('File Url : ' + url);
            if(identical(url, 'error')){
              myKey.currentState.showSnackBar(
                  SnackBar(content: Text('An error occurred while uploading pic.')));
            }else{
              User user = User(
                  id: auth_viewModel.auth.currentUser.uid,
                  name: nameController.text.toString(),
                  age: int.parse(ageController.text.toString()),
                  city: cityController.text.toString(),
                  imgUrl: url
              );
              store_viewModel.addNewUser(user).then((bool value) {
                if (value) {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ), (route) => false);
                } else {
                  myKey.currentState.showSnackBar(
                      SnackBar(content: Text(store_viewModel.errorMessage)));
                }
              });
            }
          }
        });
      },
    );
  }

  Future chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadFile() async {
    if(_image != null){
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('Chat/${_image.path.split('/').last}');
      print('Image Path: ' + _image.path.split('/').last);
      UploadTask uploadTask = ref.putFile(_image);
      await uploadTask
          .whenComplete(() async {
        print('Image uploaded...');
        await ref.getDownloadURL().then((value){
          url = value;
        }).catchError((e){
          print('Error from getDownloadURL :' + e.toString());
          url = 'error';
        });
      }).catchError((e) {
        print('Error from uploadFile :' + e.toString());
        url = 'error';
      });
    }
  }

}
