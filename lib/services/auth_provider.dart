// lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Construtor
  AuthProvider() {
    _initAuth();
  }

  // Inicializar estado de autenticação
  Future<void> _initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        final storedUser = await AuthService.getStoredUser();
        if (storedUser != null) {
          _user = storedUser;
          _isLoggedIn = true;
          
          // Verificar se o token ainda é válido
          final isValid = await AuthService.validateToken();
          if (!isValid) {
            await logout();
            return;
          }
          
          // Atualizar dados do usuário
          final updatedUser = await AuthService.getProfile();
          if (updatedUser != null) {
            _user = updatedUser;
          }
        }
      }
    } catch (e) {
      _errorMessage = 'Erro ao verificar autenticação: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Registrar usuário
  Future<bool> register({
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
    String? firstname,
    String? lastname,
    String? mobile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        agree: true,
        firstname: firstname,
        lastname: lastname,
        mobile: mobile,
      );

      final response = await AuthService.register(request);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Erro no registro';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String login,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(
        login: login,
        password: password,
      );

      final response = await AuthService.login(request);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Credenciais inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
    } catch (e) {
      print('Erro no logout: $e');
    }

    _user = null;
    _isLoggedIn = false;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Alterar senha
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        password: newPassword,
        passwordConfirmation: newPasswordConfirmation,
      );

      final response = await AuthService.changePassword(request);
      
      if (response.success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Erro ao alterar senha';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Atualizar perfil
  Future<bool> updateProfile({
    String? firstname,
    String? lastname,
    String? mobile,
    UserAddress? address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = UpdateProfileRequest(
        firstname: firstname,
        lastname: lastname,
        mobile: mobile,
        address: address,
      );

      final response = await AuthService.updateProfile(request);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Erro ao atualizar perfil';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Atualizar perfil (método genérico - mantido para compatibilidade)
  Future<bool> updateProfileGeneric(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.updateProfileGeneric(data);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Erro ao atualizar perfil';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Recarregar dados do usuário
  Future<void> refreshUser() async {
    if (_isLoggedIn) {
      try {
        final updatedUser = await AuthService.getProfile();
        if (updatedUser != null) {
          _user = updatedUser;
          notifyListeners();
        }
      } catch (e) {
        print('Erro ao recarregar usuário: $e');
      }
    }
  }

  // Limpar mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Esqueci a senha
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.forgotPassword(email);
      
      if (response.success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Erro ao enviar email de recuperação';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
