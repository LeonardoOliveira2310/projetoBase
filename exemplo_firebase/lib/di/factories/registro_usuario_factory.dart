import 'package:exemplo_firebase/data/repositories/auth_repository_impl.dart';
import 'package:exemplo_firebase/data/repositories/usuario_repository_impl.dart';
import 'package:exemplo_firebase/domain/usecases/usuario/cadastrar_usuario_usecase.dart';
import 'package:exemplo_firebase/ui/registro_usuario/registro_usuario_page.dart';
import 'package:exemplo_firebase/ui/registro_usuario/view_model/registro_usuario_view_model.dart';
import 'package:flutter/material.dart';

class RegistroUsuarioFactory {
  static Widget create() {
    // 1. Data
    final authRepository = AuthRepositoryImpl();
    final usuarioRepository = UsuarioRepositoryImpl();

    // 2. Domain
    final cadastrarUsuarioUseCase = CadastrarUsuarioUsecase(
      authRepository: authRepository,
      usuarioRepository: usuarioRepository,
    );

    // 3. ViewModel
    final registroUsuarioViewModel = RegistroUsuarioViewModel(
      cadastrarUsuarioUseCase: cadastrarUsuarioUseCase,
    );

    // 4. View
    return RegistroUsuarioPage(
      registroUsuarioViewModel: registroUsuarioViewModel,
    );
  }
}
