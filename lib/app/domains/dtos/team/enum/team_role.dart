enum TeamRole {
  casalCoordenador('Casal coordenador'),
  jovemCoordenador('Jovem coordenador'),
  integrante('Integrante');

  const TeamRole(this.title);

  final String title;
}

extension TeamRoleExtension on TeamRole {
  String get value {
    switch (this) {
      case TeamRole.casalCoordenador:
        return 'casal_coordenador';
      case TeamRole.jovemCoordenador:
        return 'jovem_coordenador';
      case TeamRole.integrante:
        return 'integrante';
    }
  }

  static TeamRole fromString(String role) {
    switch (role) {
      case 'casal_coordenador':
        return TeamRole.casalCoordenador;
      case 'jovem_coordenador':
        return TeamRole.jovemCoordenador;
      case 'integrante':
        return TeamRole.integrante;
      default:
        throw ArgumentError('Invalid TeamRole: $role');
    }
  }
}
