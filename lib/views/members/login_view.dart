import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/member.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class LoginView extends StatefulWidget {
  final Function()? onLogin;

  const LoginView({this.onLogin, Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Email text form controller
  final _emailController = TextEditingController();

  // Password text form controller
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Adresse mail',
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: member_mapper.inputFormatters,
              ),
              const SizedBox(height: 16),
              // Password text form field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
                inputFormatters: member_mapper.inputFormatters,
              ),
              const SizedBox(height: 32),
              FullWidget(
                widget: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          if (_emailController.text.trim().isEmpty) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Veuillez entrer une adresse mail',
                            );

                            return;
                          }

                          if (!member_mapper.emailRegExp
                              .hasMatch(_emailController.text.trim())) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Veuillez entrer une adresse mail valide',
                            );
                            return;
                          }

                          if (_passwordController.text.trim().isEmpty) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Veuillez entrer un mot de passe',
                            );

                            return;
                          }

                          if (!member_mapper.passwordRegExp
                              .hasMatch(_passwordController.text.trim())) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Votre mot de passe doit contenir au moins 8 caractères dont 1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial',
                            );
                            return;
                          }

                          try {
                            final response = await URL().post(
                              "https://api.ziedelth.fr/v1/member/login",
                              body: {
                                "email": _emailController.text.trim(),
                                "password": _passwordController.text.trim(),
                              },
                            );

                            // If response is null or response code is not 200, return an error
                            if (response == null ||
                                response.statusCode != 200) {
                              if (!mounted) return;
                              setState(() {
                                _isLoading = false;
                              });

                              showSnackBar(
                                context,
                                response?.body ??
                                    'Une erreur est survenue à la connexion',
                              );

                              return;
                            }

                            // Decode response to member
                            final member = Member.fromJson(
                              jsonDecode(response.body) as Map<String, dynamic>,
                            );

                            // If responseBody not contains token, return an error
                            if (member.token == null) {
                              if (!mounted) return;

                              setState(() {
                                _isLoading = false;
                              });

                              showSnackBar(
                                context,
                                'Une erreur est survenue à la connexion',
                              );

                              return;
                            }

                            // Save token and pseudo in shared preferences
                            member_mapper.setMember(member);

                            if (!mounted) return;

                            widget.onLogin?.call();

                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Bienvenue ${member.pseudo}',
                            );

                            Navigator.pop(context);
                          } catch (exception, stackTrace) {
                            setState(() {
                              _isLoading = false;
                            });

                            logger.error(
                              'Exception when trying to login',
                              exception,
                              stackTrace,
                            );

                            showSnackBar(context, 'Une erreur est survenue');
                          }
                        },
                  child: const Text("Se connecter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
