import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/fiqh_article_model.dart';

class ArticleDetailSheet extends StatelessWidget {
  final FiqhArticleModel article;

  const ArticleDetailSheet({super.key, required this.article});

  static void show(BuildContext context, FiqhArticleModel article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ArticleDetailSheet(article: article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreenLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      color: AppColors.sageGreenDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (article.similarityScore > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softMauveLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Relevansi: ${(article.similarityScore * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: AppColors.softMauve,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.divider, height: 24),

          // Content body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Metadata rujukan
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.softMauve),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article.reference,
                          style: const TextStyle(
                            color: AppColors.softMauve,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Isi artikel
                  Text(
                    article.content.trim(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                      height: 1.7,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Ethical & Theology Disclaimer Box (Prinsip Utama Blueprint mySiklus)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pernyataan Etis: Artikel ini disajikan sebagai sarana literasi dan edukasi fiqh wanita. Aplikasi ini tidak menjatuhkan fatwa hukum mutlak. Jika Anda mengalami kondisi pendarahan yang tidak lazim atau ragu, harap berkonsultasi langsung dengan ahli fiqh/ustadzah terpercaya.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
