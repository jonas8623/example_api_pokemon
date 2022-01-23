import 'package:example_api_pokemon/constant.dart';
import 'package:example_api_pokemon/model/model.dart';
import 'package:flutter/material.dart';

class PokemonDetail extends StatefulWidget {

  final Pokemon? pokemon;
  final int? id;

  const PokemonDetail({Key? key, this.pokemon, this.id}) : super(key: key);

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhe do ${widget.pokemon!.name}'),),
      body: Center(
        child: Column(
          children: [
            Image.network('${Constant.image}${widget.id}.png'),
            Text('${widget.pokemon!.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),)
          ],
        ),
      ),
    );
  }
}
