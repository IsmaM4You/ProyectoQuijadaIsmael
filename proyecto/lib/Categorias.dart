import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/models/categoria.dart';
import 'package:proyecto/pages/PreguntasItem.dart';

class CategoriasPage extends StatefulWidget {
  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  late Future<List<Category>> futureCategories;
  List<Category> filteredCategories = [];
  List<Category> allCategories = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    futureCategories.then((categories) {
      setState(() {
        allCategories = categories;
        filteredCategories = categories;
      });
    });
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('https://quijada.terrabyteco.com/api/categories/list'));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => Category.fromJson(item))
            .toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  filteredCategories = value.isEmpty
                      ? allCategories
                      : allCategories.where((category) {
                          return category.type
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar categoría...',
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No se encontraron Recomendaciones.');
              } else {
                return ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreguntasItem(
                              categoriaId: category.id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 2, 166, 255),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              category.type,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}