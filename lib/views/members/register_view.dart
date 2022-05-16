import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/utils/utils.dart';
import 'package:jais/views/members/login_view.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class RegisterView extends StatefulWidget {
  final Function()? onLogin;

  const RegisterView({this.onLogin, Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Email text form controller
  final _emailController = TextEditingController();

  // Pseudo text form controller
  final _pseudoController = TextEditingController();

  // Password text form controller
  final _passwordController = TextEditingController();

  // Password confirmation text form controller
  final _passwordConfirmationController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Inscription'),
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
              // Pseudo text form field
              TextFormField(
                controller: _pseudoController,
                decoration: const InputDecoration(
                  labelText: 'Pseudonyme',
                ),
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
              const SizedBox(height: 16),
              // Confirm password text form field
              TextFormField(
                controller: _passwordConfirmationController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer votre mot de passe',
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

                          if (_pseudoController.text.trim().isEmpty) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Veuillez entrer un pseudonyme',
                            );

                            return;
                          }

                          if (!member_mapper.pseudoRegExp
                              .hasMatch(_pseudoController.text.trim())) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Veuillez entrer un pseudonyme valide',
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

                          if (_passwordController.text.trim() !=
                              _passwordConfirmationController.text.trim()) {
                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Les mots de passe ne correspondent pas',
                            );
                            return;
                          }

                          try {
                            final response = await URL().post(
                              "https://api.ziedelth.fr/v1/member/register",
                              body: {
                                "email": _emailController.text.trim(),
                                "pseudo": _pseudoController.text.trim(),
                                "password": _passwordController.text.trim(),
                              },
                            );

                            // If response is null or response code is not 201, return an error
                            if (response == null ||
                                response.statusCode != 201) {
                              if (!mounted) return;
                              setState(() {
                                _isLoading = false;
                              });

                              showSnackBar(
                                context,
                                response?.body ??
                                    'Une erreur est survenue à la création de votre compte',
                              );

                              return;
                            }

                            if (!mounted) return;

                            setState(() {
                              _isLoading = false;
                            });

                            showSnackBar(
                              context,
                              'Votre compte a bien été créé, vous pouvez vous connecter',
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(
                                  onLogin: widget.onLogin,
                                ),
                              ),
                            );
                          } catch (exception, stackTrace) {
                            setState(() {
                              _isLoading = false;
                            });

                            logger.error(
                              'Exception when trying to register user',
                              exception,
                              stackTrace,
                            );

                            showSnackBar(context, 'Une erreur est survenue');
                          }
                        },
                  child: const Text("S'inscrire"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
