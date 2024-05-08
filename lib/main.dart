import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secteur App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  List<Sector> _sectors = [
    Sector(name: 'Secteur 1', consumption: '15254', state: 'Marche'),
    Sector(name: 'Secteur 2', consumption: '12345', state: 'Arrêt'),
    Sector(name: 'Secteur 3', consumption: '54321', state: 'Marche'),
    Sector(name: 'Secteur 4', consumption: '67890', state: 'Arrêt'),
  ];
  List<String> _logs = [
    'Log 1',
    'Log 2',
    'Log 3',
    'Log 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secteur App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _sectors.length,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (context, index) {
                return SectorPage(
                  sectors: _sectors,
                  onSectorTap: (sector) {
                    // Ouvrir le panel pour le secteur sélectionné.
                  },
                );
              },
            ),
          ),
          LogsWidget(logs: _logs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _sectors.length; i++)
                Container(
                  width: 20,
                  height: 10,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == i ? Colors.blue : Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class Sector {
  final String name;
  final String consumption;
  final String state;

  Sector({required this.name, required this.consumption, required this.state});
}

class SectorWidget extends StatelessWidget {
  final Sector sector;
  final Function() onTap;

  SectorWidget({required this.sector, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(sector.name),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sector.consumption),
                Text(sector.state),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectorPage extends StatelessWidget {
  final List<Sector> sectors;
  final Function(Sector) onSectorTap;

  SectorPage({required this.sectors, required this.onSectorTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sectors.length,
      itemBuilder: (context, index) {
        final sector = sectors[index];
        return SectorWidget(
          sector: sector,
          onTap: () {
            onSectorTap(sector);
          },
        );
      },
    );
  }
}

class LogsWidget extends StatelessWidget {
  final List<String> logs;

  LogsWidget({required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Text(log);
        },
      ),
    );
  }
}