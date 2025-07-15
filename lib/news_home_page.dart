import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/Model/news_model.dart';
import 'package:news_app/news_detail.dart';
import 'package:news_app/pages/profile_page.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String selectedCategory = "All";
  List<Yournews> filteredNews = newsItems;

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

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFFFFF),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
    left: 20, 
    top: MediaQuery.of(context).padding.top + 40, // <- Espaçamento dinâmico
  ),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100), // Adicionado padding inferior
          children: [
            // Header com saudação e perfil
            buildHeader(),
            const SizedBox(height: 12),
            
            // Barra de pesquisa
            searchBar(),
            const SizedBox(height: 25),
            
            // Carrossel de destaque
            const FeaturedNewsCarousel(),
            const SizedBox(height: 30),
            
            // Seção Hot Topics
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Color(0xFFC7A87B),
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Hot Topics",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Ver todos",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC7A87B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            
            // Categorias clicáveis
            buildCategoriesSection(),
            const SizedBox(height: 25),
            
            // Seção Notícias Recentes
            buildRecentNewsSection(),
            const SizedBox(height: 25),
            
            // Seção Mais Lidas
            buildMostReadSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

  // Header com saudação e botão de perfil
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          // Saudação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Olá, João! 👋",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF333333).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Explore",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          
          // Botão de perfil
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
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC7A87B).withOpacity(0.3),
                    blurRadius: 8,
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
    );
  }

  // Barra de pesquisa atualizada
  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFC7A87B).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Center(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Pesquisar notícias...",
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 24,
                color: Color(0xFFC7A87B),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // Categorias clicáveis
  Widget buildCategoriesSection() {
    List<String> categories = ["All", "World", "Tech", "Music", "Travel", "Fashion"];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          
          return GestureDetector(
            onTap: () => filterNewsByCategory(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFFC7A87B) 
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected 
                      ? const Color(0xFFC7A87B) 
                      : const Color(0xFFC7A87B).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : const Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Seção Notícias Recentes
  Widget buildRecentNewsSection() {
    final recentNews = NewsHelper.getRecentNews();
    
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: Color(0xFFC7A87B),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                "Recentes",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Spacer(),
              Text(
                "Ver todas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC7A87B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        
        // Grid de notícias
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentNews.length,
            itemBuilder: (context, index) {
              final news = recentNews[index];
              return buildNewsCard(news);
            },
          ),
        ),
      ],
    );
  }

  // Seção Mais Lidas
  Widget buildMostReadSection() {
    final mostReadNews = NewsHelper.getMostReadNews().take(3).toList();
    
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Color(0xFFC7A87B),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                "Mais Lidas",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Spacer(),
              Text(
                "Ver todas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC7A87B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        
        // Lista vertical das mais lidas
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mostReadNews.length,
            itemBuilder: (context, index) {
              final news = mostReadNews[index];
              return buildHorizontalNewsCard(news, index + 1);
            },
          ),
        ),
      ],
    );
  }

  // Card de notícia vertical
  Widget buildNewsCard(Yournews news) {
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
        width: 200,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(news.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Badge Premium
                if (news.isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
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
            
            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoria
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: news.color.withOpacity(0.2),
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
                  
                  const SizedBox(height: 8),
                  
                  // Título
                  Text(
                    news.newsTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Descrição
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF333333).withOpacity(0.7),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Views e tempo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 12,
                            color: const Color(0xFF333333).withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${news.views}",
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF333333).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        news.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF333333).withOpacity(0.6),
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

  // Card horizontal para mais lidas
  Widget buildHorizontalNewsCard(Yournews news, int ranking) {
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ranking
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFC7A87B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "$ranking",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Imagem
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(news.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.newsTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: news.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
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
                      
                      const SizedBox(width: 8),
                      
                      Icon(
                        Icons.visibility,
                        size: 12,
                        color: const Color(0xFF333333).withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${news.views}",
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF333333).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Premium badge
            if (news.isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7A87B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget do carrossel (incluído aqui para ser independente)
class FeaturedNewsCarousel extends StatefulWidget {
  const FeaturedNewsCarousel({super.key});

  @override
  State<FeaturedNewsCarousel> createState() => _FeaturedNewsCarouselState();
}

class _FeaturedNewsCarouselState extends State<FeaturedNewsCarousel> {
  late PageController _pageController;
  int currentPage = 0;
  List<Yournews> featuredNews = NewsHelper.getFeaturedNews();

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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20, bottom: 15),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Color(0xFFC7A87B),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                "Em Destaque",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: featuredNews.length,
            itemBuilder: (context, index) {
              final news = featuredNews[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
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
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(news.newsImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        
                        Container(
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        
                        if (news.isPremium)
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7A87B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "Premium",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        Positioned(
                          top: 15,
                          left: 15,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                NewsHelper.toggleBookmark(news);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                news.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                color: const Color(0xFF8B5E3C),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: news.color.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    news.newsCategories,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 10),
                                
                                Text(
                                  news.newsTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
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
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 15),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        NewsHelper.incrementViews(news);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailNews(news: news),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC7A87B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Ver Detalhes",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.arrow_forward, size: 16),
                                        ],
                                      ),
                                    ),
                                    
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.visibility,
                                              color: Colors.white.withOpacity(0.8),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${news.views}",
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          news.time,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
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
                ),
              );
            },
          ),
        ),
        
        if (featuredNews.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                featuredNews.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
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
    );
  }

}