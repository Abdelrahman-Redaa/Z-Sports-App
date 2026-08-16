import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/localization/language_cubit.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_theme.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/cubit/my_bookings_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:z_sports_booking/features/favorites/presentation/cubit/favorites_state.dart';

class ZSportsApp extends StatelessWidget {
  const ZSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()..loadLanguage()),
        BlocProvider(create: (_) => AuthCubit(DI.authRepository)),
        BlocProvider(create: (_) => ProfileCubit(DI.profileRepository)),
        BlocProvider(create: (_) => StadiumCubit(DI.stadiumRepository)),
        BlocProvider(create: (_) => BookingCubit(DI.bookingRepository)),
        BlocProvider(create: (_) => MyBookingsCubit(DI.myBookingsRepository)),
        BlocProvider(
          create: (ctx) =>
              FavoritesCubit(DI.favoritesRepository, ctx.read<ProfileCubit>()),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return MaterialApp.router(
            title: 'Z Sports',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: languageState.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter,
            builder: (context, child) {
              return Directionality(
                textDirection: languageState.textDirection,
                child: BlocListener<FavoritesCubit, FavoritesState>(
                  listener: (context, state) {
                    if (state is FavoritesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
