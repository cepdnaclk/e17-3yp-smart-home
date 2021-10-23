import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

//we create a widget `LoginPage` that will have state
class LoginPage extends StatefulWidget {
  // `createState()` will create the mutable state for this widget at a given
  //location in the tree.
  @override
  _LoginPageState createState() => _LoginPageState();
}

//The logic and internal state for our StatefulWidget(LoginPage).
//State is information that (1) can be read synchronously when the widget is
//built and (2) might change during the lifetime of the widget.
class _LoginPageState extends State<LoginPage> {
  //`GlobalKey()` will create us a LabeledGlobalKey, which is a GlobalKey
  //with a label used for debugging.
  // A GlobalKey is a key that is unique across the entire app.
  //`FormState` is a state associated with a Form widget.
  final formKey = GlobalKey<FormState>();
  //`SaffoldState` is a state for a Scaffold.
  // Remember `Scaffold`is a class that implements the basic material design
  //visual layout structure and derives from the `StatefulWidget`
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //We have two private fields here
  String? _email;
  String ?_password;

  // a private method `_submitCommand()`
  void _submitCommand() {
    //get state of our Form
    final form = formKey.currentState;

    //`validate()` validates every FormField that is a descendant of this Form,
    // and returns true if there are no errors.
    if (form!.validate()) {
      //`save()` Saves every FormField that is a descendant of this Form.
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
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
        title: Text('Simple Login Validator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => !EmailValidator.validate(val!, true)
                    ? 'Please provide a valid email.'
                    : null,
                onSaved: (val) => _email = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (val) =>
                val!.length < 4 ? 'Your password is too Password too short..' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}