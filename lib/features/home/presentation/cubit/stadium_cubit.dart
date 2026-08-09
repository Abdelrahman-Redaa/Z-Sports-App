import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/features/home/data/repositories/stadium_repository.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  final StadiumRepository _repository;

  StadiumCubit(this._repository) : super(StadiumInitial());

  Future<void> loadAll() async {
    emit(StadiumLoading());
    try {
      final results = await Future.wait([
        _repository.getAllStadiums(),
        _repository.getCategories(),
      ]);
      final stadiums = results[0] as dynamic;
      final categories = results[1] as dynamic;
      emit(StadiumLoaded(
        stadiums: stadiums,
        filtered: stadiums,
        categories: categories,
        selectedCategoryId: null,
      ));
    } catch (e) {
      emit(StadiumError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loadStadiumById(int id) async {
    emit(StadiumDetailLoading());
    try {
      final stadium = await _repository.getStadiumById(id);
      emit(StadiumDetailLoaded(stadium));
    } catch (e) {
      emit(StadiumError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void filterByCategory(int? categoryId) {
    final current = state;
    if (current is! StadiumLoaded) return;

    if (categoryId == null) {
      emit(StadiumLoaded(
        stadiums: current.stadiums,
        filtered: current.stadiums,
        categories: current.categories,
        selectedCategoryId: null,
      ));
      return;
    }

    final filtered = current.stadiums
        .where((s) => s.category.isNotEmpty)
        .toList();

    emit(StadiumLoaded(
      stadiums: current.stadiums,
      filtered: filtered,
      categories: current.categories,
      selectedCategoryId: categoryId,
    ));
  }

  Future<void> filterByCategoryFromApi(int categoryId) async {
    final current = state;
    if (current is! StadiumLoaded) return;

    try {
      final filtered = await _repository.searchStadiums(categoryId: categoryId);
      emit(StadiumLoaded(
        stadiums: current.stadiums,
        filtered: filtered,
        categories: current.categories,
        selectedCategoryId: categoryId,
      ));
    } catch (e) {
      emit(StadiumError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> clearFilter() async {
    final current = state;
    if (current is! StadiumLoaded) return;
    emit(StadiumLoaded(
      stadiums: current.stadiums,
      filtered: current.stadiums,
      categories: current.categories,
      selectedCategoryId: null,
    ));
  }
}
