// lib/pages/podcast_page.dart
import 'package:flutter/material.dart';
import '../Model/podcast_model.dart';
import '../services/podcast_service.dart';
import 'podcast_detail_page.dart';
import 'podcast_category_page.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<PodcastModel> _podcasts = [];
  List<PodcastCategory> _categories = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    await Future.wait([
      _loadPodcasts(isRefresh: true),
      _loadCategories(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPodcasts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
    }

    final response = _searchQuery.isEmpty
        ? await PodcastService.getAllPodcasts(page: _currentPage)
        : await PodcastService.searchPodcasts(_searchQuery, page: _currentPage);

    if (response != null && response.isSuccess) {
      setState(() {
        if (isRefresh) {
          _podcasts = response.data;
        } else {
          _podcasts.addAll(response.data);
        }
        _hasMoreData = response.pagination.hasNextPage;
        _currentPage++;
      });
    }
  }

  Future<void> _loadCategories() async {
    final response = await PodcastService.getCategories();
    if (response != null && response.isSuccess) {
      setState(() {
        _categories = response.data;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMorePodcasts();
      }
    }
  }

  Future<void> _loadMorePodcasts() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _loadPodcasts();

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadPodcasts(isRefresh: true);
  }

  Future<void> _refresh() async {
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Podcasts',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFFC7A87B),
            ),
            onPressed: () {
              _loadInitialData();
            },
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search + TabBar area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildTabBar(),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPodcastsTab(),
                  _buildCategoriesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildHeader removed — header content is now rendered inline in build()

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Buscar podcasts...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFFC7A87B)),
        ),
        onSubmitted: _performSearch,
        onChanged: (value) {
          if (value.isEmpty) {
            _performSearch('');
          }
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFFC7A87B),
  unselectedLabelColor: const Color(0xFF718096),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Todos'),
          Tab(text: 'Categorias'),
        ],
      ),
    );
  }

  Widget _buildPodcastsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC7A87B)),
      );
    }

    if (_podcasts.isEmpty) {
      return _buildEmptyState('Nenhum podcast encontrado');
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        itemCount: _podcasts.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _podcasts.length) {
            return _buildLoadingIndicator();
          }

          final podcast = _podcasts[index];
          return _buildPodcastCard(podcast);
        },
      ),
    );
  }

  Widget _buildCategoriesTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC7A87B)),
      );
    }

    if (_categories.isEmpty) {
      return _buildEmptyState('Nenhuma categoria encontrada');
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildPodcastCard(PodcastModel podcast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPodcastDetail(podcast),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagem do podcast
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(podcast.previewImageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                  child: podcast.previewImageUrl.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7A87B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.podcasts,
                            color: Color(0xFFC7A87B),
                            size: 40,
                          ),
                        )
                      : null,
                ),
                
                const SizedBox(width: 16),
                
                // Informações do podcast
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        podcast.getCategory.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC7A87B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        podcast.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${podcast.totalViews}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          if (podcast.isPremiumContent) ...[
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFFC7A87B),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFC7A87B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          
                          const Spacer(),
                          
                          Icon(
                            podcast.canPlayFull ? Icons.play_circle_fill : Icons.play_circle_outline,
                            color: const Color(0xFFC7A87B),
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(PodcastCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToCategoryPodcasts(category),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7A87B).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.category,
                    color: Color(0xFFC7A87B),
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        '${category.totalPodcasts ?? 0} podcasts',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF718096),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.podcasts,
              size: 80,
              color: Color(0xFFC7A87B),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFFC7A87B)),
      ),
    );
  }

  void _navigateToPodcastDetail(PodcastModel podcast) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PodcastDetailPage(podcast: podcast),
      ),
    );
  }

  void _navigateToCategoryPodcasts(PodcastCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PodcastCategoryPage(category: category),
      ),
    );
  }
}
