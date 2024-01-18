part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchListEvent extends HomeEvent {
  const FetchListEvent();
  @override
  List<Object> get props => [];
}
