import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsValidator extends LucidValidator<Credentials> {
  CredentialsValidator() {
    ruleFor((credentials) => credentials.email, key: 'email') //
        .notEmpty()
        .validEmail();
  }
}
