import 'package:flutter/material.dart';
import 'package:flutter_app/authentification/welcome_screen.dart';
import 'package:flutter_app/colors.dart';
import 'package:flutter_app/home/home_page.dart';
import 'package:flutter_app/data_log/data_log.dart';

String EMAIL = 'gerardinearmstrong@gmail.com';

void main() {
  runApp(const AppInitializer());
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitializerWidget(),
    );
  }
}

class InitializerWidget extends StatelessWidget {
  const InitializerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.init(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'An error occurred during initialization',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return const HomePage();
          }
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.purple),
        );
      },
    );
  }
}



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   var c = await MainWelcome.create();
//   runApp(c);
// }

// class MainWelcome extends StatelessWidget {
//   MainWelcome();
//   MainWelcome._create() {}
//   static Future<MainWelcome> create() async {
//     var component = MainWelcome._create();
//     await databaseHelperUser.init();
//     return component;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false, home: WelcomeScreen());
//   }
// }

// void main2() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   var c = await MainHome.create();
//   runApp(c);
// }

// class MainHome extends StatelessWidget {
//   MainHome();
//   MainHome._create() {}
//   static Future<MainHome> create() async {
//     var component = MainHome._create();
//     await databaseHelper.init();
//     return component;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
//   }
// }
