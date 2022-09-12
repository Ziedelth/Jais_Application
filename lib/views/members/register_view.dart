import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/members/login_view.dart';
import 'package:url/url.dart';

class RegisterView extends StatefulWidget {
  final Function()? onLogin;

  const RegisterView({this.onLogin, super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
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
  bool _passwordVisible = false;

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
                inputFormatters: MemberMapper.instance.inputFormatters,
              ),
              const SizedBox(height: 16),
              // Pseudo text form field
              TextFormField(
                controller: _pseudoController,
                decoration: const InputDecoration(
                  labelText: 'Pseudonyme',
                ),
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
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              const SizedBox(height: 16),
              // Confirm password text form field
              TextFormField(
                controller: _passwordConfirmationController,
                decoration: InputDecoration(
                  labelText: 'Confirmer votre mot de passe',
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

                          if (!MemberMapper.instance.pseudoRegExp
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
                              getRegisterUrl(),
                              body: {
                                "email": _emailController.text.trim(),
                                "pseudo": _pseudoController.text.trim(),
                                "password": _passwordController.text.trim(),
                              },
                            );

                            // If response is null or response code is not 201, return an error
                            if (!response.isCorrect(201)) {
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
                          } catch (_) {
                            setState(() {
                              _isLoading = false;
                            });

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
