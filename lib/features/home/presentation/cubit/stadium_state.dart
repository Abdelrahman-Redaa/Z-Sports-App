import 'package:z_sports_booking/data/models/category_model.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

abstract class StadiumState {}

class StadiumInitial extends StadiumState {}

class StadiumLoading extends StadiumState {}

class StadiumLoaded extends StadiumState {
  final List<PitchModel> stadiums;
  final List<PitchModel> filtered;
  final List<CategoryModel> categories;
  final int? selectedCategoryId;

  StadiumLoaded({
    required this.stadiums,
    required this.filtered,
    required this.categories,
    this.selectedCategoryId,
  });
}

class StadiumError extends StadiumState {
  final String message;
  StadiumError(this.message);
}

class StadiumDetailLoading extends StadiumState {}

class StadiumDetailLoaded extends StadiumState {
  final PitchModel stadium;
  StadiumDetailLoaded(this.stadium);
}
