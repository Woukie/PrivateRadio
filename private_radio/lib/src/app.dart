import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:private_radio/src/dashboard/dashboard.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
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

    DashboardProvider dashboardProvider = DashboardProvider();
    dashboardProvider.load();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => dashboardProvider),
      ],
      child: MaterialApp(
        restorationScopeId: 'app',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const Scaffold(
          body: LoadingWrapper(
            child: Dashboard(),
          ),
        ),
      ),
    );
  }
}

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);
    return dashboardProvider.loaded
        ? child
        : const Center(
            child: Text("Loading"),
          );
  }
}
