import 'package:file_manager/models/build_categories.dart';

List<BuildCategories> categoryItems = [
  BuildCategories('assets/icons/images.png', 'Images'),
  BuildCategories('assets/icons/videos.png', 'Videos'),
  BuildCategories('assets/icons/audios.png', 'Audios'),
  BuildCategories('assets/icons/apps.png', 'Apps'),
  BuildCategories('assets/icons/documents.png', 'Documents & Others'),
];

Map fileFormats = {
  'downloads': 'assets/icons/downloads.png',
  '.mp3': 'assets/icons/audios.png',
  '.wav': 'assets/icons/audios.png',
  '.mp4': 'assets/icons/videos.png',
  '.mkv': 'assets/icons/videos.png',
  '.3gp': 'assets/icons/videos.png',
  '.pdf': 'assets/icons/documents.png',
  '.apk': 'assets/icons/apps.png',
  '.jpg': 'assets/icons/images.png',
  '.jpeg': 'assets/icons/images.png',
  '.png': 'assets/icons/images.png',
};

bool longPressed = false;
bool isFileDisplacing = false;
String buttonText = '';
String newFilePath = '';
String currentFilePath = '';
String displacingObject = '';
