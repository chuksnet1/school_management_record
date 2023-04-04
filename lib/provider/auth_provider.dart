import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
   late String _token;
  DateTime? _expiryTokenDate;
  String? _userId;
  Timer? _authTimer;


  bool get isAuth {
    return token != null;
  }


  String? get token {
    if (_expiryTokenDate != null &&
        _expiryTokenDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }


  String? get userId {
    return _userId;
  }


  Future<void> _authenticate(String email, String password, String urlString) async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlString?key=AIzaSyCmJfItXKrTgw5oZfZLSdQS7cEi0gcd6Mc');
try{
    final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      

      final responseData = json.decode(response.body);

       if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      //setting a token if there is no error , values gotten from server, through rest api
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTokenDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogOut();
      notifyListeners();


      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryTokenDate!.toIso8601String(),
        },
      );
      //our data from json server is stored on the shared preferences(phone)----go to auto login down
       prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  
  Future<void> signUp(String email, String passWord) async {
    return _authenticate(email, passWord, 'signUp');
  }


  Future<void> login(String email, String passWord) async {
    return _authenticate(email, passWord, 'signInWithPassword');
  }



  //to check if the token is still valid and stored in the device so as to login automatically when the user comes back
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = prefs.getString('userData') as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());

    if(expiryDate.isAfter(DateTime.now())){      //time has past
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryTokenDate = expiryDate;
    notifyListeners();
    _autoLogOut();

    return true;
  }
  

  Future<void> logout()  async{
    _token = '';
    _userId = null;
    _expiryTokenDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');   if u are storing other data on the device, use this
    prefs.clear();         //if not use this
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryTokenDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

}