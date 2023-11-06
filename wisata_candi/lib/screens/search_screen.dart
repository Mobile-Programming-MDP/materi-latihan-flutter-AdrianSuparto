//jalankan flutter clean sebelum di push
//flutter pub get buat gak error

import 'package:flutter/material.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/models/candi.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //TODO: 1. Deklarasikan variabel yang dibutuhkan
  List<Candi> _filterCandis = candiList;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        //TODO  : 2. Buat appbar dengan judul Pencarian Candi
        appBar: AppBar(
          title: const Text('Pencarian Candi'),
        ),
        //TOD0  : 3. Buat body berupa column
        body: Column(
          //TODO : 4. Buat textField pencarian sebagai anak dari Column
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.deepPurple[50],
                ),
                child: const TextField(
                  autofocus: false,
                  //TODO 6 : Implemntasi Fitur Pencarian
                  decoration: InputDecoration(
                    hintText: "Cari Candi ...",
                    prefixIcon: Icon(Icons.search),
                    //TODO 7 : Impementasi pengosongan index
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            //Todo5 : 5. Buat ListView hasil pencarian sebagai anak dari column
            Expanded(
              child: ListView.builder(
                itemCount: _filterCandis.length,
                itemBuilder: (context, index) {
                  final candi = _filterCandis[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 100,
                          height: 100,
                          child: ClipRect(
                            child: Image.asset(
                              candi.imageAsset,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candi.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                candi.location,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
