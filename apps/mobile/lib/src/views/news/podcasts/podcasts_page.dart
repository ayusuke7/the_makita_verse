import 'package:flutter/material.dart';

import '../../../config/di.dart';
import 'components/podcast_detail.dart';
import 'podcasts_viewmodel.dart';

class PodcastsPage extends StatefulWidget {
  const PodcastsPage({super.key});

  @override
  State<PodcastsPage> createState() => _PodcastsPageState();
}

class _PodcastsPageState extends State<PodcastsPage> {
  final _podcastsViewModel = it.get<PodcastsViewModel>();

  @override
  void initState() {
    super.initState();
    _podcastsViewModel.getPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _podcastsViewModel,
      builder: (context, state, child) {
        if (state.status.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }

        if (state.status.isError) {
          return Center(
            child: Text('Ops! something went wrong'),
          );
        }

        final posts = state.searchPodcasts.isEmpty
            ? state.podcasts
            : state.searchPodcasts;

        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              child: ListTile(
                title: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(Icons.audio_file, size: 30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PodcastDetail(podcast: post),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
