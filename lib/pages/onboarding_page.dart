import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int currentPage = 0;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "Bem-vindo ao\nNews Moz",
      description: "Mantenha-se atualizado com as últimas notícias de Moçambique e do mundo, tudo em um só lugar.",
      image: "Images/onboarding1.png",
      color: const Color(0xFFC7A87B),
    ),
    OnboardingItem(
      title: "Notícias\nPersonalizadas",
      description: "Escolha suas categorias favoritas e receba conteúdo personalizado baseado nos seus interesses.",
      image: "Images/onboarding2.png",
      color: const Color(0xFF8B5E3C),
    ),
    OnboardingItem(
      title: "Conteúdo\nPremium",
      description: "Acesse artigos exclusivos, análises aprofundadas e conteúdo premium dos melhores jornalistas.",
      image: "Images/onboarding3.png",
      color: const Color(0xFFC7A87B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _navigateToLogin(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pular',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: onboardingItems.length,
                itemBuilder: (context, index) {
                  return buildOnboardingPage(onboardingItems[index]);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingItems.length,
                      (index) => buildDot(index),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Next/Get Started button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          onboardingItems[currentPage].color,
                          onboardingItems[currentPage].color.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: onboardingItems[currentPage].color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentPage < onboardingItems.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _navigateToLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentPage < onboardingItems.length - 1 
                                ? 'Continuar' 
                                : 'Começar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have account
                  GestureDetector(
                    onTap: () => _navigateToLogin(),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                        children: [
                          TextSpan(text: 'Já tem uma conta? '),
                          TextSpan(
                            text: 'Fazer login',
                            style: TextStyle(
                              color: Color(0xFFC7A87B),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(140),
              border: Border.all(
                color: item.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  _getIconForPage(currentPage),
                  size: 100,
                  color: item.color,
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF333333).withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentPage == index 
            ? onboardingItems[currentPage].color 
            : const Color(0xFFC7A87B).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  IconData _getIconForPage(int page) {
    switch (page) {
      case 0:
        return Icons.newspaper;
      case 1:
        return Icons.tune;
      case 2:
        return Icons.workspace_premium;
      default:
        return Icons.newspaper;
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}