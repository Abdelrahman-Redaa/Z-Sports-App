import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesInitial());

  /// Quick synchronous check — reads from the current state's favoriteIds set
  bool isFavorite(String pitchId) => state.isFavorite(pitchId);

  Future<void> loadFavorites() async {
    emit(FavoritesLoading(state.favoriteIds));
    try {
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      // ignore: avoid_print
      print('🔴 loadFavorites error: $e');
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
  }

  Future<void> toggleFavorite(String pitchId) async {
    final intId = int.tryParse(pitchId);
    if (intId == null) return;

    final isCurrentlyFavorite = state.isFavorite(pitchId);

    // ── Optimistic UI update immediately ──────────────────────────────────
    final newIds = Set<String>.from(state.favoriteIds);
    if (isCurrentlyFavorite) {
      newIds.remove(pitchId);
    } else {
      newIds.add(pitchId);
    }

    // Rebuild the favorites list optimistically
    final currentList = state is FavoritesLoaded
        ? List<PitchModel>.from((state as FavoritesLoaded).favorites)
        : <PitchModel>[];

    if (isCurrentlyFavorite) {
      final updated = currentList.where((p) => p.id != pitchId).toList();
      _emitOptimistic(updated, newIds);
    } else {
      // Adding: keep list as-is; server reload will add the item
      _emitOptimistic(currentList, newIds);
    }
    // ─────────────────────────────────────────────────────────────────────

    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(intId);
      } else {
        await _repository.addFavorite(intId);
      }
      // Sync with server to get accurate data
      await loadFavorites();
    } catch (e) {
      // ignore: avoid_print
      print('🔴 toggleFavorite error: $e');
      // Revert optimistic update
      await loadFavorites();
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
  }

  void _emitOptimistic(List<PitchModel> list, Set<String> ids) {
    // Use a synthetic FavoritesLoaded that carries the given ids set
    emit(_OptimisticLoaded(list, ids));
  }
}

/// Private subclass that allows decoupling favoriteIds from the actual list
class _OptimisticLoaded extends FavoritesState {
  final List<PitchModel> favorites;

  _OptimisticLoaded(this.favorites, Set<String> ids) : super(ids);
}

/// Re-export helper so screens can still use FavoritesLoaded
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
