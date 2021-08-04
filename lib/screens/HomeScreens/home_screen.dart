
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/services/authentication_services/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoutProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async => await logoutProvider.logout(),
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
    );
  }
}
