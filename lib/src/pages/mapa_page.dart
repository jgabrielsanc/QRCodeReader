import 'package:flutter/material.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapController = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiamdhYnJpZWxzYW5jIiwiYSI6ImNrMXpiOWQwczB3Y3gzaXRldGs0OGRxeXgifQ.FUKJ4tgy3uBwj1kTV4mW-g',
        'id' : 'mapbox.$tipoMapa'
      }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );
  }

  Widget _floatingActionButton(BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'streets') {
          tipoMapa = 'dark';
        } else if (tipoMapa == 'dark') {
          tipoMapa = 'light';
        } else if (tipoMapa == 'light') {
          tipoMapa = 'outdoors';
        } else if (tipoMapa == 'outdoors') {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }

        setState(() {});
      },

    );
  }
}