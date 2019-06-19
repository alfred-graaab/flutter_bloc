import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'email': 'Email',
      'forgot_password': 'Forgot Password',
      'forgot_password_desc':
          'Please key in the email registered for JaGaApp to request for password reset.',
      'forgot_password_question': 'Forgot Password?',
      'hello_there': 'Hello There!',
      'loading': 'Loading...',
      'log_in_upper': 'LOG IN',
      'login_with_credential': 'Please login using your\nJaGaApp credentials.',
      'log_in_with_email_upper': 'LOG IN WITH EMAIL',
      'name': 'Name',
      'ok_upper': 'OK',
      'or_upper': 'OR',
      'password': 'Password',
      'phone_number': 'Phone Number',
      'register_upper': 'REGISTER',
      'reset_upper': 'RESET',
      'sign_up_desc': 'Your Community is not on JaGaApp?\nEmail us at',
      'sign_up_upper': 'SIGN UP',
      'welcome_desc': 'Welcome to Your Community JaGaApp',
    },
  };

  String keyString(String key) {
    return _localizedValues[locale.languageCode][key] == null
        ? key
        : _localizedValues[locale.languageCode][key];
  }

  String get email {
    return _localizedValues[locale.languageCode]['email'];
  }

  String get forgotPassword {
    return _localizedValues[locale.languageCode]['forgot_password'];
  }

  String get forgotPasswordDesc {
    return _localizedValues[locale.languageCode]['forgot_password_desc'];
  }

  String get forgotPasswordQuestion {
    return _localizedValues[locale.languageCode]['forgot_password_question'];
  }

  String get helloThere {
    return _localizedValues[locale.languageCode]['hello_there'];
  }

  String get loading {
    return _localizedValues[locale.languageCode]['loading'];
  }

  String get logInUpper {
    return _localizedValues[locale.languageCode]['log_in_upper'];
  }

  String get logInWithCredential {
    return _localizedValues[locale.languageCode]['login_with_credential'];
  }

  String get logInWithEmailUpper {
    return _localizedValues[locale.languageCode]['log_in_with_email_upper'];
  }

  String get name {
    return _localizedValues[locale.languageCode]['name'];
  }

  String get okUpper {
    return _localizedValues[locale.languageCode]['ok_upper'];
  }

  String get orUpper {
    return _localizedValues[locale.languageCode]['or_upper'];
  }

  String get password {
    return _localizedValues[locale.languageCode]['password'];
  }

  String get phoneNumber {
    return _localizedValues[locale.languageCode]['phone_number'];
  }

  String get registerUpper {
    return _localizedValues[locale.languageCode]['register_upper'];
  }

  String get resetUpper {
    return _localizedValues[locale.languageCode]['reset_upper'];
  }

  String get signUpDesc {
    return _localizedValues[locale.languageCode]['sign_up_desc'];
  }

  String get signUpUpper {
    return _localizedValues[locale.languageCode]['sign_up_upper'];
  }

  String get welcomeDesc {
    return _localizedValues[locale.languageCode]['welcome_desc'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
