import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';
import 'package:scrum_deck/shared/models/sprint.dart';

class SprintForm extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();

  void _loadFormData(Sprint sprint) {
    _formData['nome'] = '';
    _formData['link'] = '';
    if (sprint.nome.isNotEmpty) {
      _formData['nome'] = sprint.nome;
    }
    if (sprint.link.isNotEmpty) {
      _formData['link'] = sprint.link;
    }
  }

  @override
  Widget build(BuildContext context) {

    var _title = 'Adicionar Sprint';
    var _editAction = false;

    if(ModalRoute.of(context)?.settings.arguments != null) {
      final sprint = ModalRoute.of(context)?.settings.arguments as Sprint;
      _loadFormData(sprint);
      _title = 'Editar Sprint';
      _editAction = true;
    }

    late TextEditingController nomeController = TextEditingController(text: _formData['nome']);
    late TextEditingController linkController = TextEditingController(text: _formData['link']);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_title}'),
        actions: [
          IconButton(
              onPressed: () {
                // final isValid = _form.currentState?.validate();
                if(_form.currentState!.validate()) {
                  _form.currentState!.save();
                  if(!_editAction) {
                    _bloc.doInsert(nomeController.text, linkController.text)
                        .then((_) {
                          Navigator.of(context).pop();
                          _bloc.doFetch();
                        });
                  } else {
                    _bloc.doUpdate(1, nomeController.text, linkController.text)
                        .then(() {
                          Navigator.of(context).pop();
                          _bloc.doFetch();
                        });
                  }
                }
              },
              icon: Icon(Icons.save)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                // initialValue: _formData['nome'],
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) {
                    return 'O nome não pode ser vazio.';
                  }
                  return null;
                },
                onSaved: (value) => _formData['sprint'] = value!,
              ),
              TextFormField(
                controller: linkController,
                // initialValue: _formData['link'],
                decoration: InputDecoration(labelText: 'Link'),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) {
                    return 'A url não pode ser vazia.';
                  }

                  if(!Uri.parse(value).isAbsolute) {
                    return 'Indique uma url válida';
                  }

                  return null;
                },
                onSaved: (value) => _formData['link'] = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
