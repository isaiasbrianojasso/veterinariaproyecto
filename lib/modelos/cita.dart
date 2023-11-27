import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
//cita
class cita extends StatefulWidget {
  const cita({Key? key}) : super(key: key);

  @override
  _CitaListScreenState createState() => _CitaListScreenState();
}

class _CitaListScreenState extends State<cita> {
  late Database _database;
  late List<Map<String, dynamic>> _citas;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'clinicavet.db'),
      version: 1,
    );
    _loadCita();
  }

  Future<void> _loadCita() async {
    final List<Map<String, dynamic>> citas = await _database.query('Cita');
    setState(() {
      _citas = citas;
    });
  }

  Future<void> _addCita(String nombre_paciente, String nombre_cliente, String hora, String cita) async {
    final newCita = {
      'nombre_paciente': nombre_paciente,
      'nombre_cliente': nombre_cliente,
      'hora': hora,
      'cita': cita,
    };

    await _database.insert('Cita', newCita);
    _loadCita();
  }

  Future<void> _editCita(int citaId) async {
    // Obtener la cita actual
    Map<String, dynamic> citaToEdit = _citas.firstWhere(
          (cita) => cita['id'] == citaId,
    );
    String nombre_paciente = citaToEdit['nombre_paciente'] ?? '';
    String nombre_cliente = citaToEdit['nombre_cliente'] ?? '';
    String hora = citaToEdit['hora'] ?? '';
    String cita = citaToEdit['cita'] ?? '';

    // Mostrar el modal para editar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditCitaDialog(nombre_paciente, nombre_cliente, hora, cita, citaId);
      },
    );
  }

  Future<void> _updateCita(int citaId, String nombre_paciente, String nombre_cliente, String hora, String cita) async {
    await _database.update(
      'Cita',
      {'nombre_paciente': nombre_paciente, 'nombre_cliente': nombre_cliente, 'hora': hora, 'cita': cita},
      where: 'id = ?',
      whereArgs: [citaId],
    );

    _loadCita();
  }

  Future<void> _deleteCita(int citaId) async {
    await _database.delete('Cita', where: 'id = ?', whereArgs: [citaId]);
    _loadCita();
  }

  @override
  late Color myColor;
  late Size mediaSize;
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Citas'),
        backgroundColor: Color.fromARGB(255, 42, 104, 44),
      ),
      backgroundColor: Colors.green,
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _citas.length,
          itemBuilder: (context, index) {
            final cita = _citas[index];
            return ListTile(
              title: Text(cita['nombre_paciente']),
              subtitle: Text(cita['nombre_cliente']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editCita(cita['id']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteCita(cita['id']);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildAddCitaDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddCitaDialog() {
    String nombre_paciente = '';
    String nombre_cliente = '';
    String hora = '';
    String cita = '';

    return AlertDialog(
      title: Text('Agregar Cita'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              nombre_paciente = value;
            },
            decoration: InputDecoration(labelText: 'Nombre del paciente'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              nombre_cliente = value;
            },
            decoration: InputDecoration(labelText: 'Nombre del cliente'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              hora = value;
            },
            decoration: InputDecoration(labelText: 'Hora'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              cita = value;
            },
            decoration: InputDecoration(labelText: 'Cita'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _addCita(nombre_paciente, nombre_cliente, hora, cita);
            Navigator.pop(context);
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }

  Widget _buildEditCitaDialog(String nombre_paciente, String nombre_cliente, String hora, String cita, int citaId) {
    String editedNombrePaciente = nombre_paciente;
    String editedNombreCliente = nombre_cliente;
    String editedHora = hora;
    String editedCita = cita;

    return AlertDialog(
      title: Text('Editar Cita'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              editedNombrePaciente = value;
            },
            controller: TextEditingController(text: nombre_paciente),
            decoration: InputDecoration(labelText: 'Nombre del paciente'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedNombreCliente = value;
            },
            controller: TextEditingController(text: nombre_cliente),
            decoration: InputDecoration(labelText: 'Nombre del cliente'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedHora = value;
            },
            controller: TextEditingController(text: hora),
            decoration: InputDecoration(labelText: 'Hora'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedCita = value;
            },
            controller: TextEditingController(text: cita),
            decoration: InputDecoration(labelText: 'Cita'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _updateCita(citaId, editedNombrePaciente, editedNombreCliente, editedHora, editedCita);
            Navigator.pop(context);
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
