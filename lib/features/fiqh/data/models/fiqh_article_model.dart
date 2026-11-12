class FiqhArticleModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String searchKeywords;
  final String reference;
  final String authorReviewer;
  final DateTime createdAt;

  /// Skor kecocokan Cosine Similarity (transient/dihitung saat pencarian)
  final double similarityScore;

  const FiqhArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.searchKeywords,
    required this.reference,
    this.authorReviewer = 'Tim Asatidz / Fiqh Reviewer',
    required this.createdAt,
    this.similarityScore = 0.0,
  });

  factory FiqhArticleModel.fromJson(Map<String, dynamic> json, {double score = 0.0}) {
    return FiqhArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String? ?? 'Haid',
      searchKeywords: json['search_keywords'] as String? ?? '',
      reference: json['reference'] as String? ?? 'Rujukan Mazhab Syafi\'i',
      authorReviewer: json['author_reviewer'] as String? ?? 'Tim Asatidz',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      similarityScore: (json['similarity_score'] as num?)?.toDouble() ?? score,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'search_keywords': searchKeywords,
      'reference': reference,
      'author_reviewer': authorReviewer,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FiqhArticleModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? searchKeywords,
    String? reference,
    String? authorReviewer,
    DateTime? createdAt,
    double? similarityScore,
  }) {
    return FiqhArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      reference: reference ?? this.reference,
      authorReviewer: authorReviewer ?? this.authorReviewer,
      createdAt: createdAt ?? this.createdAt,
      similarityScore: similarityScore ?? this.similarityScore,
    );
  }
}
