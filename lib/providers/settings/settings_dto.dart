class SettingsDto {
  final bool digitalOnly;
  final String theme;
  final String currency;
  final String dateFormat;
  final bool rememberMe;

  const SettingsDto({
    this.digitalOnly = true,
    this.theme = 'light',
    this.currency = 'gbp',
    this.dateFormat = 'standard',
    this.rememberMe = true,
  });

  static SettingsDto fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      digitalOnly: json['digitalOnly'],
      theme: json['theme'],
      currency: json['currency'],
      dateFormat: json['dateFormat'],
      rememberMe: json['rememberMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'digitalOnly': digitalOnly,
      'theme': theme,
      'currency': currency,
      'dateFormat': dateFormat,
      'rememberMe': rememberMe,
    };
  }
}
