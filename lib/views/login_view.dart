import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView(this._callback, {Key? key}) : super(key: key);

  final VoidCallback _callback;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final UserMapper _userMapper = UserMapper();
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordErrorText;
  bool isLoading = false;
  String _globalErrorText = "";

  Future<void> requestLogin() async {
    if (isLoading) {
      return;
    }

    isLoading = true;

    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty) {
      isLoading = false;
      setState(() => _emailErrorText = "L'adresse mail doit être remplie");
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      isLoading = false;
      setState(
        () => _emailErrorText = "Le champ saisi doit être une adresse mail",
      );
      return;
    }

    setState(() {
      _emailErrorText = null;
      _globalErrorText = '';
    });

    if (password.isEmpty) {
      isLoading = false;
      setState(() => _passwordErrorText = "Le mot de passe doit être rempli");
      return;
    }

    setState(() {
      _passwordErrorText = null;
      _globalErrorText = '';
    });

    await post(
      'https://ziedelth.fr/api/v1/member/login/user',
      {
        "email": email,
        "password": password,
      },
      (success) {
        isLoading = false;
        final Map<String, dynamic> json =
            jsonDecode(success) as Map<String, dynamic>;

        if (json.containsKey('error')) {
          setState(() => _globalErrorText = json['error'] as String);
          return;
        }

        _userMapper.fromResponse(json);
        widget._callback.call();

        if (_userMapper.user == null) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bienvenue ${_userMapper.user?.pseudo}',
                ),
              ],
            ),
          ),
        );
      },
      (failure) {
        isLoading = false;

        setState(
          () => _globalErrorText =
              (jsonDecode(failure) as Map<String, dynamic>)['error'] as String,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BackButton(
              onPressed: widget._callback,
            ),
            Expanded(
              child: Text(
                'Connexion',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 2,
        ),
        const Spacer(),
        TextField(
          onSubmitted: (value) => requestLogin(),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Adresse mail',
            errorText: _emailErrorText,
          ),
        ),
        TextField(
          onSubmitted: (value) => requestLogin(),
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            errorText: _passwordErrorText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            _globalErrorText,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: requestLogin,
          child: const Text(
            'Se connecter',
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
