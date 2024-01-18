import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../main.dart';
import '../bloc/auth/authentication_bloc.dart';
import '../component/size_config.dart';
import '../helper/colors.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    if (context != null) {
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => AuthenticationBloc()..add(const InitializeApp()),
            child: const Authentication(),
          ),
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: COLORS.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: COLORS.white,
      ),
      body:  SafeArea(
          child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            color: COLORS.white,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 4),
            child: Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: COLORS.blackExtraLight,
                size: SizeConfig.blockHeight * 6,
              ),
            ),
          )
      ),
    );
  }
}