import 'package:consumo_servico_avancado/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagem() async {
    http.Response response = await http.get(Uri.parse(_urlBase + "/posts"));
    var dadosJson = jsonDecode(response.body);
    print("${dadosJson} retorno apí");

    List<Post> postagens = [];
    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(
        post["userId"],
        post["id"],
        post["title"],
        post["body"],
      );
      postagens.add(p);
    }
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagem(),
        initialData: null,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              print("conexão active");
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
                print("lista: Erro ao carregar");
              } else {
                print("lista: Carregou");
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {

                    List<Post>? lista = snapshot.data;
                    Post post = lista![index];


                    return  ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.id.toString()),
                    );
                  },
                );
              }
              break;
          }
          return Container();
        },
      ),
    );
  }
}
