import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/services/authentication_services/auth_services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key, this.toggleScreen}) : super(key: key);

  static final String id = "SINGNUP";
  final Function toggleScreen;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name, _email, _passwod;

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<AuthServices>(context);
    _submit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        await signupProvider.signup(_email, _passwod);
        // sign up in the user w/ Firebase
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
                            labelText: 'Name',
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? 'Please enter avalid Name'
                              : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
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
                              signupProvider.isLoading ? null : double.infinity,
                          child: signupProvider.isLoading
                              ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                              : Text(
                                  'Sign Up',
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
                          Text("Do have an account ?"),
                          TextButton(
                            onPressed: () => widget.toggleScreen(),
                            child: Text("Back to Login"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (signupProvider.errorMessage != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: Colors.amberAccent,
                          child: ListTile(
                            title: Text(signupProvider.errorMessage),
                            leading: Icon(Icons.error),
                            trailing: IconButton(
                                onPressed: () => signupProvider.setMessage(null), icon: Icon(Icons.close)),
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
