part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  const HomeLoading();
  @override
  List<Object> get props => [];
}

class FetchHomeFailed extends HomeState {
  const FetchHomeFailed();
  @override
  List<Object> get props => [];
}

class FetchHomeSuccess extends HomeState {
  List<ListData> listData = [];
  FetchHomeSuccess({required this.listData});
  @override
  List<Object> get props => [listData];
}
