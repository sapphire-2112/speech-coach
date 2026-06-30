import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/onboarding_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _onboardingCompleteFuture;

  @override
  void initState() {
    super.initState();
    _onboardingCompleteFuture = OnboardingService.isOnboardingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onboardingCompleteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                color: const Color(0xFFf7f9fb),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        // If onboarding is complete, show splash -> login
        // If onboarding is not complete, show splash -> onboarding
        final isOnboardingComplete = snapshot.data ?? false;
        final initialRoute = isOnboardingComplete ? '/splash-login' : '/splash-onboarding';

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isOnboardingComplete ? const SplashScreen(nextRoute: '/login') : const SplashScreen(nextRoute: '/onboarding'),
          routes: {
            '/splash': (context) => const SplashScreen(nextRoute: '/login'),
            '/splash-login': (context) => const SplashScreen(nextRoute: '/login'),
            '/splash-onboarding': (context) => const SplashScreen(nextRoute: '/onboarding'),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const DashboardScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
          },
        );
      },
    );
  }
}