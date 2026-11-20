import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/usecases/usuario/cadastrar_usuario_usecase.dart';
import 'package:flutter/material.dart';

class RegistroUsuarioViewModel extends ChangeNotifier {
  final CadastrarUsuarioUsecase _cadastrarUsuarioUseCase;
  RegistroUsuarioViewModel({
    required CadastrarUsuarioUsecase cadastrarUsuarioUseCase,
  }) : _cadastrarUsuarioUseCase = cadastrarUsuarioUseCase;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _mensagemErro = '';
  String get mensagemErro => _mensagemErro;

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String cpf,
    required String ddd,
    required String telefone,
    required String senha,
    required String confirmarSenha,
  }) async {
    _mensagemErro = '';

    // 1. Validações de UI
    if (nome.trim().isEmpty ||
        email.trim().isEmpty ||
        senha.trim().isEmpty ||
        confirmarSenha.trim().isEmpty) {
      _mensagemErro = 'Preencha todos os campos obrigatórios (*).';
      notifyListeners();
      return false;
    }

    if (senha != confirmarSenha) {
      _mensagemErro = 'As senhas digitadas não conferem.';
      notifyListeners();
      return false;
    }

    if (senha.length < 6) {
      _mensagemErro = 'A senha deve ter pelo menos 6 caracteres.';
      notifyListeners();
      return false;
    }

    // 2. Inicia carregamento e aciona o UseCase
    _carregando = true;
    notifyListeners();

    try {
      final novoUsuario = UsuarioEntity(
        uid: '', // Será preenchido pelo Firebase Auth dentro do UseCase
        nome: nome.trim(),
        email: email.trim(),
        cpf: cpf.trim(),
        ddd: ddd.trim(),
        telefone: telefone.trim(),
      );

      await _cadastrarUsuarioUseCase(dadosUsuario: novoUsuario, senha: senha);

      _carregando = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _mensagemErro = e.mensagem;
      _carregando = false;
      notifyListeners();
      return false;
    } catch (e) {
      _mensagemErro = 'Ocorreu um erro inesperado ao criar sua conta.';
      _carregando = false;
      notifyListeners();
      return false;
    }
  }
}
