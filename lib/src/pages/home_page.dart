import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreader/src/bloc/scan_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/pages/direcciones_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

import 'mapas_page.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTodos,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _bottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],

    );
  }

  Widget _callPage(int paginaActual) {
    
    switch( paginaActual ) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  void _scanQR(BuildContext context) async{
    // https://www.google.com
    // geo:40.714865545932376,-74.00182142695314
    
    String futureString;

    try {
      futureString = await new QRCodeReader().scan();
    } catch(e) {
      futureString = e.toString();
    }

   if (futureString != null) {

    final scan = ScanModel(valor: futureString);
    scansBloc.agregarScan(scan);

    if (Platform.isIOS) {
      Future.delayed(Duration(milliseconds: 750), () {
        utils.abrirScan(context, scan);
      });
    } else {
      utils.abrirScan(context, scan);
    }
   }
  }
}