import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkCache extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ImageNetworkCache({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => ColoredBox(color: Colors.grey.shade200),
      errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
    );
  }

  static CachedNetworkImageProvider provider(
    String url, {
    void Function(Object)? errorListener,
  }) {
    return CachedNetworkImageProvider(url, errorListener: errorListener);
  }
}
