import 'package:exemplo_firebase/ui/pagina_login/view_model/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AutenticacaoGoogle {
  AutenticacaoGoogle({required LoginViewModel loginViewModel})
    : _loginViewModel = loginViewModel;
  final LoginViewModel _loginViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> acessarComGoogle() async {
    try {
      final GoogleSignInAccount? usuarioGoogle = await GoogleSignIn().signIn();

      if (usuarioGoogle == null) {
        return null;
      }

      final GoogleSignInAuthentication autenticacaoGoogle =
          await usuarioGoogle.authentication;

      final credencial = GoogleAuthProvider.credential(
        accessToken: autenticacaoGoogle.accessToken,
        idToken: autenticacaoGoogle.idToken,
      );

      return await _auth.signInWithCredential(credencial);
    } catch (e) {
      _loginViewModel.mesagemFalhaNoLogin('Erro no login com Google: $e');
      debugPrint('Erro no login com Google: $e');
      rethrow;
    }
  }
}
