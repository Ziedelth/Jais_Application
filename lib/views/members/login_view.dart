import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/models/member.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class LoginView extends StatefulWidget {
  final Function()? onLogin;

  const LoginView({this.onLogin, super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Email text form controller
  final _emailController = TextEditingController();

  // Password text form controller
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

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
                inputFormatters: MemberMapper.instance.inputFormatters,
              ),
              const SizedBox(height: 16),
              // Password text form field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
                inputFormatters: MemberMapper.instance.inputFormatters,
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

                          if (!MemberMapper.instance.emailRegExp
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

                          if (!MemberMapper.instance.passwordRegExp
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
                              getLoginWithCredentialsUrl(),
                              body: {
                                "email": _emailController.text.trim(),
                                "password": _passwordController.text.trim(),
                              },
                            );

                            // If response is null or response code is not 200, return an error
                            if (!response.isOk) {
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
                              jsonDecode(fromBrotli(response!.body))
                                  as Map<String, dynamic>,
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
                            MemberMapper.instance.setMember(member);

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
                          } catch (_) {
                            setState(() {
                              _isLoading = false;
                            });

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
