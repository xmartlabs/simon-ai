import 'package:simon_ai/core/model/user.dart';

extension UserExtensions on User {
  String getEmailUsername() {
    final atIndex = email.indexOf('@');
    return (atIndex != -1) ? email.substring(0, atIndex) : email;
  }
}
