import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_radio/src/api/api_provider.dart';
import 'package:private_radio/src/dashboard/dashboard.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Building the dashboard provider");
    }

    SettingsProvider settingsProvider = SettingsProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: Builder(builder: (context) {
        settingsProvider = Provider.of<SettingsProvider>(context);

        String fontName = settingsProvider.fontName.toString();
        String fontFamily = '${fontName.replaceAll(" ", "")}_regular';

        GoogleFonts.asMap()[fontName]!();

        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          theme: ThemeData.light().copyWith(
            textTheme: Typography().black.apply(
                  fontFamily: fontFamily,
                ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: Typography().white.apply(
                  fontFamily: fontFamily,
                ),
          ),
          themeMode: settingsProvider.themeMode,
          home: const Scaffold(
            body: AnimatedRoot(),
          ),
        );
      }),
    );
  }
}

class AnimatedRoot extends StatelessWidget {
  const AnimatedRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 2000),
      transitionBuilder: (child, animation) {
        return FadeScaleTransition(
          animation: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ),
          ),
          child: child,
        );
      },
      child: dashboardProvider.loaded
          ? const Dashboard()
          : Center(
              child: const CircularProgressIndicator().animate().fade(),
            ),
    );
  }
}
