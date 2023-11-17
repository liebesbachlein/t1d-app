import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Login/welcome_screen.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/Login/signup_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/components/already_have_an_account_acheck.dart';
import 'package:flutter_app/db_user.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'dart:async';

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';
  final _formkey = GlobalKey<FormState>();

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

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes
            Text(_contactText),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () => _handleGetContact(user),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.background,
              statusBarIconBrightness: Brightness.dark, // Android dark???
              statusBarBrightness: Brightness.light, // iOS dark???
            ),
            toolbarHeight: 0,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2),
                        alignment: Alignment.topCenter,
                        color: AppColors.background,
                        child:
                            Column(children: [LoginTop(), LoginForm(context)]))
                  ],
                ),
              ),
            ),
          ));
    }
  }

  Widget LoginTop() {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Text("Login",
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 24,
              color: AppColors.text_set,
            )));
  }

  Widget LoginForm(BuildContext context) {
    Map userData = {};
    String email = '';
    String password = '';

    return Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(149, 157, 165, 0.1),
                offset: Offset.zero,
                spreadRadius: 4,
                blurRadius: 10)
          ],
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Form(
              key: _formkey,
              child: Column(children: [
                TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(errorText: 'Please correct email filled'),
                    ]),
                    onSaved: (e) {
                      if (e == null) {
                        email = '';
                      } else {
                        email = e;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 16,
                            color: AppColors.lavender),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.person, color: AppColors.lavender),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: AppColors.lavender),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        errorStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: AppColors.lavender),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))))),
                Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter Password'),
                          MinLengthValidator(8,
                              errorText: 'Password must be atlist 8 digit'),
                          PatternValidator(r'(?=.*?[#!@$%^&*-])',
                              errorText:
                                  'Password must be atlist one special character')
                        ]),
                        onSaved: (e) {
                          if (e == null) {
                            password = '';
                          } else {
                            password = e;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 16,
                                color: AppColors.lavender),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(5),
                              child:
                                  Icon(Icons.person, color: AppColors.lavender),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            errorStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppColors.lavender),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))))))
              ])),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStatePropertyAll<double>(8),
                shadowColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(149, 157, 165, 0.2)),
                alignment: AlignmentDirectional.center,
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppColors.mint),
                padding:
                    MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
                shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState?.save();
                  processData(email, password);
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 50,
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontFamily: 'Inter-Regular',
                        fontSize: 16,
                        color: Colors.white),
                  ))),
          AlreadyHaveAnAccountCheck(
              login: true,
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }));
              }),
          buildSignInButton(
            onPressed: _handleSignIn,
          )
        ]));
  }

  Widget buildSignInButton({HandleSignInFn? onPressed}) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: 100,
            height: 30,
            child: Row(children: [
              Container(
                  width: 20,
                  height: 20,
                  child: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      fit: BoxFit.cover)),
              Text('Google',
                  style: TextStyle(fontFamily: 'Inter-Regular', fontSize: 16))
            ])));
  }
}

void processData(String email, String password) async {
  List<Map<String, dynamic>> listmaps =
      await databaseHelperUser.selectEmail(email);

  if (listmaps.length == 0) {
    print('no such account');
  } else {
    if (listmaps[0]['password'] != password) {
      print('incorrent password');
    } else {
      EMAIL = email;
      main2();
    }
  }
}
