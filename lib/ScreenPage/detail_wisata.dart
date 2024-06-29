import 'package:flutter/material.dart';
import 'package:simulasi_uas/ScreenPage/maps.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/ModelWisata.dart';

class PageDetail extends StatelessWidget {
  final Datum wisata;

  const PageDetail({super.key, required this.wisata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Wisata', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3d5a80),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: wisata.gambar.isNotEmpty
                  ? Image.network(
                'http://192.168.61.154/wisataDB/gambar/${wisata.gambar}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            Text(
              wisata.nama,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3d5a80)),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    wisata.lokasi,
                    style: TextStyle(fontSize: 16, color: Colors.black54,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(color: Colors.grey),

            Row(
              children: [
                Icon(FontAwesomeIcons.infoCircle, color: Color(0xFF3d5a80)),
                SizedBox(width: 10),
                Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              wisata.deskripsi,
              style: TextStyle(fontSize: 13, height: 1.5),
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 12),
            Row(
              children: [
                Icon(FontAwesomeIcons.mapMarkerAlt, color: Color(0xFF3d5a80)),
                SizedBox(width: 10),
                Text(
                  'Koordinat',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Lat: ${wisata.lat}, Lng: ${wisata.lng}',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(FontAwesomeIcons.map, color: Colors.white),
                label: Text('Lihat di Peta', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPage(
                        lat: double.parse(wisata.lat),
                        lng: double.parse(wisata.lng),
                        nama: wisata.nama,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  backgroundColor: Color(0xFF3d5a80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
