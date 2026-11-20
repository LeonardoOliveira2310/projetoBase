import 'package:flutter/widgets.dart'
    show ChangeNotifier, TextEditingController;

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  LoginViewModel();

  String _email = "";
  String get email => _email;
  String _senha = "";
  String get senha => _senha;

  String _mensagemErroLogin = "";
  String get mensagemErroLogin => _mensagemErroLogin;

  bool _carregando = false;
  bool get carregando => _carregando;

  Future<bool> validarLogin() async {
    controllersLogin();

    if (!_email.contains('@') || _email.isEmpty || _senha.isEmpty) return false;

    return true;
  }

  Future<void> controllersLogin() async {
    _email = emailController.text;
    _senha = senhaController.text;

    notifyListeners();
  }

  Future<void> mesagemFalhaNoLogin(String mensagem) async {
    _mensagemErroLogin = mensagem;
    notifyListeners();
  }

  Future<void> estaCarregando(bool carregando) async {
    _carregando = carregando;
    notifyListeners();
  }
}
