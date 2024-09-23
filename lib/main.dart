import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pkk/presentation/pages/splash_screen.dart';
import 'package:pkk/provider/kegiatan_absensi_provider.dart';
import 'package:pkk/provider/anggota_provider.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:pkk/provider/kas_provider.dart';
import 'package:pkk/provider/kegiatan_iuran_provider.dart';
import 'package:pkk/provider/user_absence_provider.dart';
import 'package:pkk/provider/user_iuran_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [Permission.manageExternalStorage, Permission.storage].request();
  initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BerandaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnggotaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KasProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KegiatanAbsensiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KegiatanIuranProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAbsenceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserIuranProvider(),
        )
      ],
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'NunitoSans',
            brightness: Brightness.light,
            primaryColor: const Color(0xFFF0CC70),
            primaryColorDark: const Color(0xFFFF440A), // prime color
            dialogTheme: const DialogTheme(backgroundColor: Color(0xFFD9DBE3)),
            textTheme: const TextTheme(
              displayLarge: TextStyle(),
              displayMedium: TextStyle(),
              displaySmall: TextStyle(),
              headlineLarge: TextStyle(),
              headlineMedium: TextStyle(),
              headlineSmall: TextStyle(),
              titleLarge: TextStyle(),
              titleMedium: TextStyle(),
              titleSmall: TextStyle(),
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
              bodySmall: TextStyle(),
              labelLarge: TextStyle(),
              labelMedium: TextStyle(),
              labelSmall: TextStyle(),
            ).apply(
              bodyColor: const Color(0xFF404C61),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xFFD9D9D9), // secondary color
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFFFF440A),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFFFFFFFF),
                ),
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFFFF440A),
                ),
              ),
            ),
            dividerTheme: const DividerThemeData(color: Color(0xFFFF440A)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
