import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';
import 'package:exemplo_firebase/domain/repositories/tema_repository.dart';

class ObterTemaUsecase {
  final TemaRepository _temaRepository;

  ObterTemaUsecase(this._temaRepository);

  Future<TemaModoEnum> call() => _temaRepository.obterModoTema();
}
