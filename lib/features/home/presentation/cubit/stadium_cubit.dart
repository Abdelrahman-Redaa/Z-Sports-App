import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/data/models/category_model.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
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
      final stadiums = results[0] as List<PitchModel>;
      final categories = results[1] as List<CategoryModel>;
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

  void filterByCategory(int categoryId, String categoryName) {
    final current = state;
    if (current is! StadiumLoaded) return;

    final filtered = current.stadiums.where((s) {
      return s.category.toLowerCase().contains(categoryName.toLowerCase()) ||
          categoryName.toLowerCase().contains(s.category.toLowerCase());
    }).toList();

    emit(StadiumLoaded(
      stadiums: current.stadiums,
      filtered: filtered,
      categories: current.categories,
      selectedCategoryId: categoryId,
    ));
  }

  void clearFilter() {
    final current = state;
    if (current is! StadiumLoaded) return;
    emit(StadiumLoaded(
      stadiums: current.stadiums,
      filtered: current.stadiums,
      categories: current.categories,
      selectedCategoryId: null,
    ));
  }

  void searchLocally(String query) {
    final current = state;
    if (current is! StadiumLoaded) return;

    if (query.trim().isEmpty) {
      emit(StadiumLoaded(
        stadiums: current.stadiums,
        filtered: current.stadiums,
        categories: current.categories,
        selectedCategoryId: null,
      ));
      return;
    }

    final lower = query.toLowerCase();
    final filtered = current.stadiums.where((s) {
      return s.name.toLowerCase().contains(lower) ||
          s.location.toLowerCase().contains(lower) ||
          s.category.toLowerCase().contains(lower);
    }).toList();

    emit(StadiumLoaded(
      stadiums: current.stadiums,
      filtered: filtered,
      categories: current.categories,
      selectedCategoryId: current.selectedCategoryId,
    ));
  }
}
