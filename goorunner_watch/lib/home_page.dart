import 'package:flutter/material.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey there!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => Authenticator().loginWithGoogle(),
                child: Text("Google")),
          ],
        ),
      ),
    );
  }
}
