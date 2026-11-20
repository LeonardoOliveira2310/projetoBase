import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<bool> loginComEmailESenha(String email, String senha) async {
    try {
      final credenciais = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return credenciais.user?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário não encontrado para este email.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta fornecida para este usuario.');
      } else if (e.code == 'invalid-credential') {
        throw AuthException(
          'E-mail ou senha inválidos. Verifique os dados ou crie uma nova conta.',
        );
      }
      throw AuthException('Erro inesperado ao realizar login.');
    }
  }

  @override
  Future<void> enviarEmailDeVerificacao() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> loginComGoogle() async {
    try {
      // 1. Abre a janela do Google para o usuário escolher a conta
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Se o usuário fechou a janela sem escolher conta, lança um erro amigável
      if (googleUser == null) {
        throw AuthException('Login com Google cancelado pelo usuário.');
      }

      // 2. Pega os tokens de autenticação do Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz o login no Firebase
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException('Erro ao autenticar com o Google: ${e.message}');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Não foi possível conectar com a conta Google.');
    }
  }

  @override
  Future<String> registrarComEmailESenha(
    String email,
    String senha,
    String nome,
  ) async {
    try {
      final credenciais = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = credenciais.user;
      if (user == null) {
        throw AuthException('Não foi possível criar a conta do usuário.');
      }
      await user.updateDisplayName(nome);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('Este e-mail já está cadastrado em outra conta.');
      } else if (e.code == 'weak-password') {
        throw AuthException(
          'A senha escolhida é muito fraca (mínimo 6 caracteres).',
        );
      } else if (e.code == 'invalid-email') {
        throw AuthException('O formato do e-mail digitado é inválido.');
      }
      throw AuthException('Erro ao cadastrar usuário: ${e.message}');
    }
  }

  @override
  UsuarioEntity? obterUsuarioAtual() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UsuarioEntity(
      uid: user.uid,
      nome: user.displayName ?? 'Usuário',
      email: user.email ?? 'Sem email',
      fotoUrl: user.photoURL,
    );
  }

  @override
  Future<void> deslogar() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> enviarEmailRecuperacaoSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthException('O formato do e-mail digitado é inválido.');
      } else if (e.code == 'user-not-found') {
        throw AuthException('Nenhum usuário encontrado com este e-mail.');
      }
      throw AuthException('Erro ao enviar e-mail de recuperação: ${e.message}');
    } catch (_) {
      throw AuthException('Não foi possível enviar o e-mail de recuperação');
    }
  }
}
