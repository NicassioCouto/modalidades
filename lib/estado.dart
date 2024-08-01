// ignore_for_file: unnecessary_getters_setters

import 'package:aula/autenticador.dart';
import 'package:flutter/material.dart';

enum Situacao { mostrandoModalidades, mostrandoDetalhes }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.mostrandoModalidades;
  Situacao get situacao => _situacao;

  late int _idModalidade;
  int get idModalidade => _idModalidade;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  void mostrarModalidades() {
    _situacao = Situacao.mostrandoModalidades;

    notifyListeners();
  }

  void mostrarDetalhes(int idModalidade) {
    _situacao = Situacao.mostrandoDetalhes;
    _idModalidade = idModalidade;

    notifyListeners();
  }

  void onLogin(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void onLogout() {
    _usuario = null;

    notifyListeners();
  }
}

late EstadoApp estadoApp;
