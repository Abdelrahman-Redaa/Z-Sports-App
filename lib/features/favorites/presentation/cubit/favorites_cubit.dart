import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;
  
  // Cache of favorite IDs for quick synchronous checks globally
  final Set<String> _favoriteIds = {};

  FavoritesCubit(this._repository) : super(FavoritesInitial());

  bool isFavorite(String pitchId) => _favoriteIds.contains(pitchId);

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await _repository.getFavorites();
      _favoriteIds.clear();
      _favoriteIds.addAll(favorites.map((e) => e.id));
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String pitchId) async {
    final intId = int.tryParse(pitchId);
    if (intId == null) return;

    final isCurrentlyFavorite = _favoriteIds.contains(pitchId);
    
    // Optimistic update
    if (isCurrentlyFavorite) {
      _favoriteIds.remove(pitchId);
    } else {
      _favoriteIds.add(pitchId);
    }
    
    // Emit new state if we are already loaded so UI updates
    if (state is FavoritesLoaded) {
      final currentList = (state as FavoritesLoaded).favorites;
      if (isCurrentlyFavorite) {
        emit(FavoritesLoaded(currentList.where((p) => p.id != pitchId).toList()));
      } else {
        // Normally we'd want the full object, but since we are optimistically updating,
        // we might not have it. The best way is to reload.
        emit(FavoritesLoaded(currentList)); 
        // We trigger a background refresh to get the real item if added
      }
    }

    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(intId);
      } else {
        await _repository.addFavorite(intId);
      }
      // Reload to ensure list is perfectly in sync with server
      loadFavorites();
    } catch (e) {
      // Revert on error
      if (isCurrentlyFavorite) {
        _favoriteIds.add(pitchId);
      } else {
        _favoriteIds.remove(pitchId);
      }
      loadFavorites();
      emit(FavoritesError(e.toString()));
    }
  }
}
