import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/services/authentication_services/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final logoutProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 32.0,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async => await logoutProvider.logout(),
            icon: Icon(
              Icons.exit_to_app,
            ),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Color(0xFFEDF0F6),
    );
  }
}
