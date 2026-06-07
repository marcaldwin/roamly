import 'package:supabase_flutter/supabase_flutter.dart';

class AuthErrorMapper {
  static String map(Object error) {
    if (error is AuthException) {
      final message = error.message.toLowerCase();

      if (message.contains('invalid login credentials')) {
        return 'Incorrect email or password.';
      }

      if (message.contains('user already registered') ||
          message.contains('already registered') ||
          message.contains('already exists')) {
        return 'This email is already used. Try logging in.';
      }

      if (message.contains('password')) {
        return 'Password must be at least 6 characters.';
      }

      if (message.contains('invalid email') || message.contains('email')) {
        return 'Please enter a valid email address.';
      }

      if (message.contains('email not confirmed')) {
        return 'Please confirm your email before logging in.';
      }

      if (message.contains('database error')) {
        return 'Account was created, but profile setup failed. Username may already be taken.';
      }

      return error.message;
    }

    if (error is PostgrestException) {
      final message = error.message.toLowerCase();

      if (message.contains('duplicate') || message.contains('unique')) {
        return 'That value is already taken.';
      }

      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
}
