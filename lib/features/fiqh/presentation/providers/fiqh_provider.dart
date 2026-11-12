import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fiqh_article_model.dart';
import '../../data/sources/default_fiqh_corpus.dart';
import '../../domain/nlp/tfidf_engine.dart';

class FiqhState {
  final List<FiqhArticleModel> allArticles;
  final List<FiqhArticleModel> displayArticles;
  final String selectedCategory;
  final String currentQuery;
  final bool isSearchActive;

  const FiqhState({
    required this.allArticles,
    required this.displayArticles,
    this.selectedCategory = 'Semua',
    this.currentQuery = '',
    this.isSearchActive = false,
  });

  FiqhState copyWith({
    List<FiqhArticleModel>? allArticles,
    List<FiqhArticleModel>? displayArticles,
    String? selectedCategory,
    String? currentQuery,
    bool? isSearchActive,
  }) {
    return FiqhState(
      allArticles: allArticles ?? this.allArticles,
      displayArticles: displayArticles ?? this.displayArticles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentQuery: currentQuery ?? this.currentQuery,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }
}

class FiqhNotifier extends StateNotifier<FiqhState> {
  late TfidfEngine _engine;

  FiqhNotifier()
      : super(FiqhState(
          allArticles: DefaultFiqhCorpus.articles,
          displayArticles: DefaultFiqhCorpus.articles,
        )) {
    _engine = TfidfEngine(articles: DefaultFiqhCorpus.articles);
  }

  /// Eksekusi pencarian cerdas berbasis TF-IDF & Cosine Similarity
  void search(String query) {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    // Jalankan engine Temu Kembali Informasi (NLP)
    final results = _engine.search(query, topK: 5);

    state = state.copyWith(
      currentQuery: query,
      isSearchActive: true,
      displayArticles: results,
    );
  }

  /// Filter berdasarkan tab kategori fiqh
  void selectCategory(String category) {
    if (state.isSearchActive) {
      clearSearch();
    }

    if (category == 'Semua') {
      state = state.copyWith(
        selectedCategory: category,
        displayArticles: state.allArticles,
      );
    } else {
      final filtered = state.allArticles
          .where((a) => a.category.toLowerCase() == category.toLowerCase())
          .toList();
      state = state.copyWith(
        selectedCategory: category,
        displayArticles: filtered,
      );
    }
  }

  /// Reset pencarian
  void clearSearch() {
    state = state.copyWith(
      currentQuery: '',
      isSearchActive: false,
      displayArticles: state.selectedCategory == 'Semua'
          ? state.allArticles
          : state.allArticles
              .where((a) => a.category.toLowerCase() == state.selectedCategory.toLowerCase())
              .toList(),
    );
  }
}

final fiqhProvider = StateNotifierProvider<FiqhNotifier, FiqhState>((ref) {
  return FiqhNotifier();
});
