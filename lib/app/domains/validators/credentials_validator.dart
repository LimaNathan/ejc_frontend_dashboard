import 'package:ejc_frontend_dashboard/app/domains/dtos/auth/credentials.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsValidator extends LucidValidator<Credentials> {
  CredentialsValidator() {
    ruleFor((credentials) => credentials.email, key: 'email') //
        .notEmpty(
          message: 'Email não pode ser vazio',
        )
        .validEmail(
          message: 'Email inválido, por favor forneça um email válido',
        );

    ruleFor((credentials) => credentials.password, key: 'password') //
        .notEmpty(
      message: 'Senha não pode ser vazia',
    );
  }
}
