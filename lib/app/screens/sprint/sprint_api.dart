import 'dart:convert';
import 'package:http/http.dart';
import 'package:scrum_deck/shared/models/sprint.dart';
import 'package:scrum_deck/util/constants.dart';

class SprintApi
{
  final Client _client;
  Map<int, Sprint> _fetchedSprints = Map();

  // constructor
  SprintApi(this._client);

  Future <List<Sprint>> fetchSprints() async {
    final response = await _client.get(Uri.parse('${Constants.API_BASE_URL}/sprint'));
    if(response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonSprints = json.decode(response.body);
      final sprints = jsonSprints.map((item) => Sprint.fromJson(item)).toList();
      sprints.sort((a, b) => (a.nome).compareTo(b.nome));
      return sprints;
    } else {
      throw Exception('Erro ao carregar as sprints');
    }
  }

  Future insertSprint(String nome, String link) async {
    final response = await _client.post(
      Uri.parse('${Constants.API_BASE_URL}/sprint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'nome': nome,
        'link': link
      })
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Erro ao inserir sprint');
    }
  }

  // TODO: implementar quando tiver no backend
  Future updateSprint(int sprintId, String nome, String link) async {
    /*
    final response = await _client.post(
      Uri.parse('${Constants.API_BASE_URL}/sprint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'nome': nome,
        'link': link
      })
    );

    if(response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Erro ao inserir sprint');
    }
    */
    return true;
  }
  
  Future deleteSprint(int sprintId) async {
    final response = await _client.delete(Uri.parse('${Constants.API_BASE_URL}/sprint/$sprintId'));
    print(response.body);
    if(response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception('Erro ao deletar sprint');
    }
  }

}