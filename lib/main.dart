import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/favorite_viewmodel.dart';
import 'views/splash/splash_view.dart';

void main() {
  // Ensure that Flutter engine is fully initialized before starting SQLite/SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
      ],
      child: const ApexStoreApp(),
    ),
  );
}

class ApexStoreApp extends StatelessWidget {
  const ApexStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ApexStore',
      debugShowCheckedModeBanner: false,
      
      // Modern Custom Theme Design System
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF5A4FCF), // Modern Royal Purple
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A4FCF),
          primary: const Color(0xFF5A4FCF),
          secondary: const Color(0xFF7E75ED),
          surface: const Color(0xFFF8F9FD), // Soft background color
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        
        // Customized AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1E1E24)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1E1E24),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Premium typography configurations
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF1E1E24), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF666666)),
        ),
      ),
      
      // Start with Splash Screen
      home: const SplashView(),
    );
  }
}
