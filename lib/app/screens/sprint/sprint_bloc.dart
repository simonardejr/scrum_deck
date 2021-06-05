import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_api.dart';
import 'package:scrum_deck/shared/models/sprint.dart';

class SprintBloc extends BlocBase
{
  final SprintApi _api;
  late final _sprintFetcher = PublishSubject<List<Sprint>>();
  late final _loading = BehaviorSubject<bool>();

  // constructor
  SprintBloc(this._api);

  Stream<List<Sprint>> get sprintsStream => _sprintFetcher.stream;
  Stream<bool> get loadingStream => _loading.stream;

  doFetch() async {
    _loading.sink.add(true);

    final sprints = await _api.fetchSprints();
    _sprintFetcher.sink.add(sprints);

    _loading.sink.add(false);
  }

  doInsert(String nome, String link) async {
    await _api.insertSprint(nome, link);
  }

  doUpdate(int sprintId, String nome, String link) async {
    await _api.updateSprint(sprintId, nome, link);
  }

  doDelete(int sprintId) async {
    await _api.deleteSprint(sprintId);
  }

  @override
  void dispose() {
    _sprintFetcher.close();
    _loading.close();
    super.dispose();
  }

}