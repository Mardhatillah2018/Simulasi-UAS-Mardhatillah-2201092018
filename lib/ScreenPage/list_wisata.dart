import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/ModelWisata.dart';
import 'page_update.dart';
import 'detail_wisata.dart';
import 'add_wisata.dart';

class PageWisata extends StatefulWidget {
  const PageWisata({super.key});

  @override
  State<PageWisata> createState() => _PageWisataState();
}

class _PageWisataState extends State<PageWisata> {
  bool isLoading = true;
  List<Datum> wisataList = [];
  List<Datum> filteredWisataList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWisata();
    searchController.addListener(() {
      filterWisata();
    });
  }

  Future<void> fetchWisata() async {
    final response = await http.get(Uri.parse('http://192.168.61.154/wisataDB/getWisata.php'));

    if (response.statusCode == 200) {
      final data = modelWisataFromJson(response.body);
      setState(() {
        wisataList = data.data;
        filteredWisataList = wisataList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  void filterWisata() {
    List<Datum> results = [];
    if (searchController.text.isEmpty) {
      results = wisataList;
    } else {
      results = wisataList
          .where((datum) =>
      datum.nama.toLowerCase().contains(searchController.text.toLowerCase()) ||
          datum.lokasi.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredWisataList = results;
    });
  }

  void refreshData() {
    setState(() {
      isLoading = true;
    });
    fetchWisata();
  }

  Future<void> deleteWisata(String id) async {
    final response = await http.post(
      Uri.parse('http://192.168.61.154/wisataDB/deleteWisata.php'),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonData['message'])),
      );
      refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3d5a80),
        title: Text(
          'Daftar Wisata di Sumatera Barat',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari Wisata...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWisataList.length,
              itemBuilder: (context, index) {
                final wisata = filteredWisataList[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: wisata.gambar.isNotEmpty
                        ? Image.network(
                      'http://192.168.61.154/wisataDB/gambar/${wisata.gambar}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported, size: 50),
                    title: Text(
                      wisata.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3d5a80),
                      ),
                    ),
                    subtitle: Text(wisata.lokasi),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageUpdate(
                                  wisata: wisata,
                                  refreshData: refreshData,
                                ),
                              ),
                            ).then((value) => fetchWisata());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteWisata(wisata.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageDetail(wisata: wisata),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageInsert(refreshData: refreshData),
            ),
          );
          refreshData();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF3d5a80),
      ),
    );
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cari Wisata'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Masukkan nama atau lokasi...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
