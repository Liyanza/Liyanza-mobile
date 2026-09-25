sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException([super.message = 'Email ou mot de passe incorrect.']);
}

class SessionExpiredException extends AppException {
  const SessionExpiredException([super.message = 'Session expirée, veuillez vous reconnecter.']);
}

class TooManyAttemptsException extends AppException {
  const TooManyAttemptsException([super.message = 'Trop de tentatives, réessayez dans une minute.']);
}

class EmailAlreadyUsedException extends AppException {
  const EmailAlreadyUsedException([super.message = 'Cet email est déjà utilisé.']);
}

class ValidationFailedException extends AppException {
  final List<String> details;
  const ValidationFailedException(this.details) : super('Certaines informations sont invalides.');
}

class NoInternetException extends AppException {
  const NoInternetException([super.message = 'Pas de connexion internet.']);
}

class UnknownServerException extends AppException {
  const UnknownServerException([super.message = 'Erreur serveur, réessayez plus tard.']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = "Vous n'avez pas les droits nécessaires pour effectuer cette action.",
  ]);
}

class ResourceNotFoundException extends AppException {
  const ResourceNotFoundException([super.message = 'Ressource introuvable.']);
}

class ConflictException extends AppException {
  const ConflictException([
    super.message = 'Les données ont changé entre-temps, réessayez.',
  ]);
}