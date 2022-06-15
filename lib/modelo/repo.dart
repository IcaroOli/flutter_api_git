class Repo {
  String name;
  String htmlUrl; // hmtl_url
  int stargazersCount; //stargazers_count
  String description;

  Repo(
      {required this.name,
      required this.htmlUrl,
      required this.stargazersCount,
      required this.description});

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'] ?? "",
      htmlUrl: json['html_url'] ?? "",
      stargazersCount: json['stargazers_count'] ?? "",
      description: json['description'] ?? "",
    );
  }
}

class All {
  List<Repo> repos;

  All({required this.repos});

  factory All.fromJson(List<dynamic> json) {
    List<Repo> repos = <Repo>[];
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos: repos);
  }
}
