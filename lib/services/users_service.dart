 //clase encargada de hacer las peticiones http

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class UsersService extends ChangeNotifier{

final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';

final List<User> users = [];

bool isLoading = true;

UsersService (){
this.loadUser();
}

Future <List<User>> loadUser() async{
  this.isLoading = true;
  notifyListeners();

  final url =  Uri.https(_baseUrl, 'users.json');
  final resp = await http.get(url);
 
  final Map<String, dynamic> usersMap = json.decode(resp.body);

  usersMap.forEach((key, value) {
    final tempUser = User.fromMap(value); 
    tempUser.id = key;
    this.users.add(tempUser);
  });

  this.isLoading = false;
  notifyListeners();

  return this.users;
}

}