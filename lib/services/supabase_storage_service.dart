import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static final _supabase = Supabase.instance.client;

  static Future<String?> uploadProfileImage(File image) async {
    try {
      final fileName =
          "profiles/${DateTime.now().millisecondsSinceEpoch}.jpg";

      await _supabase.storage
          .from("sample")
          .upload(fileName, image);

      final imageUrl = _supabase.storage
          .from("sample")
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }
}