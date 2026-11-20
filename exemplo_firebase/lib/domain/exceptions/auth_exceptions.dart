class AuthException implements Exception {
  final String mensagem;
  AuthException(this.mensagem);
}

class EmailNaoVerificadoException extends AuthException {
  EmailNaoVerificadoException()
    : super('Email não verificado, favor checar seu email');
}
