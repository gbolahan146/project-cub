class CubexSettingsResponse {
  String? appEmail;
  String? appEmailName;
  String? appPhone;
  String? appLogo;
  String? appTitle;
  String? siteDescription;
  String? siteTitle;
  String? welcomeMessage;
  String? termsAndCondition;

  CubexSettingsResponse(
      {this.appEmail,
      this.appEmailName,
      this.appPhone,
      this.appLogo,
      this.appTitle,
      this.siteDescription,
      this.siteTitle,
      this.welcomeMessage,
      this.termsAndCondition});

  CubexSettingsResponse.fromJson(Map<String, dynamic> json) {
    appEmail = json['appEmail'];
    appEmailName = json['appEmailName'];
    appPhone = json['appPhone'];
    appLogo = json['appLogo'];
    appTitle = json['appTitle'];
    siteDescription = json['siteDescription'];
    siteTitle = json['siteTitle'];
    welcomeMessage = json['welcomeMessage'];
    termsAndCondition = json['termsAndCondition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appEmail'] = this.appEmail;
    data['appEmailName'] = this.appEmailName;
    data['appPhone'] = this.appPhone;
    data['appLogo'] = this.appLogo;
    data['appTitle'] = this.appTitle;
    data['siteDescription'] = this.siteDescription;
    data['siteTitle'] = this.siteTitle;
    data['welcomeMessage'] = this.welcomeMessage;
    data['termsAndCondition'] = this.termsAndCondition;
    return data;
  }
}

