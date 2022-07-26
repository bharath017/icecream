import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icecream/Screens/AccountSettings.dart';
import 'package:icecream/Screens/AddPhoto.dart';
import 'package:icecream/Screens/EnterMailorNumber.dart';
import 'package:icecream/Screens/NumberScreen.dart';
import 'package:icecream/Screens/PaymentScreen.dart';
import 'package:icecream/Screens/TermsAndConditions.dart';
import 'package:icecream/Screens/UserDetailsScreen.dart';
import 'package:icecream/Screens/map2.dart';
import 'package:icecream/Settings/Theme/Theme.dart';
import 'package:icecream/infoHandler/app_info.dart';
import 'package:icecream/splashScreen/splash_screen.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:provider/provider.dart';

// Future main() async {
//   await dotenv.load(fileName: 'assets/.env');
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     HttpOverrides.global = new MyHttpOverrides();
//     return LayoutBuilder(builder: ((context, constraints) {
//       return OrientationBuilder(builder: ((context, orientation) {
//         SizeConfig().init(constraints, orientation);
//         return MaterialApp(
//             title: 'Flutter Demo',
//             debugShowCheckedModeBanner: false,
//             themeMode: ThemeMode.dark,
//             theme: ThemeClass.lightTheme,
//             darkTheme: ThemeClass.darkTheme,
//             home: MapApp());
//       }));
//     }));
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MyApp(
      child: ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: LayoutBuilder(builder: ((context, constraints) {
            return OrientationBuilder(builder: ((context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                title: 'Icecream App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: EnterMailorNumber(isMail: false),
                // home: const AddPhoto(),
                debugShowCheckedModeBanner: false,
              );
            }));
          })))));
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
