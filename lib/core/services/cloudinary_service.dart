import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:path/path.dart';

class CloudinaryService {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: '',
    apiSecret: '',
    cloudName: '',
  );

  static Future<String> uploadImage(File imageFile) async {
    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'profile_images',
        fileName: basename(imageFile.path),
      );

      if (response.isSuccessful && response.secureUrl != null) {
        return response.secureUrl!;
      } else {
        throw Exception('Cloudinary upload failed: ${response.error}');
      }
    } catch (e) {
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }
}
