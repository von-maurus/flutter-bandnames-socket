import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

// Como extraer metodo de un Widget:
// 1-Seleccionar porcion de codigo (widgets o arbol)
// 2-click derecho, ir a refactor
// 3-Seleccionar Extract Method, dar un nombre y listo
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> _bandList = [
    Band(id: '1', name: 'Nirvana', votes: 0),
    Band(id: '2', name: 'Alice In Chains', votes: 0),
    Band(id: '3', name: 'Korn', votes: 0),
    Band(id: '4', name: 'Nümberg', votes: 0),
    Band(id: '5', name: 'Radiohead', votes: 0),
    Band(id: '6', name: 'Foo Fighters', votes: 0),
    Band(id: '7', name: 'The Ramones', votes: 0),
    Band(id: '8', name: 'Misfits', votes: 0),
    Band(id: '9', name: 'MetallicA', votes: 0),
    Band(id: '10', name: 'Alt J', votes: 0),
    Band(id: '11', name: 'Blur', votes: 0),
    Band(id: '12', name: 'Daft Punk', votes: 0),
    Band(id: '13', name: 'Deadmau5', votes: 0),
    Band(id: '14', name: 'Linkin Park', votes: 0),
    Band(id: '15', name: 'Franz Ferdinand', votes: 0),
    Band(id: '16', name: 'Rammstein', votes: 0),
    Band(id: '17', name: 'Slayer', votes: 0),
    Band(id: '18', name: 'Death', votes: 0)
  ];

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Choose Your Band",
          style: TextStyle(
            fontSize: 22.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: _bandList.length,
          itemBuilder: (context, index) =>
              buildBandTile(_bandList[index], context, index)),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget buildBandTile(Band band, BuildContext context, int index) {
    String whatHappened;
    int _movementDuration = 480;
    //key es un identificador unico
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      crossAxisEndOffset: 0,
      dismissThresholds: {DismissDirection.startToEnd: 0.78},
      movementDuration: Duration(milliseconds: _movementDuration),
      confirmDismiss: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            whatHappened = 'ELIMINADO';
            return _showConfirmationDialog(
                context, 'eliminar', this._bandList[index]);
        }
        return false;
      },
      onDismissed: (direction) {
        //TODO: Llamar al delete del backend
        setState(() {
          print(index);
          this._bandList.removeAt(index);
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          elevation: 4,
          content: Text("${band.name} ha sido $whatHappened"),
          duration: Duration(milliseconds: 750),
        ));
      },
      background: Container(
        padding: EdgeInsets.only(left: 15.0),
        color: Colors.red.shade400,
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                setState(() {
                  print(index);
                  this._bandList.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  elevation: 4,
                  content: Text("${band.name} ha sido $whatHappened"),
                  duration: Duration(milliseconds: 750),
                ));
              },
              child: Icon(
                Icons.remove_circle,
                color: Colors.white,
              ),
              height: 1,
            ),
            Text(
              "Eliminar",
              style: TextStyle(
                  fontSize: 18.0, letterSpacing: 1.5, color: Colors.white),
            ),
          ],
        ),
      ),
      child: ListTile(
          trailing: Text(
            band.votes.toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          onTap: () => {
                //  ir a detalles de la banda
              },
          title: Text(
            band.name,
            style: TextStyle(fontSize: 19.0),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 25.0,
            child: Text(band.name.substring(0, 3)),
          )),
    );
  }

  addNewBand() {
    //Para mostrar un dialog en iOS o Android, importar la clase Platform
    //Cupertino para iOS
    //Material para Android
    final textController = new TextEditingController();
    //TODO: Llamar al create del backend
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("New band name"),
              elevation: 2,
              content: TextField(
                controller: textController,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(11.0))),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Save"),
                  onPressed: () => insertBand(
                    textController.text,
                  ),
                  elevation: 5,
                  textColor: Colors.black87,
                ),
                MaterialButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.pop(context),
                  elevation: 5,
                  textColor: Colors.black87,
                )
              ],
            );
          });
    } else if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text("New band name"),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Save"),
                    onPressed: () => insertBand(
                          textController.text,
                        )),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Cerrar"),
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

  void insertBand(String name) {
    if (name.length > 1) {
      this._bandList.add(Band(
          id: DateTime.now().toString(), name: name, votes: 0, image: null));
    }
    setState(() {
      print(Band());
    });
    Navigator.pop(context);
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String action, Band band) {
    if (Platform.isAndroid) {
      return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "¿Esta seguro que desea $action a ${band.name}?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.5,
                ),
              ),
              elevation: 2,
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  elevation: 5,
                  textColor: Colors.black87,
                ),
                MaterialButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  elevation: 5,
                  textColor: Colors.black87,
                )
              ],
            );
          });
    } else if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text("¿Esta seguro que desea $action?}"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                CupertinoDialogAction(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    })
              ],
            );
          });
    }
  }
}
