import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;
  final ProfileCubit _profileCubit;

  FavoritesCubit(this._repository, this._profileCubit)
    : super(const FavoritesInitial());

  bool isFavorite(String pitchId) => state.isFavorite(pitchId);

  Future<void> loadFavorites({bool showLoading = true}) async {
    if (showLoading) {
      emit(FavoritesLoading(state.favoriteIds));
    }
    try {
      final favorites = await _repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
  }

  Future<void> toggleFavorite(String pitchId) async {
    final intId = int.tryParse(pitchId);
    if (intId == null) {
      return;
    }

    final isCurrentlyFavorite = state.isFavorite(pitchId);

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

    try {
      if (isCurrentlyFavorite) {
        await _repository.removeFavorite(intId);
      } else {
        await _repository.addFavorite(intId);
      }
      await Future.wait([
        loadFavorites(showLoading: false),
        _profileCubit.getProfile(),
      ]);
    } catch (e) {
      await loadFavorites(showLoading: false);
      emit(FavoritesError(e.toString(), state.favoriteIds));
    }
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
