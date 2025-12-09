import 'package:flutter/material.dart';
import '../../data/model/article_model.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage != null)
            Image.network(article.urlToImage!, height: 200, width: double.infinity, fit: BoxFit.cover),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title ?? 'NotFound',
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),

                const SizedBox(height: 6),

                if (article.description != null)
                  Text(article.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),

                const SizedBox(height: 12),
                Text('Source: ${article.sourceName ?? 'Unknown'} • ${article.publishedAt}',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          )
        ],
      ),
    );
  }

}
