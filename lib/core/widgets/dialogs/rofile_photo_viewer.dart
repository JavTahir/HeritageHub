// lib/core/widgets/dialogs/profile_photo_viewer.dart
import 'package:flutter/material.dart';
import 'package:family_tree_app/core/constants/theme/theme.dart';

class ProfilePhotoViewer extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const ProfilePhotoViewer({
    Key? key,
    required this.imageUrl,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Main Image Content
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Hero(
                tag: heroTag ?? 'profile-image-viewer',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppTheme.primaryMagenta,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.error,
                            size: 40,
                            color: AppTheme.primaryMagenta,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Close Button
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
