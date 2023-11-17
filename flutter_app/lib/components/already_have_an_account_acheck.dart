import 'package:flutter/material.dart';
import 'package:flutter_app/colors.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    required this.login,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(
              color: AppColors.text_sub,
              fontFamily: 'Inter-regular',
              fontSize: 16),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: AppColors.text_sub,
              fontFamily: 'Inter-regular',
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
