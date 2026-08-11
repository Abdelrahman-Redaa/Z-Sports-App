import 'package:z_sports_booking/data/models/pitch_model.dart';

abstract class FavoritesState {
  /// IDs of all currently favorited stadiums - included in EVERY state
  /// so that BlocBuilder in PitchCard always rebuilds when favorites change.
  final Set<String> favoriteIds;
  const FavoritesState(this.favoriteIds);

  bool isFavorite(String id) => favoriteIds.contains(id);
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial() : super(const {});
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading(super.favoriteIds);
}

class FavoritesLoaded extends FavoritesState {
  final List<PitchModel> favorites;
  FavoritesLoaded(this.favorites)
      : super(Set.unmodifiable(favorites.map((p) => p.id).toSet()));
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message, super.favoriteIds);
}
