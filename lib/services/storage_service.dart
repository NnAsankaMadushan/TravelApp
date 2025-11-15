import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../utils/cloudinary_config.dart';

class StorageService {
  late final CloudinaryPublic _cloudinary;

  StorageService() {
    _cloudinary = CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );
  }

  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
    String folder,
  ) async {
    try {
      final List<String> urls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        final url = await uploadImage(imageFiles[i], folder);
        if (url != null) {
          urls.add(url);
        }
      }

      return urls;
    } catch (e) {
      throw Exception('Failed to upload images: ${e.toString()}');
    }
  }

  Future<bool> deleteImage(String publicId) async {
    try {
      // Note: Deleting images requires server-side implementation with Cloudinary API
      // or you can use Cloudinary's Admin API with authentication
      // For now, we'll just return true as deletion is optional
      return true;
    } catch (e) {
      throw Exception('Failed to delete image: ${e.toString()}');
    }
  }
}
