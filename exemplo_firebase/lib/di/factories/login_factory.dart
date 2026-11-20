import 'package:exemplo_firebase/data/repositories/auth_repository_impl.dart';
import 'package:exemplo_firebase/domain/usecases/login/login_email_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/login/login_google_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/login/recuperar_senha_usecase.dart';

import 'package:exemplo_firebase/ui/pagina_login/pagina_login.dart';
import 'package:exemplo_firebase/ui/pagina_login/view_model/login_view_model.dart';

import 'package:flutter/material.dart';

class LoginFactory {
  static Widget create() {
    // 1. Data: Instancia quem conversa com o Firebase
    final authRepository = AuthRepositoryImpl();
    // 2. Domain: Instancia as regras de negócio injetando o repositório
    final loginEmailUsecase = LoginEmailUsecase(authRepository);
    final loginGoogleUsecase = LoginGoogleUsecase(authRepository);
    final recuperarSenhaUseCase = RecuperarSenhaUseCase(authRepository);
    // 3. UI (ViewModel): Instancia o ViewModel injetando os casos de uso
    final loginViewModel = LoginViewModel(
      loginEmailUsecase: loginEmailUsecase,
      loginGoogleUseCase: loginGoogleUsecase,
      recuperarSenhaUseCase: recuperarSenhaUseCase,
    );
    // 4. UI (View): Retorna a tela pronta com o seu ViewModel
    return PaginaLogin(loginViewModel: loginViewModel);
  }
}
