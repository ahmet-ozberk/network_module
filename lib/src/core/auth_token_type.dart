enum AuthTokenType {
  bearer('Bearer'),
  basic('Basic'),
  token('Token'),
  apiKey('ApiKey'),
  custom('');

  final String prefix;

  const AuthTokenType(this.prefix);

  String format(String token) {
    if (this == AuthTokenType.custom) {
      return token;
    }
    return '$prefix $token';
  }
}
