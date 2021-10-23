import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

//we create a widget `LoginPage` that will have state
class LoginPage extends StatefulWidget {
  // `createState()` will create the mutable state for this widget at a given
  //location in the tree.
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {t.
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //We have two private fields here
  String? _email;
  String ?_password;

  // a private method `_submitCommand()`
  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

   
    if (form!.validate()) {

      form.save();

      _loginCommand();
    }
  }

  void _loginCommand() {
    // Show login details in snackbar
    final snackbar = SnackBar(
      content: Text('Email: $_email, password: $_password'),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Simple Login Validator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => !EmailValidator.validate(val!, true)
                    ? 'Please provide a valid email.'
                    : null,
                onSaved: (val) => _email = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) =>
                val!.length < 4 ? 'Your password is too Password too short..' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: _submitCommand,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}