import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 270.0,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ImageNetworkCache.provider(widget.news.image),
              ),
            ),
            child: Container(
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
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black,
                  ],
                ),
              ),
              child: Text(
                widget.news.title,
                style: TextStyle(
                  fontSize: 18,
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
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Column(
              spacing: 20.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.news.content.split('\n').map((text) {
                  return Text(text);
                }),
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
                        backgroundImage: ImageNetworkCache.provider(c.avatar),
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
  }
}
