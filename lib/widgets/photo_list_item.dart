import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rapiddown_challenge/widgets/photo_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class PhotoListItem extends StatelessWidget {
  final dynamic photo;
  final double? downloadProgress;
  final VoidCallback onDownload;

  const PhotoListItem({
    Key? key,
    required this.photo,
    this.downloadProgress,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using null-aware operators to provide fallbacks
    final String imageUrl = photo['src']?['medium'] ?? '';
    final String photographer = photo['photographer'] ?? 'Unknown';
    final int width = photo['width'] ?? 0;
    final int height = photo['height'] ?? 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: PhotoDetailScreen(photo: photo),
                ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Hero(
            tag: 'photo_${photo['id']}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          title: Text(
            photographer,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${width}x$height'),
              if (downloadProgress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: downloadProgress,
                        minHeight: 4,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blueAccent,
                      ),
                      Text(
                        '${(downloadProgress! * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          trailing:
              downloadProgress == null
                  ? TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.blueAccent,
                          ),
                          onPressed: onDownload,
                        ),
                      );
                    },
                  )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
