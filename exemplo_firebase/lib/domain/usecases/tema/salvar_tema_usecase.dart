import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';
import 'package:exemplo_firebase/domain/repositories/tema_repository.dart';

class SalvarTemaUsecase {
  final TemaRepository _temaRepository;
  SalvarTemaUsecase(this._temaRepository);

  Future<void> call(TemaModoEnum modo) => _temaRepository.salvarModoTema(modo);
}
