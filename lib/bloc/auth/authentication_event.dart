part of 'authentication_bloc.dart';



@immutable
abstract class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class InitializeApp extends AuthenticationEvent{
  const InitializeApp();

  @override
  List<Object> get props => [];
}

class AuthenticationLogoutEvent extends AuthenticationEvent{
  const AuthenticationLogoutEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent{
  const AuthenticationLoginEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationHomeScreenRedirectEvent extends AuthenticationEvent{
  const AuthenticationHomeScreenRedirectEvent();

  @override
  List<Object> get props => [];
}
