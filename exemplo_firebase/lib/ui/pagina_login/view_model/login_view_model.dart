import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/usecases/login/login_email_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/login/login_google_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/login/recuperar_senha_usecase.dart';
import 'package:flutter/foundation.dart';

enum TipoLoginCarregando { nenhum, email, google }

class LoginViewModel extends ChangeNotifier {
  final LoginEmailUsecase _loginEmailUsecase;
  final LoginGoogleUsecase _loginGoogleUseCase;
  final RecuperarSenhaUseCase _recuperarSenhaUseCase;

  LoginViewModel({
    required LoginEmailUsecase loginEmailUsecase,
    required LoginGoogleUsecase loginGoogleUseCase,
    required RecuperarSenhaUseCase recuperarSenhaUseCase,
  }) : _loginEmailUsecase = loginEmailUsecase,
       _loginGoogleUseCase = loginGoogleUseCase,
       _recuperarSenhaUseCase = recuperarSenhaUseCase;

  TipoLoginCarregando _carregando = TipoLoginCarregando.nenhum;

  // Getters específicos para a UI saber exatamente o que mostrar
  bool get estaCarregando => _carregando != TipoLoginCarregando.nenhum;
  bool get carregandoEmail => _carregando == TipoLoginCarregando.email;
  bool get carregandoGoogle => _carregando == TipoLoginCarregando.google;

  String _mensagemErroLogin = "";
  String get mensagemErroLogin => _mensagemErroLogin;

  Future<bool> logarComEmail(String email, String senha) async {
    if (email.trim().isEmpty || senha.trim().isEmpty) {
      _mensagemErroLogin = 'Email e senha não podem ser vazios';
      notifyListeners();
      return false;
    }

    return _executarLogin(
      TipoLoginCarregando.email,
      () => _loginEmailUsecase(email.trim(), senha.trim()),
    );
  }

  Future<bool> logarComGoogle() async {
    return _executarLogin(
      TipoLoginCarregando.google,
      () => _loginGoogleUseCase(),
    );
  }

  Future<bool> _executarLogin(
    TipoLoginCarregando tipo,
    Future<void> Function() acaoDeLogin,
  ) async {
    _carregando = tipo;
    _mensagemErroLogin = '';
    notifyListeners();

    try {
      await acaoDeLogin();
      _carregando = TipoLoginCarregando.nenhum;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _mensagemErroLogin = e.mensagem;
      _carregando = TipoLoginCarregando.nenhum;
      notifyListeners();
      return false;
    } catch (e) {
      _mensagemErroLogin = 'Ocorreu um erro inesperado.';
      _carregando = TipoLoginCarregando.nenhum;
      notifyListeners();
      return false;
    }
  }

  Future<bool> recuperarSenha(String email) async {
    try {
      await _recuperarSenhaUseCase(email);
      return true;
    } on AuthException catch (e) {
      _mensagemErroLogin = e.mensagem;
      notifyListeners();
      return false;
    } catch (_) {
      _mensagemErroLogin = 'Erro inesperado ao recuperar senha.';
      notifyListeners();
      return false;
    }
  }
}
