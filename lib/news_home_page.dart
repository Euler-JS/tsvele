import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/Model/news_model.dart';
import 'package:news_app/Model/api_news_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/news_detail.dart';
import 'package:news_app/pages/profile_page.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> with TickerProviderStateMixin {
  String selectedCategory = "All";
  List<Yournews> filteredNews = newsItems;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Estados da API
  List<ApiNewsModel> featuredNews = [];
  List<ApiNewsModel> apiNews = [];
  List<ApiNewsModel> recentNews = [];
  List<ApiNewsModel> mostReadNews = [];
  List<CategoryModel> categories = [];
  bool isLoadingFeatured = true;
  bool isLoadingNews = true;
  bool isLoadingRecent = true;
  bool isLoadingMostRead = true;
  bool isLoadingCategories = true;
  String? errorMessage;
  String? errorMostRead;
  
  // Stats do usuário simulados
  int articlesReadToday = 5;
  int readingStreak = 7;
  int totalArticlesRead = 142;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    
    // Carregar dados da API
    _loadFeaturedNews();
    _loadCategories();
    _loadAllNews();
    _loadRecentNews();
    _loadMostReadNews();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void filterNewsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        filteredNews = newsItems;
      } else {
        filteredNews = NewsHelper.getNewsByCategory(category);
      }
    });
  }

  // Métodos para carregar dados da API
  Future<void> _loadFeaturedNews() async {
    try {
      setState(() {
        isLoadingFeatured = true;
        errorMessage = null;
      });
      
      final news = await ApiService.getFeaturedNews();
      setState(() {
        featuredNews = news;
        isLoadingFeatured = false;
      });
    } catch (e) {
      setState(() {
        isLoadingFeatured = false;
        errorMessage = e.toString();
      });
      print('Erro ao carregar notícias em destaque: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        isLoadingCategories = true;
      });
      
      final categoryList = await ApiService.getCategories();
      setState(() {
        categories = categoryList;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCategories = false;
      });
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _loadAllNews() async {
    try {
      setState(() {
        isLoadingNews = true;
      });
      
      final response = await ApiService.getAllNews(page: 1, perPage: 20);
      final newsList = response['news'] as List<ApiNewsModel>;
      
      setState(() {
        apiNews = newsList;
        isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        isLoadingNews = false;
      });
      print('Erro ao carregar notícias: $e');
    }
  }

  Future<void> _loadRecentNews() async {
    try {
      setState(() {
        isLoadingRecent = true;
      });
      
      final news = await ApiService.getRecentNews();
      setState(() {
        recentNews = news;
        isLoadingRecent = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRecent = false;
      });
      print('Erro ao carregar notícias recentes: $e');
    }
  }

  Future<void> _loadMostReadNews() async {
    try {
      setState(() {
        isLoadingMostRead = true;
        errorMostRead = null;
      });
      
      final news = await ApiService.getMostReadNews();
      setState(() {
        mostReadNews = news;
        isLoadingMostRead = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMostRead = false;
        errorMostRead = e.toString();
      });
      print('Erro ao carregar notícias mais lidas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshContent,
          color: const Color(0xFFC7A87B),
          child: CustomScrollView(
            slivers: [
              // Header compacto e moderno
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: buildModernHeader(),
                ),
              ),
              
              // Stats do usuário
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_fadeAnimation),
                  child: buildUserStats(),
                ),
              ),
              
              // Breaking News (se houver)
              SliverToBoxAdapter(
                child: buildBreakingNews(),
              ),
              
              // Carrossel de destaque modernizado
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: EnhancedFeaturedCarousel(
                    featuredNews: featuredNews,
                    isLoading: isLoadingFeatured,
                    errorMessage: errorMessage,
                  ),
                ),
              ),
              
              // Hot Topics modernizado
              SliverToBoxAdapter(
                child: buildModernHotTopics(),
              ),
              
              // Seção "Para Você" personalizada
              SliverToBoxAdapter(
                child: buildForYouSection(),
              ),
              
              // Recentes modernizado
              SliverToBoxAdapter(
                child: buildEnhancedRecentNews(),
              ),
              
              // Mais Lidas modernizado
              SliverToBoxAdapter(
                child: buildEnhancedMostRead(),
              ),
              
              // Espaço final
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshContent() async {
    // Recarregar dados da API
    await Future.wait([
      _loadFeaturedNews(),
      _loadAllNews(),
      _loadRecentNews(),
      _loadMostReadNews(),
    ]);
    
    setState(() {
      articlesReadToday += 1;
    });
  }

  Widget buildModernHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          // Header principal
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olá, Silva! 👋",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Explore",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notification badge
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: const Color(0xFF666666),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC7A87B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile button modernizado
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFC7A87B),
                        Color(0xFF8B5E3C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC7A87B).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Barra de pesquisa modernizada
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar notícias...",
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                  color: Color(0xFFC7A87B),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7A87B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC7A87B),
            Color(0xFF8B5E3C),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC7A87B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Suas Estatísticas Hoje',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '$articlesReadToday',
                  'Artigos Lidos',
                  Icons.article,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '$readingStreak',
                  'Dias Seguidos',
                  Icons.local_fire_department,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '$totalArticlesRead',
                  'Total Lidos',
                  Icons.library_books,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildBreakingNews() {
    // Simula notícia urgente
    return GestureDetector(
      onTap: () {
        // Criar uma notícia fictícia para a breaking news
        final breakingNews = Yournews(
          image: "assets/image/tsevele_logo.png",
          newsImage: "assets/image/tsevele_logo.png",
          newsTitle: 'Nova descoberta arqueológica em Sofala',
          newsCategories: "URGENTE",
          time: "agora",
          date: "14 de agosto de 2025",
          color: Colors.red,
          description: "Arqueólogos descobriram artefactos importantes em Sofala que podem mudar nossa compreensão da história da região.",
          fullContent: "Uma equipa de arqueólogos internacionais, em colaboração com especialistas moçambicanos, fez uma descoberta extraordinária na província de Sofala. Os artefactos encontrados incluem cerâmica antiga, ferramentas de pedra e possíveis inscrições que datam de vários séculos atrás.\n\nA descoberta está a ser considerada como uma das mais importantes da década na região, prometendo revelar novos aspectos da história e cultura dos povos que habitaram esta área.\n\nOs especialistas estão ainda a analisar os achados, mas as primeiras indicações sugerem que estes artefactos podem fornecer informações valiosas sobre as rotas comerciais antigas e as práticas culturais das comunidades locais.\n\nO Ministério da Cultura e Turismo já foi informado sobre a descoberta e estão a ser tomadas medidas para proteger o sítio arqueológico.",
          isPremium: false,
          views: 5420,
          isBookmarked: false,
          isFeatured: true,
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(news: breakingNews),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'URGENTE',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Nova descoberta arqueológica em Sofala',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget buildModernHotTopics() {
    List<String> categories = ["All", "World", "Tech", "Music", "Travel", "Fashion"];
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7A87B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFC7A87B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Hot Topics",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Ver todos",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC7A87B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                
                return GestureDetector(
                  onTap: () => filterNewsByCategory(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: isSelected ? const LinearGradient(
                        colors: [Color(0xFFC7A87B), Color(0xFF8B5E3C)],
                      ) : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected 
                              ? const Color(0xFFC7A87B).withOpacity(0.3)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF666666),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForYouSection() {
    final forYouNews = newsItems.take(2).toList();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5E3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF8B5E3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Para Você",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7A87B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 0),
              itemCount: forYouNews.length,
              itemBuilder: (context, index) {
                return buildEnhancedNewsCard(forYouNews[index], isPersonalized: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnhancedRecentNews() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Recentes",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Ver todas",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC7A87B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Loading state
          if (isLoadingRecent)
            Container(
              height: 280,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFC7A87B),
                ),
              ),
            )
          
          // Error state
          else if (recentNews.isEmpty && !isLoadingRecent)
            Container(
              height: 280,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Nenhuma notícia recente encontrada",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Success state with data
          else
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 0),
                itemCount: recentNews.length,
                itemBuilder: (context, index) {
                  return buildApiNewsCard(recentNews[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildEnhancedMostRead() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Mais Lidas",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Ver todas",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC7A87B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoadingMostRead)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFFC7A87B),
                ),
              ),
            )
          else if (errorMostRead != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Erro ao carregar notícias mais lidas',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else if (mostReadNews.isEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Nenhuma notícia encontrada',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mostReadNews.length > 5 ? 5 : mostReadNews.length,
              itemBuilder: (context, index) {
                final news = mostReadNews[index];
                return buildApiHorizontalCard(news, index + 1);
              },
            ),
        ],
      ),
    );
  }

  Widget buildEnhancedNewsCard(Yournews news, {bool isPersonalized = false}) {
    return GestureDetector(
      onTap: () {
        NewsHelper.incrementViews(news);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(news: news),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(news.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Gradient overlay
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                
                // Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      if (isPersonalized)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5E3C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Para Você",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isPersonalized) const SizedBox(width: 6),
                      if (news.views > 2000)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "TRENDING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                if (news.isPremium)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7A87B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: news.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        news.newsCategories,
                        style: TextStyle(
                          color: news.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      news.newsTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${news.views}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildApiNewsCard(ApiNewsModel news, {bool isPersonalized = false}) {
    return GestureDetector(
      onTap: () {
        // Incrementar views na API
        ApiService.incrementViews(news.id);
        
        // Converter ApiNewsModel para Yournews para usar a tela de detalhes existente
        final convertedNews = Yournews(
          image: news.getImageUrl(),
          newsImage: news.getImageUrl(),
          newsTitle: news.title,
          newsCategories: news.newsCategories,
          time: news.getTimeAgo(),
          date: news.formatDate(),
          color: news.getCategoryColor(),
          description: news.description,
          fullContent: news.description,
          isPremium: news.isPremiumContent,
          views: news.totalViews,
          isBookmarked: news.isBookmarked,
          isFeatured: news.isFeatured,
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(news: convertedNews),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(news.getImageUrl()),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Fallback para imagem padrão se falhar
                      },
                    ),
                  ),
                  child: news.getImageUrl().contains('assets/') 
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/placeholder.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : null,
                ),
                
                // Gradient overlay
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                
                // Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      if (isPersonalized)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5E3C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Para Você",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isPersonalized) const SizedBox(width: 6),
                      if (news.totalViews > 2000)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "TRENDING",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (news.isVideo)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "VÍDEO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (news.isAudio)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "ÁUDIO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                if (news.isPremiumContent)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7A87B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: news.getCategoryColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        news.newsCategories,
                        style: TextStyle(
                          color: news.getCategoryColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${news.totalViews}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news.getTimeAgo(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEnhancedHorizontalCard(Yournews news, int ranking) {
    return GestureDetector(
      onTap: () {
        NewsHelper.incrementViews(news);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(news: news),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: ranking <= 3 
                    ? LinearGradient(
                        colors: ranking == 1 
                            ? [Colors.amber, Colors.orange]
                            : ranking == 2 
                                ? [Colors.grey, Colors.grey.shade400]
                                : [Colors.brown, Colors.brown.shade400],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFC7A87B), Color(0xFF8B5E3C)],
                      ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: ranking <= 3 
                    ? Icon(
                        ranking == 1 ? Icons.emoji_events : Icons.star,
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        "$ranking",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(news.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          news.newsTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (news.isPremium)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7A87B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Premium",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: news.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          news.newsCategories,
                          style: TextStyle(
                            color: news.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${news.views}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      Text(
                        news.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildApiHorizontalCard(ApiNewsModel news, int ranking) {
    return GestureDetector(
      onTap: () {
        // Incrementar views na API
        ApiService.incrementViews(news.id);
        
        // Converter ApiNewsModel para Yournews para usar a tela de detalhes existente
        final convertedNews = Yournews(
          image: news.getImageUrl(),
          newsImage: news.getImageUrl(),
          newsTitle: news.title,
          newsCategories: news.newsCategories,
          time: news.getTimeAgo(),
          date: news.formatDate(),
          color: news.getCategoryColor(),
          description: news.description,
          fullContent: news.description,
          isPremium: news.isPremiumContent,
          views: news.totalViews,
          isBookmarked: news.isBookmarked,
          isFeatured: news.isFeatured,
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(news: convertedNews),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: ranking <= 3 
                    ? LinearGradient(
                        colors: ranking == 1 
                            ? [Colors.amber, Colors.orange]
                            : ranking == 2 
                                ? [Colors.grey, Colors.grey.shade400]
                                : [Colors.brown, Colors.brown.shade400],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFC7A87B), Color(0xFF8B5E3C)],
                      ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: ranking <= 3 
                    ? Icon(
                        ranking == 1 ? Icons.emoji_events : Icons.star,
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        "$ranking",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news.getImageUrl(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image,
                        color: Colors.grey.shade400,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (news.isPremiumContent)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7A87B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Premium",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: news.getCategoryColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          news.newsCategories,
                          style: TextStyle(
                            color: news.getCategoryColor(),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${news.totalViews}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      Text(
                        news.getTimeAgo(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Carrossel melhorado com dados da API
class EnhancedFeaturedCarousel extends StatefulWidget {
  final List<ApiNewsModel> featuredNews;
  final bool isLoading;
  final String? errorMessage;

  const EnhancedFeaturedCarousel({
    super.key,
    required this.featuredNews,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  State<EnhancedFeaturedCarousel> createState() => _EnhancedFeaturedCarouselState();
}

class _EnhancedFeaturedCarouselState extends State<EnhancedFeaturedCarousel> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Em Destaque",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Loading state
          if (widget.isLoading)
            Container(
              height: 300,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC7A87B)),
                ),
              ),
            )
          
          // Error state
          else if (widget.errorMessage != null)
            Container(
              height: 300,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar notícias',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque para tentar novamente',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Empty state
          else if (widget.featuredNews.isEmpty)
            Container(
              height: 300,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma notícia em destaque',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          
          // Success state with data
          else
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: widget.featuredNews.length,
                itemBuilder: (context, index) {
                  final news = widget.featuredNews[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(news.getImageUrl()),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                // Em caso de erro, usar imagem padrão
                              },
                            ),
                          ),
                          child: news.getImageUrl().contains('placeholder') 
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        
                        // Badges de Premium e Video/Audio
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Row(
                            children: [
                              if (news.isPremiumContent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC7A87B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Premium",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              if (news.isVideo)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.play_arrow, color: Colors.white, size: 12),
                                      SizedBox(width: 2),
                                      Text(
                                        "VÍDEO",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (news.isAudio)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.headphones, color: Colors.white, size: 12),
                                      SizedBox(width: 2),
                                      Text(
                                        "ÁUDIO",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        // Conteúdo
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (news.category != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: news.getCategoryColor().withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    news.category!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              
                              const SizedBox(height: 12),
                              
                              Text(
                                news.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              Text(
                                news.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 12),
                              
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${news.totalViews}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    news.getTimeAgo(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              ElevatedButton(
                                onPressed: () {
                                  // Incrementar views na API
                                  ApiService.incrementViews(news.id);
                                  
                                  // Converter ApiNewsModel para Yournews para usar a tela de detalhes existente
                                  final convertedNews = Yournews(
                                    image: news.getImageUrl(),
                                    newsImage: news.getImageUrl(),
                                    newsTitle: news.title,
                                    newsCategories: news.newsCategories,
                                    time: news.getTimeAgo(),
                                    date: news.formatDate(),
                                    color: news.getCategoryColor(),
                                    description: news.description,
                                    fullContent: news.description,
                                    isPremium: news.isPremiumContent,
                                    views: news.totalViews,
                                    isBookmarked: news.isBookmarked,
                                    isFeatured: news.isFeatured,
                                  );
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailNews(news: convertedNews),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC7A87B),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Ler Agora",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          
          // Indicadores de página
          if (!widget.isLoading && widget.featuredNews.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.featuredNews.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index 
                          ? const Color(0xFFC7A87B) 
                          : const Color(0xFFC7A87B).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}