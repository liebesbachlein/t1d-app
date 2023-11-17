import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Login/signup_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/components/already_have_an_account_acheck.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      child: Column(children: [LoginTop(), LoginForm()]))
                ],
              ),
            ),
          ),
        ));
  }
}

class LoginTop extends StatelessWidget {
  const LoginTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Text("Login",
            style: TextStyle(
              fontFamily: 'Inter-Regular',
              fontSize: 24,
              color: AppColors.text_set,
            )));
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);
  Map userData = {};
  static final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 300,
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
                    onSaved: (email) {},
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
                  print('form submitted');
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
          AlreadyHaveAnAccountCheck(press: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SignUpScreen();
            }));
          })
        ]));
  }
}
