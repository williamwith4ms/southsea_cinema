import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

void main() {
  group("User Settings Tests", () {
    test("UserSettings defaults to empty and false values", () {
      final userSettings = const UserSettings();

      expect(userSettings.address, "");
      expect(userSettings.email, "");
      expect(userSettings.patronNumber, "");
      expect(userSettings.receiveEmailNews, false);
    });

    test("UserSettings stores passed values correctly", () {
      final userSettings = const UserSettings(
        address: "123 test street",
        email: "email@example.com",
        patronNumber: "1234",
        receiveEmailNews: true,
      );

      expect(userSettings.address, "123 test street");
      expect(userSettings.email, "email@example.com");
      expect(userSettings.patronNumber, "1234");
      expect(userSettings.receiveEmailNews, true);
    });
  });
}