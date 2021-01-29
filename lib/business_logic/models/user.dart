
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String id;
  String name;
  int age;
  String city;
  String imgUrl;

  User({this.id, this.name, this.age, this.city, this.imgUrl});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User newUser = User.fromJson(snapshot.data());
    return newUser;
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      city: json['city'],
      imgUrl: json['imgUrl']
    );
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'age': this.age,
      'city': this.city,
      'imgUrl': this.imgUrl
    };
  }

}