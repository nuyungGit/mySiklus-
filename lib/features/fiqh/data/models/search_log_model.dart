class SearchLogModel {
  final String id;
  final String userId;
  final String searchQuery;
  final String? matchedArticleId;
  final double similarityScore;
  final DateTime createdAt;

  const SearchLogModel({
    required this.id,
    required this.userId,
    required this.searchQuery,
    this.matchedArticleId,
    required this.similarityScore,
    required this.createdAt,
  });

  factory SearchLogModel.fromJson(Map<String, dynamic> json) {
    return SearchLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      searchQuery: json['search_query'] as String,
      matchedArticleId: json['matched_article_id'] as String?,
      similarityScore: (json['similarity_score'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'search_query': searchQuery,
      'matched_article_id': matchedArticleId,
      'similarity_score': similarityScore,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
