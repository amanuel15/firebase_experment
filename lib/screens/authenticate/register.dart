import 'package:first_firebase/services/auth.dart';
import 'package:first_firebase/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field states
  String email = '';
  String password = '';
  String error = 'error';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              title: Text('Sign Up'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                ),
              ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blue,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    heightFactor: 0.5,
                    widthFactor: 0.5,
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(200.0)),
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                      child: Container(
                        width: 400,
                        height: 400,
                      ),
                    ),
                  ),
                  Align(
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(200.0)),
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      child: Container(
                        width: 400,
                        height: 400,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 400.0,
                      height: 300.0,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            customFormField(
                              fieldIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              hintText: 'Email',
                            ),
                            customFormField(
                              fieldIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: 'Password',
                              hide: true,
                            ),
                            Container(
                              width: 150,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerWithEmailAndPass(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = 'Please provide a valid input';
                                      });
                                      //print(error);
                                    } else { // added part
                                      setState(() {
                                        loading = false;
                                        error = 'Verify your email and sign in.';
                                      });
                                      widget.toggleView();
                                    }
                                    print(error);
                                  }
                                },
                                color: Colors.deepOrange,
                                textColor: Colors.white,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget customFormField({Icon fieldIcon, String hintText, bool hide = false}) {
    return Container(
      width: 250.0,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.deepOrange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: fieldIcon,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              width: 200.0,
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (val) {
                    if (hide) {
                      return val.length < 6 ? 'Password too short' : null;
                    } else {
                      return val.isEmpty ? 'Enter an Email' : null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      if (hide) {
                        password = val;
                      } else {
                        email = val;
                      }
                    });
                  },
                  obscureText: hide,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
