import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   late final TextEditingController _email;
//   late final TextEditingController _password;

//   @override
//   void initState() {
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: FutureBuilder(
//         future: Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         ),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return Column(
//                 children: [
//                   TextField(
//                     autocorrect: false,
//                     enableSuggestions: false,
//                     controller: _email,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       hintText: "Enter your email",
//                     ),
//                   ),
//                   TextField(
//                     // makes the password not visible
//                     obscureText: true,
//                     autocorrect: false,
//                     enableSuggestions: false,
//                     controller: _password,
//                     decoration:
//                         const InputDecoration(hintText: "Enter your password"),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       final email = _email.text;
//                       final password = _password.text;
//                       try {
//                         // login user
//                         final userCredential = await FirebaseAuth.instance
//                             .signInWithEmailAndPassword(
//                                 email: email, password: password);
//                         print(userCredential);
//                         // it's called catch-all: it catches every exception that may occur

//                       } on FirebaseAuthException catch (e) {
//                         print(e.code);
//                         if (e.code == "user-not-found") {
//                           print("User not found");
//                         } else if (e.code == "wrong-password") {
//                           print("Wrong password");
//                         }
//                       }
//                     },
//                     child: const Text("Login"),
//                   ),
//                 ],
//               );
//             default:
//               return const Text("Loading...");
//           }
//         },
//       ),
//     );
//   }
// }

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
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                print(userCredential);
                // it's called catch-all: it catches every exception that may occur

              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == "user-not-found") {
                  print("User not found");
                } else if (e.code == "wrong-password") {
                  print("Wrong password");
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
