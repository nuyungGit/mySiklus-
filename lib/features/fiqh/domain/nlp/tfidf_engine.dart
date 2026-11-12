import 'dart:math';
import '../../data/models/fiqh_article_model.dart';
import 'text_preprocessor.dart';

/// Engine Temu Kembali Informasi (Information Retrieval)
/// Mengimplementasikan pembobotan TF-IDF dan kalkulasi kemiripan Cosine Similarity.
class TfidfEngine {
  final List<FiqhArticleModel> articles;

  // Vocabulary & Inverse Document Frequency Map
  final Map<String, double> _idfMap = {};

  // List of preprocessed tokens for each document
  final List<List<String>> _docTokensList = [];

  // Precomputed document vector norms: ||d||
  final List<double> _docNorms = [];

  // Precomputed TF-IDF vector maps for each document
  final List<Map<String, double>> _docVectors = [];

  TfidfEngine({required this.articles}) {
    _buildIndex();
  }

  /// Membangun indeks korpus dan menghitung nilai IDF untuk seluruh terms
  void _buildIndex() {
    _idfMap.clear();
    _docTokensList.clear();
    _docNorms.clear();
    _docVectors.clear();

    final int totalDocs = articles.length;
    if (totalDocs == 0) return;

    // 1. Ekstraksi dan pra-pemrosesan teks dokumen
    final Map<String, int> docFrequency = {};

    for (final article in articles) {
      // Gabungkan judul, kata kunci, dan isi artikel untuk ekstraksi fitur
      final combinedText = '${article.title} ${article.searchKeywords} ${article.content}';
      final tokens = TextPreprocessor.preprocess(combinedText);
      _docTokensList.add(tokens);

      // Hitung Document Frequency (df): Berapa banyak dokumen yang mengandung term t
      final uniqueTermsInDoc = tokens.toSet();
      for (final term in uniqueTermsInDoc) {
        docFrequency[term] = (docFrequency[term] ?? 0) + 1;
      }
    }

    // 2. Hitung IDF: log((1 + N) / (1 + df)) + 1
    docFrequency.forEach((term, df) {
      _idfMap[term] = log((1.0 + totalDocs) / (1.0 + df)) + 1.0;
    });

    // 3. Precompute TF-IDF vector & vector norm untuk setiap dokumen
    for (int i = 0; i < totalDocs; i++) {
      final tokens = _docTokensList[i];
      final docVector = _computeTfidfVector(tokens);
      _docVectors.add(docVector);

      // Hitung ||d|| = sqrt(sum(w^2))
      double sumSquares = 0.0;
      for (final weight in docVector.values) {
        sumSquares += weight * weight;
      }
      _docNorms.add(sqrt(sumSquares));
    }
  }

  /// Menghitung vektor TF-IDF dari daftar token
  Map<String, double> _computeTfidfVector(List<String> tokens) {
    final Map<String, double> vector = {};
    if (tokens.isEmpty) return vector;

    // Hitung Term Frequency (TF)
    final Map<String, int> termCounts = {};
    for (final token in tokens) {
      termCounts[token] = (termCounts[token] ?? 0) + 1;
    }

    final double totalTerms = tokens.length.toDouble();

    // Hitung TF-IDF = (count / totalTerms) * idf
    termCounts.forEach((term, count) {
      final tf = count / totalTerms;
      final idf = _idfMap[term] ?? 1.0;
      vector[term] = tf * idf;
    });

    return vector;
  }

  /// Melakukan pencarian artikel berdasarkan kueri pengguna
  /// Mengembalikan daftar artikel yang terurut dari skor kemiripan tertinggi ke terendah.
  List<FiqhArticleModel> search(String query, {int topK = 3, double threshold = 0.01}) {
    if (articles.isEmpty || query.trim().isEmpty) return [];

    final queryTokens = TextPreprocessor.preprocess(query);
    if (queryTokens.isEmpty) return [];

    // 1. Buat vektor kueri
    final queryVector = _computeTfidfVector(queryTokens);

    // Hitung norma vektor kueri: ||q||
    double querySumSquares = 0.0;
    for (final weight in queryVector.values) {
      querySumSquares += weight * weight;
    }
    final double queryNorm = sqrt(querySumSquares);
    if (queryNorm == 0.0) return [];

    // 2. Hitung Cosine Similarity terhadap setiap dokumen
    final List<MapEntry<int, double>> scoredIndices = [];

    for (int i = 0; i < articles.length; i++) {
      final docVector = _docVectors[i];
      final docNorm = _docNorms[i];

      if (docNorm == 0.0) continue;

      // Dot product: sum(q_i * d_i)
      double dotProduct = 0.0;
      queryVector.forEach((term, qWeight) {
        if (docVector.containsKey(term)) {
          dotProduct += qWeight * docVector[term]!;
        }
      });

      // Cosine Similarity: dotProduct / (||q|| * ||d||)
      final double similarity = dotProduct / (queryNorm * docNorm);

      if (similarity >= threshold) {
        scoredIndices.add(MapEntry(i, similarity));
      }
    }

    // 3. Urutkan berdasarkan similarity score secara descending
    scoredIndices.sort((a, b) => b.value.compareTo(a.value));

    // 4. Ambil Top-K artikel
    final results = <FiqhArticleModel>[];
    final limit = scoredIndices.length < topK ? scoredIndices.length : topK;

    for (int i = 0; i < limit; i++) {
      final entry = scoredIndices[i];
      final originalArticle = articles[entry.key];
      results.add(originalArticle.copyWith(similarityScore: entry.value));
    }

    return results;
  }
}
