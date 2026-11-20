import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';

class LoginEmailUsecase {
  final AuthRepository _repository;

  LoginEmailUsecase(this._repository);

  Future<void> call(String email, String senha) async {
    final emailVerificado = await _repository.loginComEmailESenha(email, senha);

    if (!emailVerificado) {
      await _repository.enviarEmailDeVerificacao();
      throw EmailNaoVerificadoException();
    }
  }
}
