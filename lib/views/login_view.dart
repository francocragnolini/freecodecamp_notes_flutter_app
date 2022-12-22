import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          TextField(
            // makes the password not visible
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                // login user
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                devtool.log(userCredential.toString());
                // Navigates to notes view and removes the login view from the stack
                // still have this error i dont understand the reason of this error.

                navigator.pushNamedAndRemoveUntil('/notes/', (route) => false);

                // it's called catch-all: it catches every exception that may occur
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  devtool.log("User not found");
                } else if (e.code == "wrong-password") {
                  devtool.log("Wrong password");
                } else if ((e.code == "network-request-failed")) {
                  devtool.log("network request failed");
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register', (route) => false);
              },
              child: const Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
