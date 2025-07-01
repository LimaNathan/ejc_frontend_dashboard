class AppImages {
  static const String cafezinhoSVG = '../assets/cafezinho.svg';
  static const String comprasSVG = '../assets/compras.svg';
  static const String cozinhaSVG = '../assets/cozinha.svg';
  static const String gaconsSVG = '../assets/gacons.svg';
  static const String liturgiaSVG = '../assets/liturgia.svg';
  static const String logoEjcPNG = '../assets/logo_ejc.png';
  static const String minimercadoSVG = '../assets/minimercado.svg';
  static const String ordemSVG = '../assets/ordem.svg';
  static const String salaSVG = '../assets/sala.svg';
  static const String secretariaSVG = '../assets/secretaria.svg';
  static const String vectorPsapPNG = '../assets/vector_psap.png';
  static const String vigiliaSVG = '../assets/vigilia.svg';

  static String getTeamImage(String? team) => switch (team) {
        'Cafezinho' => cafezinhoSVG,
        'Compras' => comprasSVG,
        'Cozinha'=> cozinhaSVG,
        'Garçons'=> gaconsSVG,
        'Liturgia' => liturgiaSVG,
        'Mini-mercado' => minimercadoSVG,
        'Ordem e limpeza' => ordemSVG,
        'Sala' => salaSVG,
        'Secretaria' => secretariaSVG,
        'Vigilia' => vigiliaSVG,
        _ => salaSVG,
      };
}
