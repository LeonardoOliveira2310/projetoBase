import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';

class LoginGoogleUsecase {
  final AuthRepository _repository;

  LoginGoogleUsecase(this._repository);

  Future<void> call() async {
    await _repository.loginComGoogle();
  }
}
