import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryConfig {
    static String get cloudName =>
            dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'dqjjjykom';

    static String get arthubartwork =>
            dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'trip_card';

  static String get apiKey =>
      dotenv.env['CLOUDINARY_API_KEY'] ??
      const String.fromEnvironment('CLOUDINARY_API_KEY');

  static String get apiSecret =>
      dotenv.env['CLOUDINARY_API_SECRET'] ??
      const String.fromEnvironment('CLOUDINARY_API_SECRET');
}
