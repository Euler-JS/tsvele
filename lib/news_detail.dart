import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/Model/news_model.dart';
import 'package:news_app/pages/subscription_plans.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailNews extends StatefulWidget {
  const DetailNews({super.key, required this.news});

  final Yournews news;

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  bool isUserPremium = false; // Simula se o usuário tem assinatura premium
  
  @override
  void initState() {
    super.initState();
    // Incrementa views quando a página é aberta
    NewsHelper.incrementViews(widget.news);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com botões de ação
              buildHeader(),
              
              // Conteúdo principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Categoria e data
                    buildCategoryAndDate(),
                    
                    const SizedBox(height: 12),
                    
                    // Título
                    buildTitle(),
                    
                    const SizedBox(height: 20),
                    
                    // Imagem principal
                    buildMainImage(),
                    
                    const SizedBox(height: 20),
                    
                    // Estatísticas (views, tempo, etc.)
                    buildStats(),
                    
                    const SizedBox(height: 20),
                    
                    // Conteúdo do artigo
                    buildArticleContent(),
                    
                    const SizedBox(height: 30),
                    
                    // Botões de compartilhamento
                    buildShareButtons(),
                    
                    const SizedBox(height: 100), // Espaço para o bottom sheet
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom sheet fixo
      bottomSheet: buildBottomSheet(),
    );
  }

  // Header com navegação e bookmark
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão voltar
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
          
          // Título da página
          const Text(
            "Detalhes da Notícia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          // Botão bookmark
          GestureDetector(
            onTap: () {
              setState(() {
                NewsHelper.toggleBookmark(widget.news);
              });
              
              // Feedback visual
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.news.isBookmarked 
                        ? "Notícia salva!" 
                        : "Notícia removida dos salvos",
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFFC7A87B),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.news.isBookmarked 
                    ? const Color(0xFFC7A87B) 
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                widget.news.isBookmarked 
                    ? Icons.bookmark 
                    : Icons.bookmark_outline,
                size: 20,
                color: widget.news.isBookmarked 
                    ? Colors.white 
                    : const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Categoria e data
  Widget buildCategoryAndDate() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.news.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.news.newsCategories,
            style: TextStyle(
              color: widget.news.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        if (widget.news.isPremium)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC7A87B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 14,
                ),
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
        
        const Spacer(),
        
        Text(
          widget.news.date,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF333333).withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Título
  Widget buildTitle() {
    return Text(
      widget.news.newsTitle,
      style: const TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  // Imagem principal
  Widget buildMainImage() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.news.newsImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  // Estatísticas
  Widget buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.visibility,
            "${widget.news.views}",
            "Visualizações",
          ),
          _buildStatItem(
            Icons.access_time,
            widget.news.time,
            "Tempo de leitura",
          ),
          _buildStatItem(
            Icons.bookmark,
            widget.news.isBookmarked ? "Salvo" : "Salvar",
            "Status",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFC7A87B),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF333333).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Conteúdo do artigo
  Widget buildArticleContent() {
    String contentToShow;
    bool showPremiumButton = false;
    
    if (widget.news.isPremium && !isUserPremium) {
      // Mostrar apenas os primeiros parágrafos para usuários não premium
      List<String> paragraphs = widget.news.fullContent.split('\n\n');
      contentToShow = paragraphs.take(2).join('\n\n');
      showPremiumButton = true;
    } else {
      // Mostrar conteúdo completo
      contentToShow = widget.news.fullContent;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Conteúdo disponível
        Text(
          contentToShow,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xFF333333),
          ),
        ),
        
        // Botão premium se necessário
        if (showPremiumButton) ...[
          const SizedBox(height: 30),
          
          // Gradient fade effect
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          // Cartão premium
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 48,
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  "Conteúdo Exclusivo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  "Este conteúdo é exclusivo para assinantes premium. Assine agora para ter acesso completo a todas as notícias.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: () {
                    // _showSubscriptionDialog();
                    setState(() {
                  isUserPremium = true;
                });
              
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionPlansPage()),
                );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8B5E3C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Assinar Premium",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Botões de compartilhamento
  Widget buildShareButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Compartilhar esta notícia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                icon: Icons.facebook,
                label: "Facebook",
                color: const Color(0xFF1877F2),
                onTap: () => _shareToFacebook(),
              ),
              _buildShareButton(
                icon: Icons.business,
                label: "LinkedIn",
                color: const Color(0xFF0A66C2),
                onTap: () => _shareToLinkedIn(),
              ),
              _buildShareButton(
                icon: Icons.chat,
                label: "WhatsApp",
                color: const Color(0xFF25D366),
                onTap: () => _shareToWhatsApp(),
              ),
              _buildShareButton(
                icon: Icons.copy,
                label: "Copiar Link",
                color: const Color(0xFF8B5E3C),
                onTap: () => _copyLink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF333333).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom sheet com comentários
  Widget buildBottomSheet() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Campo de comentário
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 17, right: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFC7A87B).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: const Color(0xFFC7A87B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Adicione um comentário...",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Botões de ação
          Row(
            children: [
              _buildActionButton(
                icon: Icons.favorite_outline,
                color: const Color(0xFFFF6B6B),
                backgroundColor: const Color(0xFFFFEBEB),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.star_outline,
                color: const Color(0xFFC7A87B),
                backgroundColor: const Color(0xFFFFF7E2),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.more_vert,
                color: const Color(0xFF8B5E3C),
                backgroundColor: const Color(0xFFF5F5F5),
              ),
            ],
          ),
          
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // Métodos de compartilhamento
  void _shareToFacebook() {
    final String text = "Confira esta notícia: ${widget.news.newsTitle}";
    // Implementar compartilhamento no Facebook
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compartilhando no Facebook..."),
        backgroundColor: Color(0xFF1877F2),
      ),
    );
  }

  void _shareToLinkedIn() {
    final String text = "Confira esta notícia: ${widget.news.newsTitle}";
    // Implementar compartilhamento no LinkedIn
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compartilhando no LinkedIn..."),
        backgroundColor: Color(0xFF0A66C2),
      ),
    );
  }

  void _shareToWhatsApp() {
    final String text = "Confira esta notícia: ${widget.news.newsTitle}";
    // Implementar compartilhamento no WhatsApp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compartilhando no WhatsApp..."),
        backgroundColor: Color(0xFF25D366),
      ),
    );
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: "https://newsapp.com/news/${widget.news.newsTitle}"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Link copiado para a área de transferência!"),
        backgroundColor: Color(0xFF8B5E3C),
      ),
    );
  }

  // Dialog de assinatura
  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: Color(0xFFC7A87B),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                "Assinatura Premium",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Benefícios da assinatura premium:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 12),
              Text("• Acesso a todas as notícias exclusivas"),
              Text("• Conteúdo sem publicidade"),
              Text("• Notificações prioritárias"),
              Text("• Acesso antecipado a novos recursos"),
              SizedBox(height: 16),
              Text(
                "Apenas R\$ 9,90/mês",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC7A87B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xFF333333),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Simular assinatura premium
                setState(() {
                  isUserPremium = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Assinatura premium ativada! (Demo)"),
                    backgroundColor: Color(0xFFC7A87B),
                  ),
                );
                Navigator.pushNamed(context, '/premium');

                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC7A87B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Assinar Agora",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}