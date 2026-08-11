import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesInitial());

  bool isFavorite(String pitchId) => state.isFavorite(pitchId);

  Future<void> loadFavorites() async {
    // ignore: avoid_print
    print('🔵 [FavoritesCubit] loadFavorites() called. Current state: $state');
    emit(FavoritesLoading(state.favoriteIds));
    try {
      final favorites = await _repository.getFavorites();
      // ignore: avoid_print
      print('🟢 [FavoritesCubit] Loaded ${favorites.length} favorites');
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      // ignore: avoid_print
      print('🔴 [FavoritesCubit] loadFavorites error: $e');
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
  }

  Future<void> toggleFavorite(String pitchId) async {
    final intId = int.tryParse(pitchId);
    // ignore: avoid_print
    print('🔵 [FavoritesCubit] toggleFavorite("$pitchId") intId=$intId');
    if (intId == null) {
      // ignore: avoid_print
      print('🔴 [FavoritesCubit] pitchId "$pitchId" is not a valid int - aborting');
      return;
    }

    final isCurrentlyFavorite = state.isFavorite(pitchId);
    // ignore: avoid_print
    print('🔵 [FavoritesCubit] isCurrentlyFavorite=$isCurrentlyFavorite');

    // Optimistic update: flip the icon immediately
    final newIds = Set<String>.from(state.favoriteIds);
    if (isCurrentlyFavorite) {
      newIds.remove(pitchId);
    } else {
      newIds.add(pitchId);
    }

    final currentList = state is FavoritesLoaded
        ? List<PitchModel>.from((state as FavoritesLoaded).favorites)
        : <PitchModel>[];

    if (isCurrentlyFavorite) {
      final updated = currentList.where((p) => p.id != pitchId).toList();
      emit(_OptimisticLoaded(updated, newIds));
    } else {
      emit(_OptimisticLoaded(currentList, newIds));
    }
    // ignore: avoid_print
    print('🟢 [FavoritesCubit] Optimistic state emitted. New favoriteIds: $newIds');

    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(intId);
        // ignore: avoid_print
        print('🟢 [FavoritesCubit] removeFavorite() succeeded');
      } else {
        await _repository.addFavorite(intId);
        // ignore: avoid_print
        print('🟢 [FavoritesCubit] addFavorite() succeeded');
      }
      await loadFavorites();
    } catch (e) {
      // ignore: avoid_print
      print('🔴 [FavoritesCubit] toggleFavorite error, reverting: $e');
      await loadFavorites();
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
  }

  void _emitOptimistic(List<PitchModel> list, Set<String> ids) {
    emit(_OptimisticLoaded(list, ids));
  }
}

class _OptimisticLoaded extends FavoritesState {
  final List<PitchModel> favorites;
  _OptimisticLoaded(this.favorites, Set<String> ids) : super(ids);
}

extension FavoritesStateX on FavoritesState {
  List<PitchModel>? get favoriteList {
    if (this is FavoritesLoaded) return (this as FavoritesLoaded).favorites;
    if (this is _OptimisticLoaded) return (this as _OptimisticLoaded).favorites;
    return null;
  }

  bool get isLoading => this is FavoritesLoading;
  bool get hasError => this is FavoritesError;
  String? get errorMessage =>
      this is FavoritesError ? (this as FavoritesError).message : null;
}
