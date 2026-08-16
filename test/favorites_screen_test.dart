import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/favorites/data/repositories/favorites_repository.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/favorites_screen.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';

class _FakeFavoritesRepository extends FavoritesRepository {
  _FakeFavoritesRepository() : super(DI.apiClient);

  @override
  Future<List<PitchModel>> getFavorites() async {
    return const [
      PitchModel(
        id: '1',
        name: 'ملعب الملوك',
        imageUrl: '',
        rating: 4.8,
        reviewCount: 12,
        pricePerHour: 250,
        location: 'القاهرة',
        distance: '2 كم',
        category: 'كرة قدم',
        amenities: [],
        description: '',
      ),
    ];
  }

  @override
  Future<void> addFavorite(int stadiumId) async {}

  @override
  Future<void> removeFavorite(int stadiumId) async {}
}

void main() {
  testWidgets('FavoritesScreen pumps and shows card', (tester) async {
    final profileCubit = ProfileCubit(DI.profileRepository);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LanguageCubit()),
          BlocProvider.value(value: profileCubit),
          BlocProvider(
            create: (_) =>
                FavoritesCubit(_FakeFavoritesRepository(), profileCubit),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: FavoritesScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.text('ملعب الملوك'), findsOneWidget);
    expect(find.text('احجز الآن'), findsOneWidget);
  });
}
