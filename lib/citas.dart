import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Database _database;
  late List<Map<String, dynamic>> _citas;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String nombre_paciente = '';
  String nombre_cliente = '';
  String cita = '';
  String hora = '';

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

  Future<void> _addCita(
      String nombrePaciente, String nombreCliente, String hora, String cita) async {
    final newCita = {
      'nombre_paciente': nombrePaciente,
      'nombre_cliente': nombreCliente,
      'hora': hora,
      'cita': cita,
    };

    await _database.insert('Cita', newCita);
    _loadCita();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        cita = picked.toString();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        hora = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Cita'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recuerde que nuestro horario es de \n 10 a.m - 9 p.m. \n de Lunes a Sabado',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: const Color.fromARGB(255, 13, 77, 15)),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Fecha:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              selectedDate != null
                  ? "${selectedDate!.toLocal()}".split(' ')[0]
                  : "Selecciona una fecha",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Seleccionar Fecha'),
            ),
            SizedBox(height: 40),
            Text(
              'Hora:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              selectedTime != null
                  ? "${selectedTime!.hour}:${selectedTime!.minute}"
                  : "Selecciona una hora",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Seleccionar Hora'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addCita(nombre_paciente, nombre_cliente, hora, cita);
                Navigator.pop(context);

                // Lógica para registrar fecha en base de datos
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 8, 87, 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Agendar Cita',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
