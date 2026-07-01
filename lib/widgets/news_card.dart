import 'package:flutter/material.dart';
import 'package:wealthwise/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({
    super.key,
    required this.news,
    
  });
  Future<void> openArticle() async {
  final Uri uri = Uri.parse(news.url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (news.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 12),

            Text(
              news.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              news.description ?? "No description available.",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: Text(
                    news.source ?? "Unknown Source",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Text(
                  news.publishedAt.substring(0, 10),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                 onPressed: openArticle();
                },
                child: const Text("Read More"),
              ),
            )
          ],
        ),
      ),
    );
  }
}