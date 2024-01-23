import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/firebase_options.dart';
import 'package:rideshare/provider/auth_provider.dart';
import 'package:rideshare/modules/authentication_module/screens/splash_screen.dart';

Future<void> main() async {
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider())
      ],
      builder: (context, child) {
        final authProvider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        authProvider.getUserDataFromFirebase().whenComplete(() {
          if (authProvider.isSignedIn == true &&
              authProvider.userModel.profilePic != "") {
            precacheImage(
                NetworkImage(authProvider.userModel.profilePic), context);
          }
        });
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 35, 29, 152)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
