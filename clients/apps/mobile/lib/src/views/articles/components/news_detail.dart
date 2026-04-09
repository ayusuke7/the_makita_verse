import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../articles_page_viewmodel.dart';

class NewsDetail extends StatefulWidget {
  final NewsEntity news;

  const NewsDetail({
    super.key,
    required this.news,
  });

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final _articleViewModel = it.get<ArticlesPageViewModel>();

  void _handleLinkTap(String? url) {
    if (url == null) return;

    if (url.startsWith('http')) {
      Launch.openLink(url);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _articleViewModel,
      builder: (context, state, child) {
        final isSaved = state.savedNews.any(
          (n) => n.id == widget.news.id,
        );
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                ),
                color: isSaved ? Colors.amber : Colors.white,
                onPressed: () {
                  if (isSaved) {
                    _articleViewModel.unsaveNews(widget.news);
                  } else {
                    _articleViewModel.saveNews(widget.news);
                  }
                },
              ),
            ],
          ),
          body: ListView(
            children: [
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ImageNetworkCache.provider(widget.news.image),
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,

                  padding: EdgeInsets.all(10.0),
                  constraints: BoxConstraints(
                    minHeight: 100,
                    minWidth: double.maxFinite,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Text(
                    widget.news.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 10.0,
                  children: [
                    Chip(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      label: Text(widget.news.category),
                    ),
                    Spacer(),
                    Icon(
                      Icons.calendar_month,
                      size: 18,
                    ),
                    Text(
                      Helper.formatDate(widget.news.publishedAt),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(
                      data: widget.news.content,
                      onLinkTap: (url, _, _) {
                        _handleLinkTap(url);
                      },
                      style: {
                        'body': Style(
                          fontSize: FontSize(16),
                        ),
                      },
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Launch.openLink(widget.news.source);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        fixedSize: Size(double.maxFinite, 40),
                        iconColor: Colors.white,
                      ),
                      icon: Icon(Icons.read_more),
                      label: Text(
                        'Read more',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Offstage(
                offstage: widget.news.links.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Links'),
                      ),
                      ...widget.news.links.map((link) {
                        return ListTile(
                          leading: Icon(Icons.link, size: 20),
                          title: Text(
                            link.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            link.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {},
                        );
                      }),
                    ],
                  ),
                ),
              ),

              Offstage(
                offstage: widget.news.comments.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 20.0,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${widget.news.comments.length} Comments'),
                      ),
                      ...widget.news.comments.map((c) {
                        final isMakita = c.name.toLowerCase().contains('akita');
                        return BalonComment(
                          side: isMakita ? BalonSide.left : BalonSide.right,
                          comment: c.content,
                          avatar: CircleAvatar(
                            backgroundImage: ImageNetworkCache.provider(
                              c.avatar,
                            ),
                          ),
                        );
                      }),
                      TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          hintText: 'What do you think?',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
