import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/services/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final passwordController = TextEditingController();
  var loading = false;

  Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'An Error Occurred!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(100, 48)),
              backgroundColor: WidgetStateProperty.all(Colors.red),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    setState(() {
      loading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          authData['email']!,
          authData['password']!,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          authData['email']!,
          authData['password']!,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed!';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      showErrorDialog(errorMessage);
    }

    setState(() {
      loading = false;
    });
  }

  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/authlogo.webp',
                  fit: BoxFit.cover,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter your email!';
                    } else if (!email.contains('@')) {
                      return "Invalid email!";
                    }
                    return null; // ❗ kerak
                  },
                  onSaved: (email) {
                    authData['email'] = email!;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    labelText: 'Password',
                  ),
                  controller: passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Please enter your password!';
                    } else if (password.length < 8) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (password) {
                    authData['password'] = password!;
                  },
                  obscureText: true,
                ),
                if (_authMode == AuthMode.Signup)
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          labelText: 'Confirm Password',
                        ),
                        validator: (confirmedPassword) {
                          if (passwordController.text != confirmedPassword) {
                            return 'Passwords do not match! Please enter the same password!';
                          }
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        height: 75,
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                        child: ElevatedButton(
                          onPressed: () => submitForm(),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(
                                255,
                                248,
                                204,
                                102,
                              ),
                            ),
                          ),
                          child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: switchAuthMode,
                      child: Text(
                        _authMode == AuthMode.Login ? 'Sign Up' : ' Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
