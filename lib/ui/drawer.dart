import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth/authentication_bloc.dart';
import '../component/google_signup.dart';
import '../component/local_constant.dart';
import '../component/size_config.dart';
import '../helper/colors.dart';
import '../helper/config.dart';
import '../helper/global_handler.dart';
import '../helper/reuse_widget.dart';
import '../main.dart';

Widget drawerHelper({required dynamic context}) {


  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      //await GoogleSignInApi.logout();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
  return SafeArea(
      child: SizedBox(
    width: SizeConfig.screenWidth * 0.67,
    child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 6,
              vertical: SizeConfig.blockHeight * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      CupertinoIcons.multiply,
                      color: COLORS.blackdark,
                      weight: SizeConfig.blockWidth * 5,
                      size: SizeConfig.blockHeight * 4,
                    )),
              ),
              SizedBox(
                height: SizeConfig.blockHeight * 3,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.black54)),
                child: Image.network(
                  Config.profileImage,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                      shimmerCardRounded(),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockHeight * 3,
              ),
              Text(
                capitalizeFirstLetter(Config.name!),
                style: TextStyle(
                  color: COLORS.blackLight,
                  fontSize: SizeConfig.blockWidth * 4.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(
                height: SizeConfig.blockHeight * 1,
              ),
              SizedBox(
                width: SizeConfig.screenWidth,
                child: Text(
                  capitalizeFirstLetter(Config.emailId!),
                  style: TextStyle(
                    color: COLORS.blackLight,
                    fontSize: SizeConfig.blockWidth * 3.8,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  //GlobalBlocClass.authenticationBloc?.add(const AuthenticationLogoutEvent());
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove(LocalConstant.accessToken);
                  prefs.remove(LocalConstant.emailId);
                  prefs.remove(LocalConstant.profileImage);
                  prefs.remove(LocalConstant.name);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) =>
                              AuthenticationBloc()..add(const InitializeApp()),
                          child: const Authentication()),
                    ),
                    (Route<dynamic> route) => false,
                  );
                  signOut();
                  const snackBar =
                      SnackBar(content: Text("Logout Successfully"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockHeight * 8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.blockWidth * 2.5),
                      border: Border.all(
                          color: COLORS.whiteBorder,
                          width: SizeConfig.blockWidth * 1.3),
                      color: COLORS.blue),
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(
                      color: COLORS.white,
                      fontSize: SizeConfig.blockWidth * 4.2,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
  ));
}
