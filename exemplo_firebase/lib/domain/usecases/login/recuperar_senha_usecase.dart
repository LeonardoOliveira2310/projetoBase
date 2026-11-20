import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';

class RecuperarSenhaUseCase {
  final AuthRepository _repository;
  RecuperarSenhaUseCase(this._repository);

  Future<void> call(String email) async {
    final emailLimpo = email.trim();
    if (email.isEmpty) {
      throw AuthException('Digite seu email para recuperar a senha');
    }
    await _repository.enviarEmailRecuperacaoSenha(emailLimpo);
  }
}
