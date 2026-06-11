import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MiApp());
}
class MiApp extends StatelessWidget {
  const MiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba App',
      home: const PantallaInicio(),
    );
  }
}
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});
  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}
class _PantallaInicioState extends State<PantallaInicio> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Registro Participante',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'ID Participante',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: edadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Edad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), //OutlinerInputBorder // InputDecoration
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // ignore: avoid_print
                    print('Edad: ${edadController.text}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PantallaTarea(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    child: Text(
                      'INICIAR',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PantallaTarea extends StatefulWidget {
  const PantallaTarea({super.key});
  @override
  State<PantallaTarea> createState() => _PantallaTareaState();
}

class _PantallaTareaState extends State<PantallaTarea> {
  bool mostrarVerde = false;
  final Offset puntoNegro = const Offset(150, 300);
  final Offset puntoVerde = const Offset(500, 450);
  List<Offset> trayectoria = [];
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        mostrarVerde = true;
      });
    });
  }
  void siguienteEnsayo() {
    setState(() {
      trayectoria = [];
      mostrarVerde = false;
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        mostrarVerde = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: (details) {

          setState(() {
            trayectoria.add(details.localPosition);
          });

          double distance = 
              (details.localPosition - puntoVerde).distance;
              if (distance < 30) {
                siguienteEnsayo();
              }
        },
        child: CustomPaint(
          painter: TrayectoriaPainter(trayectoria),
          child: Stack(
            children: [
              Positioned(
                left: puntoNegro.dx - 30,
                top: puntoNegro.dy - 30,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (mostrarVerde)
                Positioned(
                  left: puntoVerde.dx - 30,
                  top: puntoVerde.dy - 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrayectoriaPainter extends CustomPainter {
  final List<Offset> puntos;
  TrayectoriaPainter(this.puntos);
  @override
  void paint(Canvas canvas, Size size) {
    final paintLinea = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    for (int i = 0; i < puntos.length - 1; i++) {
      canvas.drawLine(
        puntos[i],
        puntos[i + 1],
        paintLinea,
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
