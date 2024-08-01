import 'package:aula/estado.dart';
import 'package:flutter/material.dart';

class ModalidadeCard extends StatelessWidget {
  final dynamic modalidade;

  const ModalidadeCard({super.key, required this.modalidade});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(modalidade["_id"]);
      },
      child: Card(
        child: Column(children: [
          Image.asset(
              "lib/recursos/imagens/${modalidade['modalidade']['blobs'][0]['file']}"),
          Row(children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                    "lib/recursos/imagens/${modalidade["company"]["avatar"]}")),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(modalidade["company"]["name"],
                    style: const TextStyle(fontSize: 15))),
          ]),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(modalidade["modalidade"]["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
              child: Text(modalidade["modalidade"]["description"])),
          const Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                    "R\$ ${modalidade['modalidade']['price'].toString()}")),
            Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 5),
                child: Row(children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  Text(modalidade["likes"].toString())
                ])),
          ])
        ]),
      ),
    );
  }
}
