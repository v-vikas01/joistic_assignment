import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../dao/dao.dart';
import '../../helper/custom_log.dart';
import '../../model/list_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late FetchDataDetails fetchDataDetails;
  HomeBloc() : super(HomeInitial()) {
    fetchDataDetails = FetchDataDetails();
    on<FetchListEvent>((event, emit) async {
      await mapFetchListEvent(event, emit);
    });
  }

  Future<void> mapFetchListEvent(
      FetchListEvent event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeLoading());
      var response = await fetchDataDetails.fetchDetails();
      var jsonDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<ListData> listData = [];
        for (int i = 0; i < jsonDecoded.length; i++) {
          listData.add(ListData.fromJson(jsonDecoded[i]));
        }
        emit(FetchHomeSuccess(listData: listData));
      } else if (response.statusCode == 200) {
        emit(const FetchHomeFailed());
      } else {
        emit(const FetchHomeFailed());
      }
    } catch (error) {
      customLog("The error is : $error");
      emit(const FetchHomeFailed());
    }
  }
}
