import 'package:exemplo_firebase/ui/pagina_login/view_model/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class RegistrarEmail {
  RegistrarEmail({required LoginViewModel loginViewModel})
    : _loginViewModel = loginViewModel;
  final LoginViewModel _loginViewModel;

  String mensagem = '';

  void registrarUsuario() async {
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
      _loginViewModel.mesagemFalhaNoLogin(
        'Falha ao Regitrar. Email e senha não pode ser vazio.',
      );
    }
    try {
      final credenciais = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _loginViewModel.emailController.text,
            password: _loginViewModel.senhaController.text,
          );
      credenciais.user?.sendEmailVerification();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.setCustomKey(
        "ERRO_CADASTRAR",
        "Verificar email e senha: $e",
      );
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Erro ao registrar usuário",
        fatal: false,
      );
      _loginViewModel.mesagemFalhaNoLogin("Verificar email e senha:");
    }
  }
}
