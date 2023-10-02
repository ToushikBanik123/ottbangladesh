// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_loggy/flutter_loggy.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:loggy/loggy.dart';
// import 'package:ottapp/ui/auth/splash/splash.dart';
// import 'package:provider/provider.dart';
//
// import 'constants.dart';
// import 'data/local/helper/path_provider.dart';
// import 'essential/app_configuration.dart';
// import 'essential/translations.dart';
//
// void main() async {
//   Loggy.initLoggy(
//     logPrinter: PrettyDeveloperPrinter(),
//   );
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // await Firebase.initializeApp();
//   // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//   // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//
//   runZonedGuarded<Future<void>>(
//     () async {
//       AppConfiguration appConfig = AppConfiguration();
//       await AppPathProvider.initPath();
//       await GetStorage.init();
//
//       runApp(
//         MyApp(appConfig: appConfig),
//       );
//     },
//     FirebaseCrashlytics.instance.recordError,
//   );
// }
//
// class MyApp extends StatelessWidget with NetworkLoggy {
//   final AppConfiguration appConfig;
//
//   MyApp({required this.appConfig});
//
//   @override
//   Widget build(BuildContext context) {
// /*    SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);*/
//
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//       ),
//     );
//
//     return ChangeNotifierProvider<AppConfiguration>(
//       create: (BuildContext context) => appConfig,
//       child: Consumer<AppConfiguration>(
//         builder: (context, model, child) {
//           return GetMaterialApp(
//             translations: Messages(),
//             locale: Locale('en'),
//             fallbackLocale: Locale('en'),
//             theme: ThemeData(
//               fontFamily: 'Product Sans',
//               colorScheme: ColorScheme.fromSwatch().copyWith(
//                 brightness: Brightness.dark,
//                 primary: colorPrimary,
//                 background: colorPageBackground,
//                 secondary: colorAccent,
//               ),
//             ),
//             debugShowCheckedModeBanner: false,
//             home: SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loggy/loggy.dart';
import 'package:ottapp/ui/auth/splash/splash.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'data/local/helper/path_provider.dart';
import 'essential/app_configuration.dart';
import 'essential/translations.dart';

void main() async {
  Loggy.initLoggy(
    logPrinter: PrettyDeveloperPrinter(),
  );

  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded<Future<void>>(
        () async {
      AppConfiguration appConfig = AppConfiguration();
      await AppPathProvider.initPath();
      await GetStorage.init();

      runApp(
        MyApp(appConfig: appConfig),
      );
    },
        (error, stackTrace) {
      // Handle uncaught errors here if needed.
      print("Unhandled error: $error");
      print("Stack trace: $stackTrace");
    },
  );
}

class MyApp extends StatelessWidget with NetworkLoggy {
  final AppConfiguration appConfig;

  MyApp({required this.appConfig});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return ChangeNotifierProvider<AppConfiguration>(
      create: (BuildContext context) => appConfig,
      child: Consumer<AppConfiguration>(
        builder: (context, model, child) {
          return GetMaterialApp(
            translations: Messages(),
            locale: Locale('en'),
            fallbackLocale: Locale('en'),
            theme: ThemeData(
              fontFamily: 'Product Sans',
              colorScheme: ColorScheme.fromSwatch().copyWith(
                brightness: Brightness.dark,
                primary: colorPrimary,
                background: colorPageBackground,
                secondary: colorAccent,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
