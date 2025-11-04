import 'package:wow/data/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final Uuid _uuid = const Uuid();
  User? _currentUser;

  // Simula um "banco de dados" de usuários
  final Map<String, Map<String, String>> _users = {};

  // Getter para o usuário atual
  User? get currentUser => _currentUser;

  // Verifica se há um usuário logado
  bool get isAuthenticated => _currentUser != null;

  // Simula um login com email e senha
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latência

    // Verifica se o usuário existe
    if (_users.containsKey(email)) {
      final userData = _users[email]!;

      // Verifica a senha
      if (userData['password'] == password) {
        _currentUser = User(
          id: userData['id']!,
          email: email,
          name: userData['name']!,
          photoUrl: userData['photoUrl'],
          createdAt: DateTime.parse(userData['createdAt']!),
          lastLoginAt: DateTime.now(),
        );

        print('Login successful: ${_currentUser!.email}');
        return _currentUser;
      } else {
        print('Login failed: incorrect password');
        throw Exception('Senha incorreta');
      }
    } else {
      print('Login failed: user not found');
      throw Exception('Usuário não encontrado');
    }
  }

  // Simula um registro de novo usuário
  Future<User?> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latência

    // Verifica se o email já está em uso
    if (_users.containsKey(email)) {
      print('Registration failed: email already in use');
      throw Exception('Email já está em uso');
    }

    // Cria novo usuário
    final userId = _uuid.v4();
    final now = DateTime.now();

    _users[email] = {
      'id': userId,
      'password': password,
      'name': name,
      'createdAt': now.toIso8601String(),
    };

    _currentUser = User(
      id: userId,
      email: email,
      name: name,
      createdAt: now,
      lastLoginAt: now,
    );

    print('Registration successful: ${_currentUser!.email}');
    return _currentUser;
  }

  // Simula um logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula latência

    print('Logout: ${_currentUser?.email ?? "no user"}');
    _currentUser = null;
  }

  // Simula uma atualização de perfil
  Future<User?> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    if (_currentUser == null) {
      throw Exception('Nenhum usuário logado');
    }

    await Future.delayed(const Duration(milliseconds: 800)); // Simula latência

    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      photoUrl: photoUrl ?? _currentUser!.photoUrl,
    );

    // Atualiza no "banco de dados"
    if (_users.containsKey(_currentUser!.email)) {
      _users[_currentUser!.email]!['name'] = _currentUser!.name;
      if (photoUrl != null) {
        _users[_currentUser!.email]!['photoUrl'] = photoUrl;
      }
    }

    print('Profile updated: ${_currentUser!.name}');
    return _currentUser;
  }

  // Simula uma alteração de senha
  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (_currentUser == null) {
      throw Exception('Nenhum usuário logado');
    }

    await Future.delayed(const Duration(milliseconds: 800)); // Simula latência

    final userData = _users[_currentUser!.email];
    if (userData != null && userData['password'] == currentPassword) {
      userData['password'] = newPassword;
      print('Password changed successfully');
    } else {
      print('Password change failed: incorrect current password');
      throw Exception('Senha atual incorreta');
    }
  }

  // Simula uma recuperação de senha
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latência

    if (_users.containsKey(email)) {
      print('Password reset email sent to: $email');
      // Em uma implementação real, enviaria um email
    } else {
      throw Exception('Email não encontrado');
    }
  }

  // Verifica se um email já está cadastrado
  Future<bool> isEmailRegistered(String email) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula latência
    return _users.containsKey(email);
  }
  void clearAllUsers() {
    _users.clear();
    _currentUser = null;
    print('All users cleared');
  }
}