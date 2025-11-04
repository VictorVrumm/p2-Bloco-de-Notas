import 'package:flutter_test/flutter_test.dart';
import 'package:wow/services/auth_service.dart';
import 'package:wow/data/models/user.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
    authService.clearAllUsers(); // limpa antes de cada teste
  });

  group('AuthService', () {
    test('Deve registrar um novo usuário com sucesso', () async {
      final user = await authService.register(
        'teste@email.com',
        'senha123',
        'Usuário Teste',
      );

      expect(user, isA<User>());
      expect(user?.email, equals('teste@email.com'));
      expect(authService.isAuthenticated, isTrue);
    });

    test('Não deve permitir registro com email já existente', () async {
      await authService.register('teste@email.com', 'senha123', 'Usuário Teste');

      expect(
            () async => await authService.register('teste@email.com', 'outraSenha', 'Outro Nome'),
        throwsException,
      );
    });

    test('Deve fazer login com email e senha corretos', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      final user = await authService.login('user@email.com', 'senha123');

      expect(user, isA<User>());
      expect(authService.isAuthenticated, isTrue);
    });

    test('Deve lançar exceção ao logar com senha errada', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      expect(
            () async => await authService.login('user@email.com', 'senhaErrada'),
        throwsException,
      );
    });

    test('Deve deslogar o usuário corretamente', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      await authService.logout();

      expect(authService.currentUser, isNull);
      expect(authService.isAuthenticated, isFalse);
    });

    test('Deve atualizar o perfil do usuário logado', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      final updatedUser = await authService.updateProfile(name: 'Novo Nome');

      expect(updatedUser?.name, equals('Novo Nome'));
    });

    test('Deve lançar exceção ao atualizar perfil sem login', () async {
      expect(
            () async => await authService.updateProfile(name: 'Alguém'),
        throwsException,
      );
    });

    test('Deve alterar a senha com sucesso', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      await authService.changePassword('senha123', 'novaSenha');

      // Agora desloga e tenta logar com a nova senha
      await authService.logout();
      final user = await authService.login('user@email.com', 'novaSenha');

      expect(user?.email, equals('user@email.com'));
    });

    test('Deve falhar ao alterar senha com senha atual errada', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      expect(
            () async => await authService.changePassword('senhaErrada', 'novaSenha'),
        throwsException,
      );
    });

    test('Deve verificar se o email está registrado', () async {
      await authService.register('user@email.com', 'senha123', 'User');

      final existe = await authService.isEmailRegistered('user@email.com');
      final naoExiste = await authService.isEmailRegistered('naoexiste@email.com');

      expect(existe, isTrue);
      expect(naoExiste, isFalse);
    });
  });
}
