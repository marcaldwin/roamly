class AuthValidator {
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  static String? validateUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Username is required.';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    if (username.contains(' ')) {
      return 'Username cannot contain spaces.';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!usernameRegex.hasMatch(username)) {
      return 'Username can only use letters, numbers, and underscore.';
    }

    return null;
  }

  static String? validateDisplayName(String? value) {
    final displayName = value?.trim() ?? '';

    if (displayName.isEmpty) {
      return 'Display name is required.';
    }

    if (displayName.length < 2) {
      return 'Display name is too short.';
    }

    return null;
  }
}
