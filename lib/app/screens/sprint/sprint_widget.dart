import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';
import 'package:scrum_deck/shared/models/sprint.dart';

class SprintWidget extends StatelessWidget {

  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();

  @override
  Widget build(BuildContext context) {

    _bloc.doFetch();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Sprints'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/sprintForm');
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.sprintsStream,
        builder: (_, AsyncSnapshot<List<Sprint>> snapshot) {
          if(snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final sprint = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.sort),),
                  title: Text('${sprint.nome}'),
                  subtitle: Text('${sprint.link}'),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.orange,
                          onPressed: () {
                            /*
                            Navigator.of(context).pushNamed(
                              '/sprintForm',
                              arguments: sprint
                            );
                            */
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Não implementado ainda!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Text('Ok!')
                                    ),
                                  ],
                                )
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Excluir Sprint?'),
                                  content: Text('Essa ação não poderá ser desfeita'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Text('Não')
                                    ),
                                    TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: Text('Sim')
                                    ),
                                  ],
                                )
                            ).then((confirmed) => {
                              if(confirmed) {
                                _bloc.doDelete(sprint.id).then(
                                  (_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Deletado com sucesso!'))
                                    );
                                    _bloc.doFetch();
                                  }).catchError(
                                    (_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text('Aconteceu um erro, por favor, tente novamente!', style: TextStyle(color: Colors.red),)
                                          )
                                      );
                                    }
                                )
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: (MediaQuery.of(context).size.height / 3) - 35,
                            margin: EdgeInsets.only(top: 30),
                            child: Column(
                              children: [
                                Text('${sprint.nome}', style: TextStyle(fontSize: 20),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('${sprint.link}', style: TextStyle(fontSize: 15),),
                                SizedBox(
                                  height: 110,
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Fechar detalhes'),
                                )
                              ],
                            ),
                          );
                        }
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => Divider(),
            );
          } else {
            return StreamBuilder(
              stream: _bloc.loadingStream,
              builder: (_, AsyncSnapshot<bool> snapshot) {
                final loading = snapshot.data ?? false;
                if(loading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }
}
