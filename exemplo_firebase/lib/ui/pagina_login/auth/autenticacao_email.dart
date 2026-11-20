import 'package:exemplo_firebase/ui/pagina_login/view_model/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AutenticacaoEmail {
  AutenticacaoEmail({required LoginViewModel loginViewModel})
    : _loginViewModel = loginViewModel;
  final LoginViewModel _loginViewModel;
  String mensagem = '';

  Future<bool> logarUsuario() async {
    if (!await _loginViewModel.validarLogin()) {
      if (_loginViewModel.emailController.text.isEmpty) {
        FirebaseCrashlytics.instance.setCustomKey(
          "EMAIL_VAZIO",
          "e-mail vazio",
        );
      }
      if (_loginViewModel.senhaController.text.isEmpty) {
        FirebaseCrashlytics.instance.setCustomKey("SENHA_VAZIA", "senha vazio");
      }
      _loginViewModel.mesagemFalhaNoLogin('Email e senha não podem ser vazios');
      return false;
    }

    try {
      final credenciais = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _loginViewModel.emailController.text,
            password: _loginViewModel.senhaController.text,
          );
      final user = credenciais.user;

      if (user != null && !user.emailVerified) {
        credenciais.user?.sendEmailVerification();
        _loginViewModel.mesagemFalhaNoLogin(
          'Email não verificado, favor checar seu email.',
        );
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _loginViewModel.mesagemFalhaNoLogin(
          'Usuário não encontrado para este email.',
        );
        return false;
      } else if (e.code == 'wrong-password') {
        _loginViewModel.mesagemFalhaNoLogin(
          'Senha incorreta fornecida para este usuario.',
        );
        return false;
      } else if (e.code == 'invalid-credential') {
        _loginViewModel.mesagemFalhaNoLogin(
          'E-mail ou senha inválidos. Verifique os dados ou crie uma nova conta.',
        );
        return false;
      }
      return false;
    }
  }
}
