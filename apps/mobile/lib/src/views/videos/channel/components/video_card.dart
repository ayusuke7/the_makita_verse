import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import '../../../../shared/shared.dart';

class YTVideoCard extends StatelessWidget {
  final VideoEntity video;
  final VoidCallback? onTap;
  final VoidCallback? onTapMore;
  final EdgeInsets? margin;

  const YTVideoCard({
    super.key,
    this.onTap,
    this.onTapMore,
    this.margin = const EdgeInsets.only(bottom: 20.0),
    required this.video,
  });

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0:00';

    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secondsRemaining = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${secondsRemaining.toString().padLeft(2, '0')}';
    }
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: margin,
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ImageNetworkCache(
                      imageUrl: video.thumbnail.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _formatDuration(video.duration.toInt()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (onTapMore != null)
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: onTapMore,
                        icon: Icon(Icons.more_vert),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${_formatViewCount(video.viewCount)} visualizações',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white38,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
