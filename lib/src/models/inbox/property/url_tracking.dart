class UrlTracking {
  final String? url;
  final String? password;
  final DateTime? validity;
  final DateTime? expiredAt;

  UrlTracking({
    this.url,
    this.password,
    this.validity,
    this.expiredAt,
  });

  factory UrlTracking.fromJson(Map<String, dynamic> json) {
    return UrlTracking(
      url: json["URL"],
      password: json["password"],
      validity: json["validity"] == null ? null : DateTime.parse(json["validity"]),
      expiredAt: json["Expired_at"] == null ? null : DateTime.parse(json["Expired_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "URL": url,
      "password": password,
      "validity": validity?.toIso8601String(),
      "Expired_at": expiredAt?.toIso8601String(),
    };
  }
}
