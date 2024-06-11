import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetp4_flutter/metier/ConsulterLesMesuresActuelles.dart';
import 'package:projetp4_flutter/pages/avecPanel/panelSector.dart';

class ButtonSector extends StatefulWidget
{
  final ConsulterLesMesuresActuelles consulterLesMesuresActuelles;
  final int sector;
  final VoidCallback onPressed;

  const ButtonSector(
      {
        super.key,
        required this.consulterLesMesuresActuelles,
        required this.sector,
        required this.onPressed,
      }
      );

  @override
  ButtonSectorState createState() => ButtonSectorState();
}

class ButtonSectorState extends State<ButtonSector>
{
  late Timer timer;

  @override
  void initState()
  {
    super.initState();
    widget.consulterLesMesuresActuelles.startTimer(
        const Duration(seconds: 60),
            (List<SectorData> newSectorDataList)
        {
          if (mounted) {
            setState(() {});
          }
        }
    );
  }

  @override
  void dispose()
  {
    widget.consulterLesMesuresActuelles.stopTimer();
    super.dispose();
  }

  Future<void> openPanelSector(BuildContext context, int sector) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PanelSector(
          consulterLesMesuresActuelles: widget.consulterLesMesuresActuelles,
          sector: sector,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: ()
      {
        openPanelSector(context, widget.sector);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        minimumSize: MaterialStateProperty.all<Size>(const Size(250, 350)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Secteur ${widget.sector}', style: TextStyle(color: Colors.grey[300])),

          FutureBuilder(
            future: widget.consulterLesMesuresActuelles.getSectorData(widget.sector),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const CircularProgressIndicator();
              }
              else if (snapshot.hasError)
              {
                return Text('Problème de base de données', style: TextStyle(color: Colors.grey[300]));
              }
              else
              {
                final sectorDataList = snapshot.data!;
                bool state=sectorDataList.sectorState;
                return Text('État : ${state ? 'Allumé' : 'Éteint'}', style: TextStyle(color: Colors.grey[300]));
              }
            },
          ),

          FutureBuilder(
            future: widget.consulterLesMesuresActuelles.getSectorData(widget.sector),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const CircularProgressIndicator();
              }
              else if (snapshot.hasError)
              {
                print('Erreur lors de la récupération de la consommation du secteur ${widget.sector}: ${snapshot.error}');
                return Text('Erreur: ${snapshot.error}', style: TextStyle(color: Colors.grey[300]));
              }
              else
              {
                final sectorDataList = snapshot.data!;
                final conso = sectorDataList.consosSector.first;
                if(conso==-1.0)
                {
                  return const Text('Aucune données');
                }
                else
                {
                  return Text('Consommation : ${conso}W', style: TextStyle(color: Colors.grey[300]));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}