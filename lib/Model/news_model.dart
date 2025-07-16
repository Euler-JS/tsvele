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
    description: "Conta-se que há muito, muito tempo, no tempo em que os animais falavam, o crocodilo e o macaco eram amigos bem chegados. Um dia, o crocodilo foi visitar o seu amigo macaco e, quando lá chegou, permaneceu uma semana. Depois de ter completado uma semana de visita, o crocodilo pediu ao seu amigo macaco que o acompanhasse a casa para assim, o maca...",
    fullContent: "Conta-se que há muito, muito tempo, no tempo em que os animais falavam, o crocodilo e o macaco eram amigos bem chegados. Um dia, o crocodilo foi visitar o seu amigo macaco e, quando lá chegou, permaneceu uma semana. Depois de ter completado uma semana de visita, o crocodilo pediu ao seu amigo macaco que o acompanhasse a casa para assim, o macaco conhecer a sua família.\n\nO macaco aceitou e ambos partiram juntos. No caminho, o crocodilo começou a pensar que seria uma boa ideia comer o macaco. Assim, ele disse ao macaco que tinha um presente especial para ele na sua casa. O macaco, inocente, ficou animado com a ideia.\n\nQuando chegaram à casa do crocodilo, este convidou o macaco a entrar e ofereceu-lhe um banquete delicioso. O macaco estava tão distraído com a comida que não percebeu as intenções do crocodilo. No entanto, quando o crocodilo se preparou para atacar, o macaco conseguiu escapar rapidamente e saltou para uma árvore próxima.\n\nO crocodilo ficou furioso por ter perdido a sua presa e jurou vingança. Mas o macaco era astuto e sempre conseguia escapar das garras do crocodilo. Desde então, eles tornaram-se inimigos mortais, mas a história da amizade entre o macaco e o crocodilo ainda é contada como um conto moral sobre confiança e traição.",
    newsImage: "assets/image/tseve_macaco.jpg",
    image: "assets/image/tseve_macaco.jpg",
    newsTitle: 'A amizade entre o macaco e crocodilo (conto)',
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
    description: "Remédio de lua é um medicamento tradicional dado à criança nos primeiros meses de vida, pois acredita-se que o mesmo protege o bebé de ataques epilépticos. O nome “remédio de lua” deriva da crença ou do conhecimento de que durante as fases de transição da lua algumas crianças têm ataques epilépticos, que para o seu tratamento ...",
    fullContent: "Remédio de lua é um medicamento tradicional dado à criança nos primeiros meses de vida, pois acredita-se que o mesmo protege o bebé de ataques epilépticos. O nome “remédio de lua” deriva da crença ou do conhecimento de que durante as fases de transição da lua algumas crianças têm ataques epilépticos, que para o seu tratamento é necessário o uso deste remédio.\n\nO remédio é feito com uma mistura de ervas e raízes, que são fervidas e depois administradas à criança. Acredita-se que o remédio tem propriedades calmantes e protetoras, ajudando a prevenir convulsões e outros problemas neurológicos.\n\nNo entanto, a eficácia do remédio de lua é controversa. Enquanto alguns pais juram por seus benefícios, outros questionam sua validade científica. Estudos sobre o assunto são limitados e muitas vezes inconclusivos.\n\nApesar disso, o remédio de lua continua a ser uma prática comum em muitas comunidades, especialmente em áreas rurais onde o acesso a cuidados médicos convencionais pode ser limitado. A tradição persiste como parte do conhecimento cultural local, refletindo a interseção entre medicina tradicional e moderna.",
    newsImage: "assets/image/tseve_barro.png",
    image: "assets/image/tseve_barro.png",
    newsTitle: 'Remédio de lua: a disputa entre o conhecimento tradicional e convencional',
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
    description: "As sociedades africanas são culturalmente crentes da existência de espíritos de antepassados que conduzem, amaldiçoam ou atormentam a vida das pessoas ainda em vida. Curandeiros ou nyangas são guiados por espíritos nas suas acções para a cura de seus doentes. Pessoas alegam terem sido possuídas por espíritos para terem optado por certa...",
    fullContent: "As sociedades africanas são culturalmente crentes da existência de espíritos de antepassados que conduzem, amaldiçoam ou atormentam a vida das pessoas ainda em vida. Curandeiros ou nyangas são guiados por espíritos nas suas acções para a cura de seus doentes. Pessoas alegam terem sido possuídas por espíritos para terem optado por certa profissão ou para terem cometido certos crimes. A crença na existência de espíritos é tão forte que, em algumas sociedades, a morte de uma pessoa",
    newsImage: "assets/image/tseve_marido.jpg",
    image: "assets/image/tseve_marido.jpg",
    newsTitle: "“Marido da noite”: do mistério espiritual ao ultraje às vítimas",
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