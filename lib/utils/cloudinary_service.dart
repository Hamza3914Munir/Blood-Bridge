
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  final cloudinary = Cloudinary.unsignedConfig(
    cloudName: 'drd1fvdab', // Replace with your cloud name
  );

  Future<CloudinaryResponse?> uploadImage(String filePath, String uploadPreset) async {
    final response = await cloudinary.unsignedUpload(
      file: filePath,
      uploadPreset: uploadPreset,
      resourceType: CloudinaryResourceType.image,
      progressCallback: (count, total) {
        print('Uploading image from file with progress: $count/$total');
      },
    );

    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
      return response;
    } else {
      print('Image upload failed');
      return null;
    }
  }

  Future<bool> deleteImage(String publicId) async {
    final response = await cloudinary.destroy(
      publicId,
      resourceType: CloudinaryResourceType.image,
    );

    return response.isSuccessful ?? false;
  }
}