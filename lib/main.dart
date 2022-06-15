import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_api_git/modelo/repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

Future<All> fetchRepos() async {
  final response =
      await http.get(Uri.parse('https://api.github.com/users/IcaroOli/repos'));

  if (response.statusCode == 200) {
    print(response.body);
    return All.fromJson(json.decode(response.body));
  } else {
    throw Exception('Repositorio não encontrado!');
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<All> futureRepo;
  @override
  void initState() {
    super.initState();
    futureRepo = fetchRepos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub API!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<All>(
          future: futureRepo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Repo> repos = <Repo>[];
              for (int i = 0; i < snapshot.data!.repos.length; i++) {
                repos.add(
                  Repo(
                    name: snapshot.data!.repos[i].name,
                    description: snapshot.data!.repos[i].description,
                    htmlUrl: snapshot.data!.repos[i].htmlUrl,
                    stargazersCount: snapshot.data!.repos[i].stargazersCount,
                  ),
                );
              }
              return ListView(
                children: repos
                    .map(
                      (r) => Card(
                        color: Color.fromARGB(255, 38, 55, 69),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    r.name,
                                    style: const TextStyle(
                                        fontSize: 30.0, color: Colors.white),
                                  ),
                                  Text(
                                    r.stargazersCount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Text(
                                r.description,
                                style: const TextStyle(
                                    fontSize: 23.0, color: Colors.white),
                              ),
                              Text(
                                r.htmlUrl,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro!'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
