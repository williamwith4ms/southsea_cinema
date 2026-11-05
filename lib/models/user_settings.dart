class UserSettings {
  final String address;
  final String email;
  final String patronNumber;
  final bool receiveEmailNews;

  const UserSettings({
    this.address = "",
    this.email = "",
    this.patronNumber = "",
    this.receiveEmailNews = false,
  });
}