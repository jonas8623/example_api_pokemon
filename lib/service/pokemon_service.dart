import 'dart:convert';
import 'package:example_api_pokemon/constant.dart';
import 'package:example_api_pokemon/model/model.dart';
import 'package:http/http.dart' as http;

abstract class AbstractPokemonService {

  Future<List<Pokemon>?>? fetchPokemon();
  Future<List<Pokemon>?>? fetchNextPreviousPokemon({required int offset});

}

class PokemonService extends AbstractPokemonService {

  @override
  Future<List<Pokemon>?>? fetchNextPreviousPokemon({required int offset}) async {
    final url = Uri.https(
        '${Constant.baseUrl}',
        '${Constant.path}${Constant.endPoint}',
        {'offset':'$offset', 'limit':'{20}'}); // Paginação

    final response = await http.Client().get(url);

    if(response.statusCode != 200) {
      print('Erro na paginação');
      return [];
    }

    print('Response -> ${response.body.toString()}');// Vai retornar a resposta da minha requisição

    return parsedJson(response.body);

  }

  @override
  Future<List<Pokemon>?>? fetchPokemon() async {
    final url = Uri.https('${Constant.baseUrl}', '${Constant.path}${Constant.endPoint}');

    final response = await http.Client().get(url);

    if(response.statusCode != 200) {
      print('Status Code -> ${response.statusCode}');
      return [];
    }

    print('Response -> ${response.body.toString()}');// Vai retornar a resposta da minha requisição
    print('Status Code -> ${response.statusCode}');

    return parsedJson(response.body);

  }

  List<Pokemon> parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    List<dynamic> pokemons = jsonDecoded['results']; // Para pegar o resultado do Json

    return pokemons.map((element) => Pokemon.fromJson(element)).toList();
  }

}