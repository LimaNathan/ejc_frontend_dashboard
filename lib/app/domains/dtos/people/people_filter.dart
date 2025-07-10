class PeopleFilter {
  PeopleFilter({
    this.nome,
    this.aptidoes,
    this.idade,
    this.encontro,
    this.hasTeam,
    this.circulo,
  });

  String? nome;
  List<String>? aptidoes;
  int? idade;
  int? encontro;
  String? circulo;
  bool? hasTeam;
  Map<String, Object> toJson() {
    final year = idade != null ? DateTime.now().year - idade! : null;
    final json = <String, Object>{};

    if (aptidoes != null) json.addAll({'aptidoes': aptidoes!});
    if (year != null) json.addAll({'aniversario': year});
    if (encontro != null) json.addAll({'ejc_fez': '$encontro'});
    if (circulo != null) json.addAll({'circulo': circulo!});

    return json;
  }
}
