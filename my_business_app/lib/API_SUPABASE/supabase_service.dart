// lib/services/supabase_service.dart
import 'package:MyBusiness/Constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient supabase;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> init() async {
    await Supabase.initialize(
      url: "https://cghpzfumlnoaxhqapbky.supabase.co",
      anonKey: token,
    );
    supabase = Supabase.instance.client;
  }

  SupabaseClient get client => supabase;
}

final supabaseService = SupabaseService();
