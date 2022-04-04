import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/utils/utils.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(this._callback, {Key? key}) : super(key: key);

  final VoidCallback _callback;

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegExp _pseudoRegex = RegExp(r"^\w{4,16}$");
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final TextEditingController _pseudoController = TextEditingController();
  String? _pseudoErrorText;
  final TextEditingController _emailController = TextEditingController();
  String? _emailErrorText;
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordErrorText;
  final TextEditingController _confirmationPasswordController =
      TextEditingController();
  String? _confirmationPasswordErrorText;
  bool _cgu = false;
  bool isLoading = false;
  String _globalErrorText = "";

  Future<bool> _testPseudo(String pseudo) async {
    if (pseudo.isEmpty) {
      setState(() => _pseudoErrorText = "Le pseudonyme doit être rempli");
      return false;
    }

    if (!_pseudoRegex.hasMatch(pseudo)) {
      setState(
        () => _pseudoErrorText = "Le pseudonyme n'est pas valide",
      );
      return false;
    }

    return true;
  }

  Future<bool> _testEmail(String email) async {
    if (email.isEmpty) {
      setState(() => _emailErrorText = "L'adresse mail doit être remplie");
      return false;
    }

    if (!_emailRegex.hasMatch(email)) {
      setState(
        () => _emailErrorText = "Le champ saisi doit être une adresse mail",
      );
      return false;
    }

    return true;
  }

  Future<void> _requestRegister() async {
    if (isLoading) {
      return;
    }

    isLoading = true;

    final String pseudo = _pseudoController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmationPassword = _confirmationPasswordController.text;

    if (!(await _testPseudo(pseudo))) {
      isLoading = false;
      return;
    }

    setState(() {
      _pseudoErrorText = null;
      _globalErrorText = '';
    });

    if (!(await _testEmail(email))) {
      isLoading = false;
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

    if (confirmationPassword.isEmpty) {
      isLoading = false;
      setState(
        () => _confirmationPasswordErrorText =
            "La confirmation du mot de passe doit être rempli",
      );

      return;
    }

    if (confirmationPassword != password) {
      isLoading = false;
      setState(
        () => _passwordErrorText = _confirmationPasswordErrorText =
            "Les mots de passes ne correspondent pas",
      );

      return;
    }

    setState(() {
      _passwordErrorText = _confirmationPasswordErrorText = null;
      _globalErrorText = '';
    });

    if (_cgu != true) {
      isLoading = false;
      setState(() => _globalErrorText = "Vous devez accepter les CGU");
      return;
    }

    await post(
      'https://ziedelth.fr/api/v1/member/register',
      {
        "pseudo": pseudo,
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

        widget._callback.call();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Un mail de confirmation vous a été envoyé à l'adresse mail suivante : $email. Veuillez le confirmer, vérifier aussi vos courriers indésirables.\nVous ne pourrez pas vous connecter tant que celle-ci ne sera pas valider.",
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
                'Inscription',
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
          onSubmitted: (value) => _requestRegister(),
          controller: _pseudoController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Pseudonyme',
            errorText: _pseudoErrorText,
          ),
        ),
        TextField(
          onSubmitted: (value) => _requestRegister(),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Adresse mail',
            errorText: _emailErrorText,
          ),
        ),
        TextField(
          onSubmitted: (value) => _requestRegister(),
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            errorText: _passwordErrorText,
          ),
        ),
        TextField(
          onSubmitted: (value) => _requestRegister(),
          controller: _confirmationPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmation du mot de passe',
            errorText: _confirmationPasswordErrorText,
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
        CheckboxListTile(
          value: _cgu,
          activeColor: Theme.of(context).primaryColor,
          checkColor: Colors.black,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) => setState(() => _cgu = value ?? false),
          title: const Text(
            "En cochant cette case, vous confirmez que vous avez lu et accepté les Conditions Générales d'Utilisation.",
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _requestRegister,
          child: const Text(
            "S'inscrire",
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
