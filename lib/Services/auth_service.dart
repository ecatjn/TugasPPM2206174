// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer; // FIX: Tambahkan import ini
import '../Models/base_api_response.dart';
import '../Models/login_response_body.dart';

class AuthService {
  final String _baseUrl = 'http://45.149.187.204:3000/api';
  final Dio _dio = Dio();

  // Metode untuk Login Pengguna
  Future<BaseApiResponse<LoginResponseBody>> login(Map<String, dynamic> loginData) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: loginData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      developer.log('Login API Response: ${response.data}');

      return BaseApiResponse.fromJson(
        response.data,
        (json) => LoginResponseBody.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      developer.log('Login API Error: ${e.response?.data ?? e.message}');
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        return BaseApiResponse.fromJson(
          e.response!.data,
          (json) => LoginResponseBody.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw Exception('Failed to login: ${e.message ?? 'Network error'}');
      }
    } catch (e) {
      developer.log('Unexpected error during login: $e');
      rethrow;
    }
  }
}