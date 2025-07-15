import 'package:flutter/material.dart';
import 'package:news_app/Model/news_model.dart';
import 'package:news_app/news_detail.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Yournews> bookmarkedNews = [];
  bool isSelectionMode = false;
  List<Yournews> selectedNews = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedNews();
  }

  void _loadBookmarkedNews() {
    setState(() {
      bookmarkedNews = NewsHelper.getBookmarkedNews();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedNews.clear();
      }
    });
  }

  void _toggleNewsSelection(Yournews news) {
    setState(() {
      if (selectedNews.contains(news)) {
        selectedNews.remove(news);
      } else {
        selectedNews.add(news);
      }
    });
  }

  void _removeSelectedBookmarks() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Remover dos Favoritos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          content: Text(
            'Tem certeza que deseja remover ${selectedNews.length} ${selectedNews.length == 1 ? 'notícia' : 'notícias'} dos seus favoritos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF333333)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  for (var news in selectedNews) {
                    NewsHelper.toggleBookmark(news);
                  }
                  selectedNews.clear();
                  isSelectionMode = false;
                  _loadBookmarkedNews();
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${selectedNews.length} ${selectedNews.length == 1 ? 'notícia removida' : 'notícias removidas'} dos favoritos'),
                    backgroundColor: const Color(0xFFC7A87B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isSelectionMode 
              ? '${selectedNews.length} selecionadas'
              : 'Notícias Salvas',
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (bookmarkedNews.isNotEmpty && !isSelectionMode)
            IconButton(
              icon: const Icon(
                Icons.select_all,
                color: Color(0xFFC7A87B),
              ),
              onPressed: _toggleSelectionMode,
              tooltip: 'Selecionar múltiplas',
            ),
          if (isSelectionMode) ...[
            IconButton(
              icon: const Icon(
                Icons.select_all,
                color: Color(0xFFC7A87B),
              ),
              onPressed: () {
                setState(() {
                  if (selectedNews.length == bookmarkedNews.length) {
                    selectedNews.clear();
                  } else {
                    selectedNews = List.from(bookmarkedNews);
                  }
                });
              },
              tooltip: 'Selecionar todas',
            ),
            if (selectedNews.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: _removeSelectedBookmarks,
                tooltip: 'Remover selecionadas',
              ),
          ],
        ],
      ),
      body: bookmarkedNews.isEmpty 
          ? _buildEmptyState()
          : _buildBookmarksList(),
      bottomNavigationBar: isSelectionMode && selectedNews.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _toggleSelectionMode,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF333333),
                        side: const BorderSide(color: Color(0xFFC7A87B)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _removeSelectedBookmarks,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Remover (${selectedNews.length})'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFC7A87B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.bookmark_outline,
                color: const Color(0xFFC7A87B),
                size: 64,
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Nenhuma notícia salva',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Comece a salvar notícias que deseja ler mais tarde. Todas as suas notícias favoritas aparecerão aqui.',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF333333).withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC7A87B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.explore),
                  SizedBox(width: 8),
                  Text(
                    'Explorar Notícias',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildBookmarksList() {
    return Column(
      children: [
        // Header com estatísticas
        Container(
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bookmarkedNews.length} ${bookmarkedNews.length == 1 ? 'Notícia Salva' : 'Notícias Salvas'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Suas notícias favoritas em um só lugar',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Lista de notícias
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: bookmarkedNews.length,
            itemBuilder: (context, index) {
              final news = bookmarkedNews[index];
              final isSelected = selectedNews.contains(news);
              
              return _buildBookmarkCard(news, isSelected, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkCard(Yournews news, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          _toggleNewsSelection(news);
        } else {
          // Abrir detalhes da notícia
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailNews(news: news),
            ),
          ).then((_) {
            // Recarregar bookmarks ao voltar (caso tenha sido removido)
            _loadBookmarkedNews();
          });
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          _toggleSelectionMode();
          _toggleNewsSelection(news);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFC7A87B).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFC7A87B)
                : const Color(0xFFC7A87B).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem com overlay de seleção
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(news.newsImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Overlay gradient
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
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
                
                // Checkbox de seleção
                if (isSelectionMode)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected 
                            ? Icons.check_circle 
                            : Icons.radio_button_unchecked,
                        color: isSelected 
                            ? const Color(0xFFC7A87B) 
                            : const Color(0xFF333333).withOpacity(0.6),
                        size: 24,
                      ),
                    ),
                  ),
                
                // Badge premium
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Posição na lista
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Conteúdo da notícia
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoria e data
                  Row(
                    children: [
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
                      const Spacer(),
                      Text(
                        news.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xFF333333).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Título
                  Text(
                    news.newsTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Descrição
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF333333).withOpacity(0.7),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Ações
                  Row(
                    children: [
                      // Visualizações
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: const Color(0xFF333333).withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.views}',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF333333).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Botão remover individual
                      if (!isSelectionMode)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    'Remover dos Favoritos',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  content: Text(
                                    'Remover "${news.newsTitle}" dos seus favoritos?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(color: Color(0xFF333333)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          NewsHelper.toggleBookmark(news);
                                          _loadBookmarkedNews();
                                        });
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Notícia removida dos favoritos'),
                                            backgroundColor: Color(0xFFC7A87B),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Remover'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark_remove,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Remover',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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