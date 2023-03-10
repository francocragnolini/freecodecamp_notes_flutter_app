import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/utilities/show_error_dialog.dart';
import 'dart:developer' as devtool show log;

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                    decoration:
                        const InputDecoration(hintText: "Enter your password"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = FirebaseAuth.instance.currentUser;
                        await user?.sendEmailVerification();
                        // Error= dThis warning essentially reminds you that,
                        //after an async call, the BuildContext might not be valid anymore
                        //CODE: Navigator.of(context).pushNamed(verifyEmailRoute);
                        //SOLUTION:
                        navigator.pushNamed(verifyEmailRoute);
                      } on FirebaseAuthException catch (e) {
                        devtool.log(e.code);
                        if (e.code == "weak-password") {
                          devtool.log("Weak Password");
                          await showErrorDialog(
                            context,
                            "Weak Password",
                          );
                        } else if (e.code == "email-already-in-use") {
                          devtool.log("Email already in use");
                          await showErrorDialog(
                            context,
                            "Email already in use",
                          );
                        } else if (e.code == "invalid-email") {
                          devtool.log("Invalid Email");
                          await showErrorDialog(
                            context,
                            "Invalid Email",
                          );
                        } else {
                          await showErrorDialog(
                            context,
                            "Error: ${e.code}",
                          );
                        }
                      } catch (e) {
                        await showErrorDialog(
                          context,
                          e.toString(),
                        );
                      }
                      // creates an user
                    },
                    child: const Text("Register"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text("Already registered? Login here!"))
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
