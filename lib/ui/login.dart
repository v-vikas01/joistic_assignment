import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joistic_assignment/component/google_signup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth/authentication_bloc.dart';
import '../component/local_constant.dart';
import '../component/size_config.dart';
import '../helper/colors.dart';
import '../helper/config.dart';
import '../helper/global_handler.dart';
import '../main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  bool loading = false;

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        Config.accessToken = credential.accessToken!;
        loading = true;
      });
      await prefs.setString(LocalConstant.accessToken, Config.accessToken);

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print('exception->$e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockWidth * 2,
                          vertical: SizeConfig.blockHeight * 1),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: COLORS.blackdark,
                          fontSize: SizeConfig.blockWidth * 6.2,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () async {
                          userCredential.value = await signInWithGoogle();
                          setState(() {
                            loading = true;
                          });
                          if (userCredential.value != null) {
                            setState(() {
                              Config.emailId = userCredential.value.user!.email;
                              Config.profileImage =
                                  userCredential.value.user!.photoURL;
                              Config.name =
                                  userCredential.value.user!.displayName;
                              loading = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString(
                                LocalConstant.emailId, Config.emailId);
                            await prefs.setString(LocalConstant.profileImage,
                                Config.profileImage);
                            await prefs.setString(
                                LocalConstant.name, Config.name);

                            const snackBar =
                                SnackBar(content: Text("SignIn Successfully"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/home');
                            //GlobalBlocClass.authenticationBloc?.add(const AuthenticationHomeScreenRedirectEvent());
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              icon: Image.asset('assets/images/google-icon.png',
                                  width: SizeConfig.blockWidth * 10),
                              onPressed: () {},
                            ),
                            Text(
                              "Sign in with google",
                              style: TextStyle(
                                color: COLORS.blackLight,
                                fontSize: SizeConfig.blockWidth * 3.8,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: loading,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockHeight * 2),
                        child: LoadingAnimationWidget.hexagonDots(
                          color: COLORS.blackExtraLight,
                          size: SizeConfig.blockHeight * 6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
