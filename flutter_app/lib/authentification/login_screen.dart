import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/authentification/auth_services.dart';
import 'package:flutter_app/db_user.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/colors.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert' show json;
//import 'dart:async';

/*
typedef HandleSignInFn = Future<void> Function();
/*
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: const Text('SIGN IN'),
  );
}*/

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);
*/
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //GoogleSignInAccount? _currentUser;
  //bool _isAuthorized = false;
  //String _contactText = '';
  bool _isSignIning = false;

  final _formkey = GlobalKey<FormState>();

  final FirebaseServices _auth = FirebaseServices();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

/*
  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });
      if (isAuthorized) {
        unawaited(_handleGetContact(account!));
      }
    });

    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
    if (isAuthorized) {
      unawaited(_handleGetContact(_currentUser!));
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();*/
  double offsetForm = 0.52;

  @override
  Widget build(BuildContext context) {
    //final GoogleSignInAccount? user = _currentUser;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: AppColors.lavender_light,
          backgroundColor: AppColors.lavender_light,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.lavender_light,
            statusBarIconBrightness: Brightness.dark, // Android dark???
            statusBarBrightness: Brightness.light, // iOS dark???
          ),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
            alignment: Alignment.topCenter,
            color: AppColors.lavender_light,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(alignment: Alignment.topCenter, children: [
              TopBack(),
              LogTop(),
              Container(
                  //padding: EdgeInsets.only(
                  //  top: MediaQuery.of(context).size.height * 0.2),
                  //alignment: Alignment.topCenter,
                  //color: AppColors.background,
                  alignment: Alignment.bottomCenter,
                  child: LoginForm())
            ])));
  }

  Widget LoginForm() {
    Map userData = {};
    String email = '';
    String password = '';

    return Container(
        height: MediaQuery.of(context).size.height * offsetForm,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.1),
                  offset: Offset.zero,
                  spreadRadius: 4,
                  blurRadius: 10)
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Form(
              key: _formkey,
              child: Column(children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    height: 55,
                    child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: AppColors.mint),
                        onTap: () {
                          setState(() {
                            offsetForm = 0.75;
                          });
                        },
                        /*onEditingComplete: () {
                          setState(() {
                            offsetForm = 0.52;
                          });
                        },*/
                        autocorrect: false,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'email?'),
                          EmailValidator(errorText: 'Fix the email'),
                        ]),
                        onSaved: (e) {
                          if (e == null) {
                            email = '';
                          } else {
                            email = e;
                          }
                        },
                        decoration: InputDecoration(
                            constraints: BoxConstraints(minHeight: 60),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 16,
                                color: AppColors.lavender_light),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.ramen_dining,
                                  color: AppColors.lavender_light),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender_light)),
                            errorStyle: TextStyle(
                                fontSize: 14, fontFamily: 'Inter-Regular'),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.lavender_light))))),
                SizedBox(
                    //margin: EdgeInsets.only(bottom: 5),
                    height: 55,
                    child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: Colors.black),
                        onTap: () {
                          setState(() {
                            offsetForm = 0.75;
                          });
                        },
                        /*onEditingComplete: () {
                          setState(() {
                            offsetForm = 0.52;
                          });
                        },*/
                        obscuringCharacter: '☭',
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'password?'),
                          MinLengthValidator(8,
                              errorText: 'minimum 8 characters'),
                          /*PatternValidator(r'(?=.*?[#!@$%^&*-_])',
                              errorText:
                                  'add a special character')*/
                        ]),
                        onSaved: (e) {
                          if (e == null) {
                            password = '';
                          } else {
                            password = e;
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: AppColors.lavender,
                            focusColor: AppColors.lavender,
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 16,
                                color: AppColors.lavender_light),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.castle,
                                  color: AppColors.lavender_light),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender_light)),
                            errorStyle: TextStyle(
                                fontSize: 14, fontFamily: 'Inter-Regular'),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.lavender_light)))))
              ])),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 8, left: 10, right: 10),
                  child: TextButton(
                      onPressed: () {
                        popUpNoSuchFeature("the feature will be here soon");
                      },
                      child: Text('Forgot password?',
                          style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 12,
                              color: AppColors.text_sub))))),
          ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width * 0.85, 60)),
                elevation: MaterialStatePropertyAll<double>(2),
                shadowColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(179, 233, 221, 233)),
                alignment: AlignmentDirectional.center,
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppColors.mint),
                padding:
                    MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
                shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();
                  _signIn();
                }
              },
              child: _isSignIning
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login',
                      style: TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: 16,
                        color: Colors.white,
                      ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: TextButton(
                  onPressed: () {
                    popUpNoSuchFeature("the feature will be here soon");
                  },
                  child: Column(children: [
                    Text('or login with',
                        style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: AppColors.text_sub)),
                    Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(top: 12),
                        child: Image.asset('lib/assets/images/google_icon.png'))
                  ])))
        ]));
  }

  void _signIn() async {
    setState(() {
      _isSignIning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      _isSignIning = false;
    });
    if (user != null) {
      print('User successfully signed in');
      UserModel resUser = await firebaseRemoteHelper.getUsername(email);
      Random random = new Random();
      int randomNumber = random.nextInt(1000) + 1000;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('authToken', randomNumber);
      await prefs.setString('email', email);
      await prefs.setString('username', resUser.username);
      firebaseRemoteHelper.changeToken(email, randomNumber);
      main2(username: resUser.username, email: email);
    } else {
      popUpNoSuchFeature("Incorrect email/password");
    }
  }

  Widget LogTop() {
    return Container(
        alignment: Alignment.topLeft,
        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: MediaQuery.of(context).size.width * 0.92,
        //constraints: BoxConstraints(minHeight: 100),
        height: MediaQuery.of(context).size.height * 0.92,
        padding: EdgeInsets.only(left: 12),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: Text('Login',
            style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 32,
              color: Colors.white,
            )));
  }

  void popUpNoSuchFeature(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            content: SizedBox(
                width: 200,
                height: 300,
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.close, color: Colors.black)))),
                  Text(text,
                      style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 16,
                          color: AppColors.mint)),
                  Image.asset('lib/assets/images/ryan_gosling.jpg',
                      width: 170, height: 170)
                ]))));
  }
}

class TopBack extends StatefulWidget {
  const TopBack({super.key});
  @override
  State<TopBack> createState() => _TopBackState();
}

class _TopBackState extends State<TopBack> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 12),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }));
  }
}
