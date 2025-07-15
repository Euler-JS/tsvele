import 'package:flutter/material.dart';

class HotTopic {
  String image;
  String name;
  Color color;

  HotTopic({
    required this.color,
    required this.image,
    required this.name,
  });
}

List<HotTopic> topicItems = [
  HotTopic(
    color: const Color(0xFF8B5E3C), // Marrom suave
    image: "Images/world.png",
    name: 'World',
  ),
  HotTopic(
    color: const Color(0xFF333333), // Cinza escuro
    image: "Images/tech.png",
    name: 'Tech',
  ),
  HotTopic(
    color: const Color(0xFFC7A87B), // Bege/creme
    image: "Images/music.png",
    name: 'Music',
  ),
  HotTopic(
    color: const Color(0xFF8B5E3C), // Marrom suave
    image: "Images/travel.png",
    name: 'Travel',
  ),
  HotTopic(
    color: const Color(0xFF333333), // Cinza escuro
    image: "Images/kitchen.png",
    name: 'Kitchen',
  ),
  HotTopic(
    color: const Color(0xFFC7A87B), // Bege/creme
    image: "Images/fashion.png",
    name: 'Fashion',
  ),
];

// Modelo expandido para suas notícias
class Yournews {
  String image;
  String newsImage;
  String newsTitle;
  String newsCategories;
  String time;
  String date;
  Color color;
  String description; // Trecho curto/preview
  String fullContent; // Texto completo da notícia
  bool isPremium; // Se é conteúdo premium
  int views; // Número de visualizações
  bool isBookmarked; // Se está salvo
  bool isFeatured; // Se deve aparecer no carrossel

  Yournews({
    required this.image,
    required this.newsImage,
    required this.newsTitle,
    required this.newsCategories,
    required this.time,
    required this.date,
    required this.color,
    required this.description,
    required this.fullContent,
    this.isPremium = false,
    this.views = 0,
    this.isBookmarked = false,
    this.isFeatured = false,
  });
}

List<Yournews> newsItems = [
  Yournews(
    description: "Before embarking on a journey to travel the world, it's essential to prepare adequately to ensure a smooth and enjoyable experience.",
    fullContent: "Before embarking on a journey to travel the world, it's essential to prepare adequately to ensure a smooth and enjoyable experience. Research the countries and regions you plan to visit. Understand the local customs, languages, visa requirements, and cultural norms. This knowledge will help you navigate different environments respectfully and efficiently.\n\nCreate a detailed itinerary that includes your destinations, accommodation, transportation, and activities. While it's important to have a plan, also leave room for spontaneity and unexpected discoveries. Book essential accommodations and transportation in advance, especially for popular destinations or during peak seasons.\n\nEnsure you have all necessary travel documents, including a valid passport, visas, travel insurance, and any required vaccinations. Keep digital and physical copies of important documents in separate locations. Consider registering with your embassy or consulate in the countries you plan to visit.\n\nPack smart and light. Choose versatile clothing suitable for different climates and occasions. Don't forget essential items like medications, chargers, and a first aid kit. Remember that you can buy many items along the way, so avoid overpacking.",
    newsImage: "Images/travelling.png",
    image: "Images/news travel.png",
    newsTitle: 'What i know before travelling the world',
    newsCategories: "TRAVEL",
    date: 'Sunday 2 March 2024',
    time: '2m',
    color: const Color(0xFFC7A87B),
    views: 1250,
    isBookmarked: false,
    isFeatured: true,
    isPremium: false,
  ),
  Yournews(
    description: "Background music can greatly enhance your focus and productivity while programming. The best music for programming varies from person to person.",
    fullContent: "Background music can greatly enhance your focus and productivity while programming. The best music for programming varies from person to person, as it depends on personal preferences and what helps you concentrate.\n\nInstrumental music is often preferred because it doesn't have lyrics that might distract from coding. Genres like ambient, classical, electronic, and lo-fi hip-hop are popular choices among programmers. Many developers find that consistent, repetitive beats help maintain focus during long coding sessions.\n\nClassical music, particularly baroque compositions, can improve concentration and cognitive function. The mathematical patterns in classical music may align well with the logical thinking required for programming. Artists like Bach, Mozart, and Vivaldi are excellent choices.\n\nAmbient and electronic music provide a modern soundscape that many programmers find conducive to deep work. Artists like Brian Eno, Boards of Canada, and Tycho create atmospheric sounds that can help maintain focus without being overwhelming.\n\nThe key is to find music that doesn't compete with your attention but rather supports your mental state. Experiment with different genres and artists to find what works best for you.",
    newsImage: "Images/music program.png",
    image: "Images/programming music.png",
    newsTitle: 'Background music for programming',
    newsCategories: "MUSIC",
    date: 'Saturday 29 Nov 2023',
    time: '4h',
    color: const Color(0xFF8B5E3C),
    views: 2100,
    isBookmarked: true,
    isFeatured: true,
    isPremium: true, // Conteúdo premium
  ),
  Yournews(
    description: "That iteration of the paper served readers well for the past 17 years, but it needed to be updated. From this week, The Economist has a fresher look.",
    fullContent: "That iteration of the paper served readers well for the past 17 years, but it needed to be updated. From this week, The Economist has a fresher look, with typefaces better suited to both print and digital formats.\n\nThe redesign process involved months of careful consideration and testing. The team worked with typography experts to select fonts that would work seamlessly across different platforms and devices. The new design maintains the publication's authoritative voice while making it more accessible to modern readers.\n\nOne of the key challenges was balancing tradition with innovation. The Economist has a rich history and loyal readership that values consistency. The redesign needed to honor this legacy while embracing contemporary design principles that would attract new readers.\n\nThe new typography system includes custom fonts specifically designed for digital reading. These fonts are more legible on screens and provide better readability across various device sizes. The layout has also been optimized for mobile devices, recognizing that many readers now consume content on smartphones and tablets.\n\nThis redesign represents more than just aesthetic changes; it's a strategic move to ensure The Economist remains relevant in an increasingly digital world.",
    newsImage: "Images/design news.png",
    image: "Images/tech image.png",
    newsTitle: "How to redesign a 175-year-old newspaper",
    newsCategories: "TECH",
    date: 'Saturday 29 Nov 2019',
    time: '10h',
    color: const Color(0xFF333333),
    views: 890,
    isBookmarked: false,
    isFeatured: false,
    isPremium: true, // Conteúdo premium
  ),
  Yournews(
    description: "The term world can have different meanings depending on the context in which it is used: Planet Earth, including its land, oceans, atmosphere, and all living organisms.",
    fullContent: "The term world can have different meanings depending on the context in which it is used: Planet Earth: In a literal sense, world refers to the planet we inhabit, including its land, oceans, atmosphere, and all living organisms.\n\nFrom a geographical perspective, the world encompasses all continents, countries, and natural features. It includes the diverse ecosystems that support life, from tropical rainforests to arctic tundra, from deep ocean trenches to mountain peaks.\n\nCulturally, the world represents the collective human experience across different societies, languages, traditions, and ways of life. It's the sum of all human knowledge, art, literature, and social structures that have developed over thousands of years.\n\nEconomically, the world refers to the global marketplace where goods, services, and ideas are exchanged across borders. Globalization has made the world more interconnected than ever before, creating both opportunities and challenges for nations and individuals.\n\nFrom a philosophical standpoint, the world can be seen as our shared reality, the stage upon which human drama unfolds. It's the context for our existence and the foundation for our understanding of ourselves and our place in the universe.\n\nThe world is constantly changing, shaped by natural forces, human activities, and technological advances. Understanding our world is crucial for making informed decisions about our future.",
    newsImage: "Images/world news.png",
    image: "Images/world image.png",
    newsTitle: "Whats your openion about the world",
    newsCategories: "WORLD",
    date: 'Saturday 29 Nov 1101',
    time: '∞',
    color: const Color(0xFFC7A87B),
    views: 500,
    isBookmarked: true,
    isFeatured: true,
    isPremium: false,
  ),
  // Adicionando mais notícias para exemplo
  Yournews(
    description: "The latest trends in artificial intelligence and machine learning are reshaping industries across the globe.",
    fullContent: "The latest trends in artificial intelligence and machine learning are reshaping industries across the globe. From healthcare to finance, from transportation to entertainment, AI is revolutionizing how we work, live, and interact with technology.\n\nIn healthcare, AI is being used to diagnose diseases more accurately and quickly than ever before. Machine learning algorithms can analyze medical images, predict patient outcomes, and even assist in drug discovery. This technology is making healthcare more accessible and efficient.\n\nThe financial sector is leveraging AI for fraud detection, algorithmic trading, and personalized banking experiences. AI can analyze vast amounts of financial data in real-time, helping institutions make better decisions and provide superior customer service.\n\nTransportation is being transformed by autonomous vehicles, smart traffic management systems, and predictive maintenance. These technologies promise to make transportation safer, more efficient, and more sustainable.\n\nAs AI continues to evolve, it's important to consider the ethical implications and ensure that these powerful technologies are developed and deployed responsibly.",
    newsImage: "Images/tech.png",
    image: "Images/tech image.png",
    newsTitle: "AI Revolution: Transforming Industries",
    newsCategories: "TECH",
    date: 'Monday 4 March 2024',
    time: '1h',
    color: const Color(0xFF333333),
    views: 3200,
    isBookmarked: false,
    isFeatured: false,
    isPremium: true,
  ),
  Yournews(
    description: "Sustainable fashion is becoming more than just a trend—it's a necessity for the future of our planet.",
    fullContent: "Sustainable fashion is becoming more than just a trend—it's a necessity for the future of our planet. The fashion industry is one of the most polluting industries in the world, and consumers are increasingly demanding more ethical and environmentally friendly options.\n\nSustainable fashion involves using eco-friendly materials, reducing waste, and ensuring fair labor practices throughout the supply chain. Brands are exploring innovative materials like recycled plastics, organic cotton, and even lab-grown leather alternatives.\n\nThe concept of 'slow fashion' is gaining traction, encouraging consumers to buy fewer, higher-quality pieces that last longer. This approach contrasts with fast fashion, which promotes frequent purchases of cheap, disposable clothing.\n\nMany designers are now focusing on creating timeless pieces that won't go out of style, and some brands are implementing take-back programs where customers can return old clothes for recycling or upcycling.\n\nConsumers can contribute to sustainable fashion by choosing quality over quantity, supporting ethical brands, and taking care of their clothes to extend their lifespan.",
    newsImage: "Images/fashion.png",
    image: "Images/fashion.png",
    newsTitle: "Sustainable Fashion: The Future is Green",
    newsCategories: "FASHION",
    date: 'Tuesday 5 March 2024',
    time: '30m',
    color: const Color(0xFFC7A87B),
    views: 720,
    isBookmarked: false,
    isFeatured: false,
    isPremium: false,
  ),
];

// Funções helper para filtrar notícias
class NewsHelper {
  // Obter notícias em destaque para o carrossel
  static List<Yournews> getFeaturedNews() {
    return newsItems.where((news) => news.isFeatured).toList();
  }
  
  // Obter notícias mais lidas (ordenadas por views)
  static List<Yournews> getMostReadNews() {
    List<Yournews> sortedNews = List.from(newsItems);
    sortedNews.sort((a, b) => b.views.compareTo(a.views));
    return sortedNews.take(5).toList();
  }
  
  // Obter notícias recentes
  static List<Yournews> getRecentNews() {
    return newsItems.take(4).toList();
  }
  
  // Filtrar notícias por categoria
  static List<Yournews> getNewsByCategory(String category) {
    return newsItems.where((news) => 
      news.newsCategories.toLowerCase() == category.toLowerCase()
    ).toList();
  }
  
  // Obter notícias salvas
  static List<Yournews> getBookmarkedNews() {
    return newsItems.where((news) => news.isBookmarked).toList();
  }
  
  // Alternar bookmark
  static void toggleBookmark(Yournews news) {
    news.isBookmarked = !news.isBookmarked;
  }
  
  // Incrementar visualizações
  static void incrementViews(Yournews news) {
    news.views++;
  }
}