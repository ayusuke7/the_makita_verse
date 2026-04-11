import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/config/config.dart';

import '../../domain/domain.dart';
import '../../shared/shared.dart';
import 'channel_viewmodel.dart';
import 'components/video_card.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final _channelViewModel = it.get<ChannelViewModel>();
  final _searchController = TextEditingController();

  void _showChannelDetail(ChannelEntity channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: ImageNetworkCache.provider(
                    channel.thumbnails.last.url,
                  ),
                ),
                title: Text(
                  channel.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${_formatViewCount(channel.channelFollowerCount)} Subscribers',
                ),
              ),

              Text(
                channel.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: channel.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: Colors.white10,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  void initState() {
    super.initState();
    _channelViewModel.getChannel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _channelViewModel,
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

        if (state.channel != null) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ImageNetworkCache(
                imageUrl: state.channel!.thumbnails.first.url,
                height: 80,
                width: double.maxFinite,
                fit: BoxFit.fill,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: ImageNetworkCache.provider(
                    state.channel!.thumbnails.last.url,
                  ),
                ),
                trailing: Icon(Icons.more_vert),
                title: Text(
                  state.channel!.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${_formatViewCount(state.channel!.channelFollowerCount)} Subscribers',
                ),
                onTap: () {
                  _showChannelDetail(state.channel!);
                },
              ),

              if (state.playlists.isNotEmpty) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${state.playlists.length} Playlists',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 150.0,
                  child: CarouselView.weighted(
                    backgroundColor: Colors.transparent,
                    flexWeights: [1, 1, 1, 1],
                    onTap: (index) {
                      Launch.openLink(state.playlists[index].url);
                    },
                    children: state.playlists.map((e) {
                      return Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 50.0,
                            backgroundColor: Colors.grey.shade800,
                            backgroundImage: ImageNetworkCache.provider(
                              e.thumbnail.url,
                              errorListener: (p0) {
                                Logger.error('Error loading image');
                              },
                            ),
                          ),
                          Text(
                            e.title,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${state.channel!.videos.length} Vídeos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: state.channel!.videos.map((e) {
                  return YTVideoCard(video: e);
                }).toList(),
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
