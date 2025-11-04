import 'package:flutter/material.dart';

class MyCounterWidget extends StatefulWidget {
  final String title;
  final int initialCount;

  const MyCounterWidget({super.key, required this.title, this.initialCount = 0});

  @override
  State<MyCounterWidget> createState() => _MyCounterWidgetState();
}

class _MyCounterWidgetState extends State<MyCounterWidget> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCount;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp é necessário para alguns widgets como Scaffold
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Você apertou o botão tantas vezes:',
              ),
              Text(
                '$_counter',
                key: const Key('counterText'), // Chave para encontrar o widget no teste
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Incrementar',
          key: const Key('incrementButton'), // Chave para encontrar o widget no teste
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
