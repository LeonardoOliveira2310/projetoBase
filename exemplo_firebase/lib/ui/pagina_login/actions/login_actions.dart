import 'package:exemplo_firebase/ui/pagina_login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';

class LoginActions {
  static Future<void> aoClicarEntrarEmail({
    required BuildContext context,
    required LoginViewModel loginViewModel,
    required String email,
    required String senha,
  }) async {
    final sucesso = await loginViewModel.logarComEmail(email, senha);

    if (!context.mounted) return;
    sucesso
        ? _irParaPaginaPrincipal(context)
        : _mostrarDialogoErro(context, loginViewModel.mensagemErroLogin);
  }

  static Future<void> aoClicarEntrarGoogle({
    required BuildContext context,
    required LoginViewModel loginViewModel,
  }) async {
    final sucesso = await loginViewModel.logarComGoogle();

    if (!context.mounted) return;
    sucesso
        ? _irParaPaginaPrincipal(context)
        : _mostrarDialogoErro(context, loginViewModel.mensagemErroLogin);
  }

  static void _irParaPaginaPrincipal(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/home/homePage');
  }

  static Future<void> _mostrarDialogoErro(
    BuildContext context,
    String mensagem,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mensagem, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> aoClicarEsqueciSenha({
    required BuildContext context,
    required LoginViewModel loginViewModel,
    required String email,
  }) async {
    final emailRecuperacaoController = TextEditingController(
      text: email.trim(),
    );

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar Senha'),
        content: TextField(
          controller: emailRecuperacaoController,
          maxLength: 120,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Digite seu e-mail cadastrado',
            counterText: '',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final sucesso = await loginViewModel.recuperarSenha(
      emailRecuperacaoController.text,
    );
    if (!context.mounted) return;

    if (sucesso) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('E-mail enviado!'),
          content: const Text(
            'Se este e-mail estiver cadastrado, você receberá um link para redefinir sua senha.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      _mostrarDialogoErro(context, loginViewModel.mensagemErroLogin);
    }
  }
}
