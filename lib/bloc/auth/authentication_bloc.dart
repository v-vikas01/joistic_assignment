import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/local_constant.dart';
import '../../helper/config.dart';
import '../../helper/custom_log.dart';
import '../../helper/global_handler.dart';
import '../../main.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {

    on<InitializeApp>((event, emit) async{
      await mapInitializeAppEvent(event, emit);
    });

    on<AuthenticationHomeScreenRedirectEvent>((event, emit) async{
      await mapAuthenticationHomeScreenRedirectEvent(event, emit);
    });
  }


  Future<void> mapInitializeAppEvent(
      InitializeApp event, Emitter<AuthenticationState> emit) async {
    try {
      emit(const AuthenticationLoading());

      sleep(const Duration(seconds: 2));


      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(LocalConstant.accessToken) ?? "";
      String email = prefs.getString(LocalConstant.emailId) ?? "";
      String name = prefs.getString(LocalConstant.name) ?? "";
      String profileImage = prefs.getString(LocalConstant.profileImage) ?? "";

      Config.accessToken = token;
      Config.emailId = email;
      Config.name = name;
      Config.profileImage = profileImage;

      customLog("Access Token : ${Config.accessToken}");

      if (token.isNotEmpty) {
        emit(const AuthenticationHomeScreen());
      } else {
        emit(const AuthenticationLoginRequired());
      }
    } catch (error) {
      emit(const AuthenticationLoginRequired());
    }
  }



  Future<void> mapAuthenticationLogin(
      AuthenticationLoginEvent event, Emitter<AuthenticationState> emit) async {
    ///Get values from local storage and remove them
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(LocalConstant.accessToken);
    prefs.remove(LocalConstant.emailId);
    prefs.remove(LocalConstant.profileImage);
    prefs.remove(LocalConstant.name);



    emit(const AuthenticationLoginRequired());
    Navigator.pushAndRemoveUntil(
      GlobalBlocClass.authenticationContext!,
      MaterialPageRoute(
        builder: (context) => BlocProvider(create: (context) => AuthenticationBloc()..add(const InitializeApp()),
            child: const Authentication()),
      ),
          (Route<dynamic> route) => false,
    );
    const snackBar =  SnackBar(content: Text("Please Register"));
    ScaffoldMessenger.of(GlobalBlocClass.authenticationContext!).showSnackBar(snackBar);
  }

  Future<void> mapAuthenticationHomeScreenRedirectEvent(
      AuthenticationHomeScreenRedirectEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationHomeScreen());
  }
}
