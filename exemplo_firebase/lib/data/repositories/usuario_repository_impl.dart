import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/data/models/usuario_model.dart';
import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/exceptions/auth_exceptions.dart';
import 'package:exemplo_firebase/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final FirebaseFirestore _firestore;

  UsuarioRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> salvarUsuario(UsuarioEntity usuario) async {
    try {
      final model = UsuarioModel.fromEntity(usuario);
      await _firestore
          .collection('usuarios')
          .doc(usuario.uid)
          .set(model.toMap());
    } on FirebaseException catch (e) {
      throw AuthException('Erro ao salvar dados no banco: ${e.message}');
    } catch (e) {
      throw AuthException('Erro inesperado ao gravar perfil do usuário.');
    }
  }

  @override
  Future<UsuarioEntity?> buscarUsuarioPorUid(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UsuarioModel.fromMap(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw AuthException('Erro ao buscar perfil: ${e.message}');
    }
  }
}
