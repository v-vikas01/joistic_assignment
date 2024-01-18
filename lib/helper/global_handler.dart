import 'package:flutter/material.dart';
import '../bloc/auth/authentication_bloc.dart';


class GlobalBlocClass {
  static AuthenticationBloc? authenticationBloc;
  static BuildContext? authenticationContext;

}