import 'package:exemplo_firebase/ui/registro_usuario/view_model/registro_usuario_view_model.dart';
import 'package:flutter/material.dart';

class RegistroUsuarioPage extends StatefulWidget {
  final RegistroUsuarioViewModel registroUsuarioViewModel;

  const RegistroUsuarioPage({
    super.key,
    required this.registroUsuarioViewModel,
  });

  @override
  State<RegistroUsuarioPage> createState() => _RegistroUsuarioPageState();
}

class _RegistroUsuarioPageState extends State<RegistroUsuarioPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dddController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _dddController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _aoClicarCadastrar() async {
    final sucesso = await widget.registroUsuarioViewModel.cadastrar(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      cpf: _cpfController.text.trim(),
      ddd: _dddController.text.trim(),
      telefone: _telefoneController.text.trim(),
      senha: _senhaController.text.trim(),
      confirmarSenha: _confirmarSenhaController.text.trim(),
    );

    if (!mounted) return;
    sucesso ? _mostrarDialogoSucesso() : _mostrarDialogoErro();
  }

  Future<void> _mostrarDialogoSucesso() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Conta criada com sucesso!'),
        content: const Text(
          'Enviamos um link de confirmação para o seu e-mail. '
          'Verifique sua caixa de entrada antes de fazer login.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
              Navigator.of(context).pop(); // Volta para a tela de Login
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoErro() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.registroUsuarioViewModel.mensagemErro,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.registroUsuarioViewModel,
      builder: (context, _) {
        final carregando = widget.registroUsuarioViewModel.carregando;

        return Scaffold(
          appBar: AppBar(title: const Text('Criar Conta')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  maxLength: 100,
                  controller: _nomeController,
                  enabled: !carregando,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Nome Completo *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLength: 120,
                  controller: _emailController,
                  enabled: !carregando,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Email *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLength: 14,
                  controller: _cpfController,
                  enabled: !carregando,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'CPF',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 85,
                      child: TextField(
                        controller: _dddController,
                        enabled: !carregando,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                          labelText: 'DDD',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        maxLength: 15,
                        controller: _telefoneController,
                        enabled: !carregando,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          counterText: '',
                          labelText: 'Telefone / WhatsApp',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLength: 30,
                  controller: _senhaController,
                  enabled: !carregando,
                  obscureText: true,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Senha *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLength: 30,
                  controller: _confirmarSenhaController,
                  enabled: !carregando,
                  obscureText: true,
                  decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Confirmar Senha *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: carregando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          carregando ? 'Cadastrando...' : 'Registrar',
                        ),
                        onPressed: carregando ? null : _aoClicarCadastrar,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
