import 'package:flutter/material.dart';

class acerca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la Veterinaria'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/log.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Nina´s Vet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Dirección: Calle Principal #123',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Teléfono: (123) 456-7890',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Correo Electrónico: info@veterinariaxyz.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Bienvenido a Nina´s Vet. Brindamos atención médica integral para tus mascotas. Nuestro equipo de veterinarios altamente calificados está aquí para ayudarte con las necesidades de salud y bienestar de tus animales.',
                style: TextStyle(fontSize: 23),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
