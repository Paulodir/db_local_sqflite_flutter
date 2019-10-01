import 'dart:async';
import 'package:flutter/material.dart';
import '../helper/pessoa_helper.dart';

class Contato extends StatefulWidget {
  final Person contact;
  final login_id;
  Contato({this.contact,this.login_id});

  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {
  final _nameController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nameFocus = FocusNode();

  Person _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Person();
    } else {
      _editedContact = Person.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.nome;
      _telefoneController.text = _editedContact.telefone;
      _editedContact.login_id = widget.login_id;
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(_editedContact.nome ?? 'Novo contato'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                if (_editedContact.nome != null &&
                    _editedContact.nome.isNotEmpty) {
                  Navigator.pop(context, _editedContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                }
              }),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Nome"),
                  focusNode: _nameFocus,
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.nome = text;
                  },
                  controller: _nameController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Telefone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.telefone = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: _telefoneController,
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
