import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joistic_assignment/component/size_config.dart';
import 'package:joistic_assignment/ui/home.dart';
import 'package:joistic_assignment/ui/splash_screen.dart';

import 'bloc/auth/authentication_bloc.dart';
import 'bloc/home/home_bloc.dart';
import 'helper/global_handler.dart';
import 'ui/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (error) {
    print("Firebase initialization error: $error");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Demo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        "/home": (context) => BlocProvider(
              create: (context) => HomeBloc()..add(const FetchListEvent()),
              child: const HomeScreen(),
            ),
      },
    );
  }
}

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalBlocClass.authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    GlobalBlocClass.authenticationContext = context;
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder(
        bloc: authenticationBloc,
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return const SplashScreen();
          }
          if (state is AuthenticationLoginRequired) {
            return const SignInScreen();
          }
          if (state is AuthenticationHomeScreen) {
            return BlocProvider(
              create: (context) => HomeBloc()..add(const FetchListEvent()),
              child: const HomeScreen(),
            );
          }
          return const SignInScreen();
        });
  }
}
