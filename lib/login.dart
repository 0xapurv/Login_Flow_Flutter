import 'dart:convert';
import 'package:accelx/register.dart';
import 'package:accelx/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  var url = Uri.https('curr.logiclane.tech', '/api/auth/local/login');

  late String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    
    final body = jsonEncode({
      "email": email,
      "password": password,
    });
    print(body.toString());
    final response = await http.post(url, body: body, headers: headers);

    print(response.body);
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final String accessToken = jsonResponse['data']['access_token'];

    if (response.statusCode == 200) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loading()),
        );
        savePref(accessToken);
      });
      loginToast("Login Sucessfull");
    } else if (response.statusCode == 400) {
      loginToast("Email or password is not correct");
    } else {
      loginToast("Login Failed");
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor:
            toast == "Login Sucessfull" ? Colors.green : Colors.red,
        textColor: Colors.white);
  }

  savePref(String auth_token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("auth_token", auth_token);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                color: Colors.black,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const FlutterLogo(
                        size: 100.0,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(
                        height: 50,
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Please Insert Email";
                            }
                          },
                          onSaved: (e) => email = e!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: const InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Email"),
                        ),
                      ),

                      // Card for password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Password Can't be Empty";
                            }
                          },
                          obscureText: _secureText,
                          onSaved: (e) => password = e!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phonelink_lock,
                                  color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            contentPadding: EdgeInsets.all(18),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      const TextButton(
                        onPressed: null,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(14.0),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: ElevatedButton(
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: ElevatedButton(
                                child: const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  );
                                }),
                          ),
                        ],
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
}
