import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/services/authentication_services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key, this.toggleScreen}) : super(key: key);

  static final String id = "LOGIN";

  final Function toggleScreen;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _email, _passwod;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    _submit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print(_email);
        print(_passwod);
        await loginProvider.login(
          _email.trim(),
          _passwod.trim(),
        );

        // logging in the user w/ Firebase
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Instagram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 50.0,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                          ),
                          validator: (input) => !input.contains('@')
                              ? 'Please enter avalid email'
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            labelText: 'Password',
                          ),
                          validator: (input) => input.length < 6
                              ? 'Must be least 6 characters'
                              : null,
                          onSaved: (input) => _passwod = input,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 250.0,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blue,
                          padding: EdgeInsets.all(10.0),
                          minWidth:
                              loginProvider.isLoading ? null : double.infinity,
                          child: loginProvider.isLoading
                              ? CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Billabong',
                                    fontSize: 20.0,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ?"),
                          TextButton(
                            onPressed: () => widget.toggleScreen(),
                            child: Text("Rgister"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (loginProvider.errorMessage != null)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: EdgeInsets.all(5),
                          color: Colors.amberAccent,
                          child: ListTile(
                            title: Text(loginProvider.errorMessage),
                            leading: Icon(Icons.error),
                            trailing: IconButton(
                                onPressed: () => loginProvider.setMessage(null),
                                icon: Icon(Icons.close)),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
