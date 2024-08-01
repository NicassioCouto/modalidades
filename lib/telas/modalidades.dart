import 'dart:convert';

import 'package:aula/autenticador.dart';
import 'package:aula/componentes/modalidadecard.dart';
import 'package:aula/estado.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Modalidades extends StatefulWidget {
  const Modalidades({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ModalidadesState();
  }
}

const int tamanhoPagina = 4;

class _ModalidadesState extends State<Modalidades> {
  late dynamic _feedEstatico;
  List<dynamic> _modalidades = [];

  int _proximaPagina = 1;
  bool _carregando = false;

  late TextEditingController _controladorFiltragem;
  String _filtro = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _controladorFiltragem = TextEditingController();
    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String conteudoJson =
        await rootBundle.loadString("lib/recursos/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    _carregarModalidades();
  }

  void _carregarModalidades() {
    setState(() {
      _carregando = true;
    });

    var maisModalidades = [];
    if (_filtro.isNotEmpty) {
      _feedEstatico["modalidades"].where((item) {
        String nome = item["modalidade"]["name"];

        return nome.toLowerCase().contains(_filtro.toLowerCase());
      }).forEach((item) {
        maisModalidades.add(item);
      });
    } else {
      maisModalidades = _modalidades;

      final totalModalidadesParaCarregar = _proximaPagina * tamanhoPagina;
      if (_feedEstatico["modalidades"].length >= totalModalidadesParaCarregar) {
        maisModalidades = _feedEstatico["modalidades"]
            .sublist(0, totalModalidadesParaCarregar);
      }
    }

    setState(() {
      _modalidades = maisModalidades;
      _proximaPagina = _proximaPagina + 1;

      _carregando = false;
    });
  }

  Future<void> _atualizarModalidades() async {
    _modalidades = [];
    _proximaPagina = 1;

    _carregarModalidades();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 60, right: 20),
                    child: TextField(
                      controller: _controladorFiltragem,
                      onSubmitted: (descricao) {
                        _filtro = descricao;

                        _atualizarModalidades();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search)),
                    ))),
            usuarioLogado
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        estadoApp.onLogout();
                      });

                      Toast.show("Você não está mais conectado",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.logout))
                : IconButton(
                    onPressed: () {
                      Usuario usuario =
                          Usuario("Nicássio Couto", "nicacio@gmail.com");

                      setState(() {
                        estadoApp.onLogin(usuario);
                      });

                      Toast.show("Você foi conectado com sucesso",
                          duration: Toast.lengthLong, gravity: Toast.bottom);
                    },
                    icon: const Icon(Icons.login))
          ],
        ),
        body: FlatList(
            data: _modalidades,
            numColumns: 2,
            loading: _carregando,
            onRefresh: () {
              _filtro = "";
              _controladorFiltragem.clear();

              return _atualizarModalidades();
            },
            onEndReached: () => _carregarModalidades(),
            buildItem: (item, int indice) {
              return SizedBox(
                  height: 400, child: ModalidadeCard(modalidade: item));
            }));
  }
}
