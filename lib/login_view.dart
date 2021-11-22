// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, use_rethrow_when_possible, avoid_print, unused_element

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _appIdController =
      TextEditingController(text: '4C0E7AF1-8FC6-4584-BF77-98C6C2F5BBDC');
  final _userIdController = TextEditingController();
  bool _enableSignInButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: Text(
        'Zich Sample',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image(
              image: AssetImage('assets/logoSendbird@3x.png'),
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Zich Sample',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            controller: _appIdController,
            onChanged: (value) {
              setState(() {
                _enableSignInButton = _shouldEnableSignInButton();
              });
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'App Id',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                    onPressed: () {
                      _appIdController.clear();
                    },
                    icon: Icon(Icons.clear))),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _userIdController,
            onChanged: (value) {
              setState(() {
                _enableSignInButton = _shouldEnableSignInButton();
              });
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'User Id',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  onPressed: () {
                    _userIdController.clear();
                  },
                  icon: Icon(Icons.clear),
                )),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: _signInButton(context, _enableSignInButton),
          )
        ],
      ),
    );
  }

  bool _shouldEnableSignInButton() {
    if (_appIdController.text.isEmpty) {
      return false;
    }
    if (_userIdController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    if (enabled == false) {
      return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all(Colors.grey[300])),
        onPressed: () {},
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xff742DDD)),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      onPressed: () {
        connect(_appIdController.text, _userIdController.text).then((user) {
          Navigator.pushNamed(context, '/channel_list');
        }).catchError((error) {
          print('login_view: _signInButton: ERROR: $error');
        });
      },
      child: Text(
        'Sign In',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Future<User> connect(String appId, String userId) async {
    // Init Sendbird SDK and connect with current user id
    try {
      final sendbird = SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }
}
