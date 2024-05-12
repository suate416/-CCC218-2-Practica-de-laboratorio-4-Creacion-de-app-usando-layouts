import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const TextStyle tituloFont = TextStyle(
  fontSize: 44,
  fontWeight: FontWeight.bold,
);

class _MyHomePageState extends State<MyHomePage> {
  void _mensaje(String mensaje) {
    final snackbar = SnackBar(
      content: Text(
        mensaje,
        style: TextStyle(fontSize: 20),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  final String apiURL =
      'https://newsapi.org/v2/top-headlines?country=co&apiKey=300e83b8ce1b47689e7d5a4da33f0038';

  List data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body)['articles'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.newspaper,
            size: 50,
          ),
          onPressed: () {
            _mensaje('REDIRIGIENDO A: LO MAS RECIENTE');
          },
        ),
        title: const Column(
          children: [
            Text(
              "Noticias Suate",
              style: tituloFont,
            ),
            Text(
              "COLOMBIA",
              style: tituloFont,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 23, 2, 73),
        foregroundColor: Colors.white,
        elevation: 10,
        centerTitle: true,
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 50,
            ),
            onPressed: () {
              _mensaje('REDIRIGIENDO A: BUSCAR NOTICIA');
            },
          ),
        ],
      ),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        data[index]['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            'Fecha de Publicacion: ${data[index]['publishedAt']}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 20),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.north_east_outlined),
                      onTap: () {
                        _mensaje('REDIRIGIENDO A: ${data[index]['url']}');
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
