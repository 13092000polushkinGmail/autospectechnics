import 'package:autospectechnics/ui/navigation/main_navigation.dart';
import 'package:autospectechnics/ui/theme/app_colors.dart';
import 'package:autospectechnics/ui/theme/app_font_families.dart';
import 'package:autospectechnics/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final mainNavigation = MainNavigation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autospectechnics',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          titleTextStyle:
              AppTextStyles.semiBold.copyWith(color: AppColors.black),
          centerTitle: true,
          foregroundColor: AppColors.black,
          elevation: 1
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.greyText,
        ),
        fontFamily: AppFontFamilies.openSans,
      ),
      routes: mainNavigation.routes,
      initialRoute: MainNavigationRouteNames.mainTabsScreen,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
