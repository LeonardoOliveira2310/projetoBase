import 'package:exemplo_firebase/ui/pagina_login/auth/autenticacao_email.dart';
import 'package:exemplo_firebase/ui/pagina_login/auth/autenticacao_google.dart';
import 'package:exemplo_firebase/ui/pagina_login/view_model/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginAction {
  LoginAction({
    required AutenticacaoEmail autenticacaoEmail,
    required AutenticacaoGoogle autenticacaoGoogle,
    required LoginViewModel loginViewModel,
  }) : _autenticacaoEmail = autenticacaoEmail,
       _autenticacaoGoogle = autenticacaoGoogle,
       _loginViewModel = loginViewModel;
  final AutenticacaoEmail _autenticacaoEmail;
  final AutenticacaoGoogle _autenticacaoGoogle;
  final LoginViewModel _loginViewModel;

  Future<void> loginInvalido(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _loginViewModel.mensagemErroLogin,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // fecha o alerta
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checarLoginValido(BuildContext context) async {
    bool loginValidado = await _autenticacaoEmail.logarUsuario();

    if (context.mounted) {
      loginValidado ? _irParaPaginaPrincipal(context) : loginInvalido(context);
    }
  }

  Future<void> loginComGoogle(BuildContext context) async {
    UserCredential? usuarioValidado = await _autenticacaoGoogle
        .acessarComGoogle();

    if (context.mounted) {
      usuarioValidado != null
          ? _irParaPaginaPrincipal(context)
          : loginInvalido(context);
    }
  }

  void _irParaPaginaPrincipal(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/home/homePage');
  }
}
