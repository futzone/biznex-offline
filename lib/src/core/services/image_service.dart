import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndSaveImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final File imageFile = File(image.path);
    final String fileName = imageFile.uri.pathSegments.last;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String savedPath = '${appDir.path}/$fileName';

    await imageFile.copy(savedPath);

    return savedPath;
  }
}
