// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://tsevelenews.tsevele.co.mz/api/auth';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Headers padrão
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers com autenticação
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    final baseHeaders = headers;
    if (token != null) {
      baseHeaders['Authorization'] = 'Bearer $token';
    }
    return baseHeaders;
  }

  // Registrar usuário
  static Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: json.encode(request.toJson()),
      );
      
      final jsonData = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonData);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (authResponse.success && authResponse.token != null) {
          await _saveAuthData(authResponse.token!, authResponse.user!);
        }
        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          message: authResponse.message ?? 'Erro no registro',
          errors: authResponse.errors,
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Login
  static Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: json.encode(request.toJson()),
      );
      
      final jsonData = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonData);
      
      if (response.statusCode == 200) {
        if (authResponse.success && authResponse.token != null) {
          await _saveAuthData(authResponse.token!, authResponse.user!);
        }
        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          message: authResponse.message ?? 'Credenciais inválidas',
          errors: authResponse.errors,
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Logout
  static Future<bool> logout() async {
    try {
      final authHeaders = await getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: authHeaders,
      );
      
      // Mesmo que o logout no servidor falhe, removemos os dados locais
      await _clearAuthData();
      
      return response.statusCode == 200;
    } catch (e) {
      // Em caso de erro, ainda assim removemos os dados locais
      await _clearAuthData();
      return false;
    }
  }

  // Obter perfil do usuário
  static Future<UserModel?> getProfile() async {
    try {
      final authHeaders = await getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: authHeaders,
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'success') {
          final user = UserModel.fromJson(jsonData['data']);
          await _saveUser(user);
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // Alterar senha
  static Future<AuthResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final authHeaders = await getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('$baseUrl/change-password'),
        headers: authHeaders,
        body: json.encode(request.toJson()),
      );
      
      final jsonData = json.decode(response.body);
      return AuthResponse.fromJson(jsonData);
      
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Verificar se usuário está logado
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Obter token armazenado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Obter usuário armazenado
  static Future<UserModel?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      try {
        final userData = json.decode(userJson);
        return UserModel.fromJson(userData);
      } catch (e) {
        print('Error parsing stored user: $e');
        return null;
      }
    }
    return null;
  }

  // Salvar dados de autenticação
  static Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Salvar apenas dados do usuário
  static Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  // Limpar dados de autenticação
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Verificar se token é válido (faz uma requisição para o perfil)
  static Future<bool> validateToken() async {
    try {
      final user = await getProfile();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  // Atualizar perfil
  static Future<AuthResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final authHeaders = await getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: authHeaders,
        body: json.encode(request.toJson()),
      );
      
      final jsonData = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonData);
      
      if (response.statusCode == 200 && authResponse.success && authResponse.user != null) {
        await _saveUser(authResponse.user!);
      }
      
      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Atualizar perfil (método genérico - mantido para compatibilidade)
  static Future<AuthResponse> updateProfileGeneric(Map<String, dynamic> data) async {
    try {
      final authHeaders = await getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: authHeaders,
        body: json.encode(data),
      );
      
      final jsonData = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonData);
      
      if (response.statusCode == 200 && authResponse.success && authResponse.user != null) {
        await _saveUser(authResponse.user!);
      }
      
      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Esqueci a senha
  static Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: headers,
        body: json.encode({'email': email}),
      );
      
      final jsonData = json.decode(response.body);
      return AuthResponse.fromJson(jsonData);
      
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }
}
