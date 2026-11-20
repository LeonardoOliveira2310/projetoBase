import 'dart:typed_data';
import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';
import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/ui/core/temas/tema_view_model.dart';

import 'package:flutter/material.dart';

class CustomDrawner extends StatelessWidget {
  final UsuarioEntity? usuario;
  final TemaViewModel temaViewModel;
  final VoidCallback aoClicarSair;

  const CustomDrawner({
    super.key,
    required this.usuario,
    required this.temaViewModel,
    required this.aoClicarSair,
  });

  @override
  Widget build(BuildContext context) {
    if (usuario == null) return const SizedBox();
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    style: TextStyle(color: Colors.black87),
                    usuario!.nome,
                  ),
                  accountEmail: Text(
                    style: TextStyle(color: Colors.black87),
                    usuario!.email,
                  ),

                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 40,
                    child: usuario!.fotoUrl != null
                        ? ClipOval(
                            child: FadeInImage.memoryNetwork(
                              placeholder: _transparentImage,
                              image: usuario!.fotoUrl!,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Seletor de Tema Dinâmico
          ListenableBuilder(
            listenable: temaViewModel,
            builder: (context, _) {
              return ListTile(
                leading: Icon(_iconeDoTema(temaViewModel.modoAtual)),
                title: const Text('Tema do App'),
                subtitle: Text(_nomeDoTema(temaViewModel.modoAtual)),
                onTap: () => _mostrarDialogoTema(context),
              );
            },
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: aoClicarSair,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconeDoTema(TemaModoEnum modo) {
    switch (modo) {
      case TemaModoEnum.claro:
        return Icons.light_mode;
      case TemaModoEnum.escuro:
        return Icons.dark_mode;
      case TemaModoEnum.sistema:
        return Icons.brightness_auto;
    }
  }

  String _nomeDoTema(TemaModoEnum modo) {
    switch (modo) {
      case TemaModoEnum.claro:
        return 'Claro';
      case TemaModoEnum.escuro:
        return 'Escuro';
      case TemaModoEnum.sistema:
        return 'Padrão do Sistema';
    }
  }

  void _mostrarDialogoTema(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Escolha o tema'),
        children: [
          _opcaoTema(
            context,
            TemaModoEnum.sistema,
            'Padrão do Sistema',
            Icons.brightness_auto,
          ),
          _opcaoTema(context, TemaModoEnum.claro, 'Claro', Icons.light_mode),
          _opcaoTema(context, TemaModoEnum.escuro, 'Escuro', Icons.dark_mode),
        ],
      ),
    );
  }

  Widget _opcaoTema(
    BuildContext context,
    TemaModoEnum modo,
    String titulo,
    IconData icone,
  ) {
    final selecionado = temaViewModel.modoAtual == modo;
    return SimpleDialogOption(
      onPressed: () {
        temaViewModel.alterarTema(modo);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            icone,
            color: selecionado ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (selecionado)
            Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

final Uint8List _transparentImage = Uint8List.fromList(<int>[
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, //
  0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x21, 0xf9, 0x04, 0x01, 0x00, //
  0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, //
  0x00, 0x02, 0x01, 0x44, 0x00, 0x3B,
]);
