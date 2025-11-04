import 'package:flutter_test/flutter_test.dart';
import 'package:wow/services/auth_service.dart';
import 'package:wow/data/models/user.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();

      authService.clearAllUsers();
    });

    tearDown(() {
      authService.clearAllUsers();
    });

    group('Registro de Usuário', () {
      test('deve registrar um novo usuário com sucesso', () async {
        // Arrange
        const email = 'novo@email.com';
        const password = 'senha123';
        const name = 'Novo Usuário';

        // Act
        final user = await authService.register(email, password, name);

        // Assert
        expect(user, isNotNull);
        expect(user!.email, email);
        expect(user.name, name);
        expect(user.id, isNotEmpty);
        expect(authService.isAuthenticated, isTrue);
        expect(authService.currentUser, equals(user));
      });

      test('não deve registrar usuário com email já existente', () async {
        // Arrange
        const email = 'duplicado@email.com';
        await authService.register(email, 'senha123', 'Primeiro');

        // Act & Assert
        expect(
              () => authService.register(email, 'outrasenha', 'Segundo'),
          throwsException,
        );
      });

      test('usuário registrado deve ter createdAt e lastLoginAt definidos', () async {
        // Arrange & Act
        final user = await authService.register(
          'data@email.com',
          'senha123',
          'Usuário Data',
        );

        // Assert
        expect(user!.createdAt, isNotNull);
        expect(user.lastLoginAt, isNotNull);
        expect(user.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);
      });
    });

    group('Login de Usuário', () {
      test('deve fazer login com credenciais corretas', () async {
        // Arrange
        const email = 'login@email.com';
        const password = 'senha456';
        await authService.register(email, password, 'Usuário Login');
        await authService.logout();

        // Act
        final user = await authService.login(email, password);

        // Assert
        expect(user, isNotNull);
        expect(user!.email, email);
        expect(authService.isAuthenticated, isTrue);
        expect(authService.currentUser, equals(user));
      });

      test('não deve fazer login com senha incorreta', () async {
        // Arrange
        const email = 'senhaerrada@email.com';
        await authService.register(email, 'senhaCorreta', 'Usuário');
        await authService.logout();

        // Act & Assert
        expect(
              () => authService.login(email, 'senhaErrada'),
          throwsException,
        );
        expect(authService.isAuthenticated, isFalse);
      });

      test('não deve fazer login com usuário não cadastrado', () async {
        // Arrange
        const email = 'naoexiste@email.com';

        // Act & Assert
        expect(
              () => authService.login(email, 'qualquersenha'),
          throwsException,
        );
        expect(authService.isAuthenticated, isFalse);
      });

      test('deve atualizar lastLoginAt após login bem-sucedido', () async {
        // Arrange
        const email = 'lastlogin@email.com';
        const password = 'senha789';
        final userRegistered = await authService.register(email, password, 'Usuário');
        final firstLoginTime = userRegistered!.lastLoginAt;

        await authService.logout();
        await Future.delayed(Duration(milliseconds: 100));

        // Act
        final userLoggedIn = await authService.login(email, password);

        // Assert
        expect(userLoggedIn!.lastLoginAt, isNotNull);
        expect(
          userLoggedIn.lastLoginAt!.isAfter(firstLoginTime!),
          isTrue,
          reason: 'lastLoginAt deve ser atualizado após novo login',
        );
      });
    });

    group('Logout de Usuário', () {
      test('deve fazer logout com sucesso', () async {
        // Arrange
        await authService.register('logout@email.com', 'senha', 'Usuário');
        expect(authService.isAuthenticated, isTrue);

        // Act
        await authService.logout();

        // Assert
        expect(authService.isAuthenticated, isFalse);
        expect(authService.currentUser, isNull);
      });

      test('logout deve funcionar mesmo sem usuário logado', () async {
        // Arrange
        expect(authService.isAuthenticated, isFalse);

        // Act & Assert
        await authService.logout(); // Não deve lançar exceção
        expect(authService.isAuthenticated, isFalse);
      });
    });

    group('Atualização de Perfil', () {
      test('deve atualizar o nome do usuário', () async {
        // Arrange
        await authService.register('perfil@email.com', 'senha', 'Nome Antigo');
        const newName = 'Nome Novo';

        // Act
        final updatedUser = await authService.updateProfile(name: newName);

        // Assert
        expect(updatedUser!.name, newName);
        expect(authService.currentUser!.name, newName);
      });

      test('deve atualizar a foto do usuário', () async {
        // Arrange
        await authService.register('foto@email.com', 'senha', 'Usuário');
        const newPhotoUrl = 'https://exemplo.com/foto-nova.jpg';

        // Act
        final updatedUser = await authService.updateProfile(photoUrl: newPhotoUrl);

        // Assert
        expect(updatedUser!.photoUrl, newPhotoUrl);
        expect(authService.currentUser!.photoUrl, newPhotoUrl);
      });

      test('deve atualizar nome e foto simultaneamente', () async {
        // Arrange
        await authService.register('completo@email.com', 'senha', 'Nome Antigo');
        const newName = 'Nome Atualizado';
        const newPhotoUrl = 'https://exemplo.com/nova.jpg';

        // Act
        final updatedUser = await authService.updateProfile(
          name: newName,
          photoUrl: newPhotoUrl,
        );

        // Assert
        expect(updatedUser!.name, newName);
        expect(updatedUser.photoUrl, newPhotoUrl);
      });

      test('não deve atualizar perfil se não houver usuário logado', () async {
        // Arrange
        expect(authService.isAuthenticated, isFalse);

        // Act & Assert
        expect(
              () => authService.updateProfile(name: 'Qualquer Nome'),
          throwsException,
        );
      });
    });

    group('Alteração de Senha', () {
      test('deve alterar senha com senha atual correta', () async {
        // Arrange
        const email = 'mudarsenha@email.com';
        const oldPassword = 'senhaAntiga';
        const newPassword = 'senhaNova';
        await authService.register(email, oldPassword, 'Usuário');

        // Act
        await authService.changePassword(oldPassword, newPassword);

        // Assert - Deve fazer login com a nova senha
        await authService.logout();
        final user = await authService.login(email, newPassword);
        expect(user, isNotNull);
      });

      test('não deve alterar senha com senha atual incorreta', () async {
        // Arrange
        await authService.register('senhaerrada@email.com', 'senhaCorreta', 'Usuário');

        // Act & Assert
        expect(
              () => authService.changePassword('senhaErrada', 'senhaNova'),
          throwsException,
        );
      });

      test('não deve alterar senha sem usuário logado', () async {
        // Arrange
        expect(authService.isAuthenticated, isFalse);

        // Act & Assert
        expect(
              () => authService.changePassword('qualquer', 'nova'),
          throwsException,
        );
      });
    });

    group('Recuperação de Senha', () {
      test('deve enviar email de recuperação para usuário existente', () async {
        // Arrange
        const email = 'recuperar@email.com';
        await authService.register(email, 'senha123', 'Usuário');

        // Act & Assert - Não deve lançar exceção
        await authService.resetPassword(email);
      });

      test('não deve recuperar senha para email não cadastrado', () async {
        // Arrange
        const email = 'naoexiste@email.com';

        // Act & Assert
        expect(
              () => authService.resetPassword(email),
          throwsException,
        );
      });
    });

    group('Verificação de Email', () {
      test('deve retornar true para email já registrado', () async {
        // Arrange
        const email = 'verificar@email.com';
        await authService.register(email, 'senha', 'Usuário');

        // Act
        final isRegistered = await authService.isEmailRegistered(email);

        // Assert
        expect(isRegistered, isTrue);
      });

      test('deve retornar false para email não registrado', () async {
        // Arrange
        const email = 'novoemail@email.com';

        // Act
        final isRegistered = await authService.isEmailRegistered(email);

        // Assert
        expect(isRegistered, isFalse);
      });
    });

    group('Estado de Autenticação', () {
      test('isAuthenticated deve ser false inicialmente', () {
        // Assert
        expect(authService.isAuthenticated, isFalse);
        expect(authService.currentUser, isNull);
      });

      test('isAuthenticated deve ser true após registro', () async {
        // Act
        await authService.register('auth@email.com', 'senha', 'Usuário');

        // Assert
        expect(authService.isAuthenticated, isTrue);
        expect(authService.currentUser, isNotNull);
      });

      test('isAuthenticated deve ser true após login', () async {
        // Arrange
        const email = 'authlogin@email.com';
        const password = 'senha';
        await authService.register(email, password, 'Usuário');
        await authService.logout();

        // Act
        await authService.login(email, password);

        // Assert
        expect(authService.isAuthenticated, isTrue);
      });

      test('isAuthenticated deve ser false após logout', () async {
        // Arrange
        await authService.register('authlogout@email.com', 'senha', 'Usuário');

        // Act
        await authService.logout();

        // Assert
        expect(authService.isAuthenticated, isFalse);
      });
    });

    group('Limpeza de Dados', () {
      test('clearAllUsers deve remover todos os usuários', () async {
        // Arrange
        await authService.register('usuario1@email.com', 'senha1', 'Usuário 1');
        await authService.logout();
        await authService.register('usuario2@email.com', 'senha2', 'Usuário 2');

        // Act
        authService.clearAllUsers();

        // Assert
        expect(authService.isAuthenticated, isFalse);
        expect(authService.currentUser, isNull);

        // Tentar fazer login deve falhar
        expect(
              () => authService.login('usuario1@email.com', 'senha1'),
          throwsException,
        );
      });
    });
  });
}