// Para integrar as novas telas no seu app, atualize o main.dart assim:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/pages/login_page.dart';
import 'package:news_app/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        // Tema global do AppBar para resolver o problema dos títulos
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF333333),
          elevation: 0,
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: Color(0xFF333333)),
          titleTextStyle: TextStyle(
            color: Color(0xFF333333),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC7A87B),
        ),
      ),
      home: const SplashScreen(), // Tela inicial que determina o fluxo
    );
  }
}

// Tela de splash que decide qual tela mostrar primeiro
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  // Verifica se é a primeira vez que o usuário abre o app
  void _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay para mostrar splash
    
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      if (!hasSeenOnboarding) {
        // Primeira vez - mostrar onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      } else if (!isLoggedIn) {
        // Já viu onboarding mas não está logado - mostrar login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Usuário já está logado - ir direto para o app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7A87B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo do app
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.newspaper,
                color: Color(0xFFC7A87B),
                size: 60,
              ),
            ),

            const SizedBox(height: 30),

            // Nome do app
            const Text(
              'Tsevele',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Suas notícias, sempre atualizadas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),

            const SizedBox(height: 50),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Também adicione este método nas suas telas de login e signup para salvar o estado:

/* 
No login_page.dart, no método _login(), após o login bem-sucedido, adicione:

final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isLoggedIn', true);
await prefs.setBool('hasSeenOnboarding', true);

No signup_page.dart, no método _signUp(), após o cadastro bem-sucedido, adicione:

final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isLoggedIn', true);
await prefs.setBool('hasSeenOnboarding', true);

No onboarding_page.dart, no método _navigateToLogin(), adicione:

final prefs = await SharedPreferences.getInstance();
await prefs.setBool('hasSeenOnboarding', true);

Para logout, adicione um botão que faça:

final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isLoggedIn', false);
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
*/