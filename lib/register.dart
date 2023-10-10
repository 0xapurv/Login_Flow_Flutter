import 'dart:convert';
import 'package:accelx/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String username,
      email,
      mobile,
      password,
      phone,
      firstName,
      lastName,
      name;
  final _key = GlobalKey<FormState>();
  var url = Uri.https('curr.logiclane.tech', '/api/auth/local/signup');

  bool _secureText = true;

  void splitFullName(String name) {
    List<String> nameParts = name.split(' ');

    firstName = nameParts.first;
    lastName = nameParts.length > 1 ? nameParts.last : '';
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    print(url.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    final body = jsonEncode({
      "email": email,
      "password": password,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "middleName": " ",
      "phoneNumber": phone,
      "walletPin": 0,
      "deviceId": "string",
      "deviceIp": "string",
      "deviceModel": "string",
      "billingAddress": {
        "street1": "string",
        "street2": "string",
        "city": "string",
        "state": "string",
        "zipCode": "string",
        "country": "string"
      },
    });
    final response = await http.post(
      url,
      body: body,
      headers: headers,
    );
    print(response.body);

    if (response.statusCode == 201) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
      registerToast("Register sucessfull");
    } else if (response.statusCode == 400) {
      registerToast("A user with that username already exists");
    } else {
      registerToast("Register fail");
    }
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor:
            toast == "Register sucessfull" ? Colors.green : Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
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
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      //card for Username TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Please insert Username";
                            }
                          },
                          onSaved: (e) => username = e!,
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
                              labelText: "Username"),
                        ),
                      ),

                      // Card for Name TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Please insert Full Name";
                            }
                          },
                          onSaved: (e) {
                            splitFullName(e!);
                            name = e;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: const InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person_3_outlined, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Name"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Please insert Email";
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
                                child: Icon(Icons.email, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Email"),
                        ),
                      ),
                      
                      //Card for Phone Number TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          maxLength: 10,
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Please insert Phone Number";
                            }
                          },
                          onSaved: (e) => phone = e!,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: const InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phone, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Phone Number"),
                        ),
                      ),

                      // Card for password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),


                      const Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: ElevatedButton(
                                child: const Text(
                                  "Register",
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
                                  "GoTo Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
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
