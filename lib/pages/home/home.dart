import 'package:flutter/material.dart';
import 'package:projetp4_flutter/pages/home/gestionBoutton.dart';
import 'package:projetp4_flutter/metier/bdd.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';

class HomePage extends StatefulWidget
{
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;

  const HomePage(
      {
        super.key,
        required this.consulterLesMesuresActuelles,
      }
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  List<List<Widget>> pages = [];
  int currentPage = 0;
  List<SectorData> sectorDataList = [];

  @override
  void initState()
  {
    super.initState();
    sectorButtons();
    widget.consulterLesMesuresActuelles.startTimer(const Duration(seconds: 60), (List<SectorData> newSectorDataList)
    {
      setState(()
      {
        sectorDataList = newSectorDataList;
      }
      );
    }
    );
  }

  @override
  void dispose()
  {
    widget.consulterLesMesuresActuelles.stopTimer();
    super.dispose();
  }

  Future<void> sectorButtons() async
  {
    final sectorCount = await DataBase().getSector();
    final pageCount = (sectorCount / 4).ceil();

    for (int i = 0; i < pageCount; i++)
    {
      List<Widget> pageButtons = [];
      for (int j = i * 4; j < (i + 1) * 4 && j < sectorCount; j++)
      {
        final button = ButtonSector(
          consulterLesMesuresActuelles: widget.consulterLesMesuresActuelles,
          onPressed: () {},
          sector: j + 1,
        );

        double x = 120.0, y = 300.0;
        switch (j % 4)
        {
          case 0:
            x = 20.0;
            y = 20.0;
            break;
          case 1:
            x = 370.0;
            y = 70.0;
            break;
          case 2:
            x = 660.0;
            y = 70.0;
            break;
          case 3:
            x = 1010.0;
            y = 70.0;
            break;
        }

        pageButtons.add(
          Positioned(
            top: y,
            left: x,
            child: button,
          ),
        );
      }
      pages.add(pageButtons);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //Corps de page
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            height: 150,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(pages.length, (index)
              {
                return Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: ()
                      {
                        setState(()
                        {
                          currentPage = index;
                        });
                      },
                      child: Text(
                        'Salle ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(
            height: 465,
            width: 1280,
            child: Container(
              color: Colors.grey[300],
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: pages.isNotEmpty ? pages[currentPage] : [],
                  ),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.blueAccent,
            height: 125,
            width: double.infinity,
            child: Center(
              child: Text('Les logs', style: TextStyle(color: Colors.grey[300])),
            ),
          ),
        ],
      ),
    );
  }
}
