import 'package:exemplo_firebase/ui/pagina_login/actions/login_actions.dart';
import 'package:exemplo_firebase/ui/pagina_login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaginaLogin extends StatefulWidget {
  final LoginViewModel loginViewModel;
  const PaginaLogin({super.key, required this.loginViewModel});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.loginViewModel,
      builder: (context, _) {
        final bloqueado = widget.loginViewModel.estaCarregando;
        final carregandoEmail = widget.loginViewModel.carregandoEmail;
        final carregandoGoogle = widget.loginViewModel.carregandoGoogle;
        return Material(
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: const Placeholder(),
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        enabled: !carregandoEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.email, size: 28),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _senhaController,
                        enabled: !carregandoEmail,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.lock, size: 28),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: bloqueado
                              ? null
                              : () async =>
                                    await LoginActions.aoClicarEsqueciSenha(
                                      context: context,
                                      email: _emailController.text,
                                      loginViewModel: widget.loginViewModel,
                                    ),

                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: carregandoEmail
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.login),
                              label: Text(
                                carregandoEmail ? 'Entrando...' : 'Entrar',
                              ),
                              onPressed: () async {
                                bloqueado
                                    ? null
                                    : LoginActions.aoClicarEntrarEmail(
                                        context: context,
                                        email: _emailController.text.trim(),
                                        senha: _senhaController.text.trim(),
                                        loginViewModel: widget.loginViewModel,
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: bloqueado
                            ? null
                            : () => Navigator.of(
                                context,
                              ).pushNamed('/registro_usuario'),

                        child: Text(
                          'Não tem conta? Registre-se',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'ou',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: carregandoGoogle
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const FaIcon(FontAwesomeIcons.google),
                              label: Text(
                                carregandoGoogle
                                    ? 'Entrando...'
                                    : 'Continuar com Google',
                              ),
                              onPressed: () async {
                                bloqueado
                                    ? null
                                    : LoginActions.aoClicarEntrarGoogle(
                                        context: context,
                                        loginViewModel: widget.loginViewModel,
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
