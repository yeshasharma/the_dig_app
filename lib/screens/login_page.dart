import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/screens/profiles_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  String? _email;
  String? _password;
  String? _errorMessage;
  StreamSubscription<User?>? _authSubscription;

  bool _isLoggedIn = false;
  @override
  initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() => {_isLoggedIn = user != null});
    });
    setState(() {
      _email = null;
      _password = null;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription?.cancel();
  }

  _logIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password!);
    } on FirebaseAuthException catch (e) {
      debugPrint("Error received: $e");
      setState(() => {_errorMessage = 'Incorrect email or password'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableButtons = _email == null || _password == null;
    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Icon(
            Icons.pets_outlined,
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      maxLines: 1,
                      maxLength: 40,
                      inputFormatters: [LengthLimitingTextInputFormatter(40)],
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        hintText: 'Enter Email address',
                      ),
                      onChanged: (email) => {
                        setState(() => {_email = email})
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      maxLines: 1,
                      maxLength: 15,
                      inputFormatters: [LengthLimitingTextInputFormatter(15)],
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                      ),
                      onChanged: (password) => {
                        setState(() => {_password = password})
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Center(
                            child: InkWell(
                          child: const Text('Forgot Password?'),
                          onTap: () {
                            _showResetPassword();
                          },
                        )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          (MediaQuery.of(context).size.width).toDouble() *
                              0.07),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.push('/register');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // set the button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // set the button shape
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: disableButtons ? null : _logIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .primaryColor, // set the button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // set the button shape
                                ),
                              ),
                              child: Text(
                                'Log in',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            )
                          ]),
                    ),
                    Text(
                      _errorMessage ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      const CircularProgressIndicator();
      String email = FirebaseAuth.instance.currentUser!.email.toString();
      Provider.of<DigFirebaseProvider>(context).setFirebaseAuth();
      return ProfilesPage(
        email: email,
      );
    }
  }

  void _showResetPassword() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    String errorMessagePasswordReset = '';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: formKey,
                child: TextFormField(
                  maxLines: 1,
                  maxLength: 40,
                  controller: emailController,
                  inputFormatters: [LengthLimitingTextInputFormatter(40)],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    labelText: 'Email address',
                    hintText: 'Enter Email address',
                  ),
                ),
              ),
              Text(
                errorMessagePasswordReset,
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) => context.pop())
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                                      'Password reset email sent for email: ${emailController.text}'))));
                    } on FirebaseAuthException catch (e) {
                      debugPrint("Error received: $e");
                      if (e.code == 'user-not-found') {
                        setState(() => {
                              errorMessagePasswordReset =
                                  'There is no user record corresponding to this identifier. The user may have been deleted.'
                            });
                      } else if (e.code == 'invalid-email') {
                        setState(() => {
                              errorMessagePasswordReset =
                                  'The email address is badly formatted'
                            });
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // set the button color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // set the button shape
                  ),
                ),
                child: Text(
                  'Send Email',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
