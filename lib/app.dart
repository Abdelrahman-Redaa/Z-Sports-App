import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:z_sports_booking/core/di.dart';
import 'package:z_sports_booking/core/router/app_router.dart';
import 'package:z_sports_booking/core/theme/app_theme.dart';
import 'package:z_sports_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/profile/presentation/cubit/profile_cubit.dart';

class ZSportsApp extends StatelessWidget {
  const ZSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(DI.authRepository)),
        BlocProvider(create: (_) => ProfileCubit(DI.profileRepository)),
        BlocProvider(create: (_) => StadiumCubit(DI.stadiumRepository)),
      ],
      child: MaterialApp.router(
        title: 'Z Sports',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: appRouter,
      ),
    );
  }
}
