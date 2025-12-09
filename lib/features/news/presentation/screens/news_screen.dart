import 'package:flutter/material.dart';
import 'package:news_flutter_app/core/error/failures.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui_result.dart';
import '../../data/model/article_model.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      context.read<NewsProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Consumer<NewsProvider>(
        builder: (context, vm, _) {
          final state = vm.state;

          if (state is UiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UiError) {
            final errorState = state as UiError<List<ArticleModel>>;
            return Center(child: Text('Error:  ${errorState.failure.message}'));
          }

          final articles = vm.articles;

          return ListView.builder(
            controller: scrollController,
            itemCount: articles.length + 1,
            itemBuilder: (context, index) {
              if (index == articles.length) {
                return vm.isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }

              return TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: child,
                  ),
                ),
                child: ArticleCard(article: articles[index]),
              );
            },
          );
        },
      ),
    );
  }
}
