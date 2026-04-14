import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetworkCache extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isWeb;

  const ImageNetworkCache({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ColoredBox(color: Colors.grey.shade200);
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image_not_supported);
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => ColoredBox(color: Colors.grey.shade700),
      errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
    );
  }

  static ImageProvider provider(
    String url, {
    bool isWeb = false,
    void Function(Object)? errorListener,
  }) {
    if (isWeb) {
      return NetworkImage(
        url,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      );
    }

    return CachedNetworkImageProvider(
      url,
      errorListener: errorListener,
    );
  }
}
