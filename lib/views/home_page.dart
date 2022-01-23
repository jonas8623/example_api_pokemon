import 'package:example_api_pokemon/constant.dart';
import 'package:example_api_pokemon/model/model.dart';
import 'package:example_api_pokemon/service/service.dart';
import 'package:example_api_pokemon/views/views.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _progress = false;
  List<Pokemon?>? _pokemonList;
  int _count = 0;
  int _page = 1;

  Widget _title(Pokemon? pokemon) {
    return Text('${pokemon!.name}', style: const TextStyle(
        color: Colors.black87,
        fontSize: 18.5,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _subtitle(Pokemon? pokemon) {
    return Text('${pokemon!.url}');
  }

  Widget _showPokemon() {
    if(_pokemonList == null) {
      return const Text('Nenhum pokemon', style: TextStyle(color: Colors.red, fontSize: 18.9),);
    }
    return SafeArea(
      child: ListView.builder(

          itemCount: _pokemonList!.length,
          itemBuilder: (context, index) {

            final pokemon = _pokemonList!.elementAt(index);

            return Card(
              elevation: 4.4,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12.3), borderSide: BorderSide.none),
              shadowColor: Colors.grey,

              child: ListTile(
                contentPadding: const EdgeInsets.all(22.4),
                title: _title(pokemon),
                subtitle: _subtitle(pokemon),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  backgroundImage: NetworkImage('${Constant.image}${index + 1}.png'),
                ),
                onTap: () {
                  print('Clicou no pokemon -> ${pokemon!.name}');
                  // Abrir a tela de detalhe
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => PokemonDetail(pokemon: pokemon, id: index + 1,))
                  );
                },
              ),
            );
          }
      ),
    );
  }

  Widget _rowProgress() {
    return _progress ? const CircularProgressIndicator() : Container();
  }

  Widget _rowPage() {
    return Text('$_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 600,
              margin: const EdgeInsets.fromLTRB(22.1, 10.2, 22.1, 0.0),
              padding: const EdgeInsets.all(20.5),
              child: _showPokemon(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               _count > 0 ?  TextButton.icon(onPressed: () async => _previous(context), icon: const Icon(Icons.arrow_back_outlined), label: const Text('Anteriror')) : Container(),
               _pokemonList != null ? TextButton.icon(onPressed: () async => _next(context), icon: const Icon(Icons.arrow_forward_outlined), label: const Text('Próximo')) : Container(),
              ],
            ),
            _rowProgress(),
            const SizedBox(height: 50,),
            _rowPage()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _fetchPokemon(context);
        },
        child: const Icon(Icons.search_outlined),
      ),
    );
  }

  _fetchPokemon(BuildContext context) async {

    _count = 0;
    _page = 1;
    final pokemonService = PokemonService();

    setState(() {
      _progress = true;
    });

    _showSnackBar(context, 'Aguarde baixando pokemons');
    _pokemonList = await pokemonService.fetchPokemon();

    setState(() {
      _progress = false;
    });

  }

  _previous(BuildContext context) async {

    final pokemonService = PokemonService();
    _count = _count - 20;
    _page--;

    setState(() {
      _progress = true;
    });

    _pokemonList = await pokemonService.fetchNextPreviousPokemon(offset: _count);

    setState(() {
      _progress = false;
    });
  }

  _next(BuildContext context) async {

    final pokemonService = PokemonService();
    _count = _count + 20;
    _page++;

    setState(() {
      _progress = true;
    });

    _pokemonList = await pokemonService.fetchNextPreviousPokemon(offset: _count);

    setState(() {
      _progress = false;
    });
  }

  _showSnackBar(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

}
