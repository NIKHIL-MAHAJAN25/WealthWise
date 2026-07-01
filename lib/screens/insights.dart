import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthwise/providers/news_provider.dart';
import '../widgets/news_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NewsProvider>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Insights"),
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(provider.error!),
            );
          }

          if (provider.news.isEmpty) {
            return const Center(
              child: Text("No News Found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.news.length,
            itemBuilder: (context, index) {
              return NewsCard(
                news: provider.news[index],
              );
            },
          );
        },
      ),
    );
  }
}