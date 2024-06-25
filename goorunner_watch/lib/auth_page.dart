import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/home_page.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged in
          if (snapshot.hasData) {
            return const Test();
          }
          // not logged in
          else {
            return const MyHomePage();
          }
        },
      ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Logged in!'),
          ElevatedButton(
              onPressed: () => Authenticator().logOut(),
              child: const Text('Logout')),
        ],
      ),
    );
  }
}
