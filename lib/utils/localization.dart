class S {
  static final Map<String, Map<String, String>> _localized = {
    'en': {
      'app_title': 'Mapjok Unit Converter',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'login_with_google': 'Sign in with Google',
      'choose_language': 'Choose language',
      'bangla': 'বাংলা',
      'english': 'English',
      'value': 'Value',
      'from': 'From',
      'to': 'To',
      'result': 'Result',
      'logout': 'Logout',
      'area': 'Area',
      'length': 'Length',
      'volume': 'Volume',
      'weight': 'Weight',
      'settings': 'Settings',
    },
    'bn': {
      'app_title': 'মাপজোক ইউনিট কনভার্টার',
      'login': 'লগইন',
      'register': 'রেজিস্টার',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'login_with_google': 'গুগল দিয়ে সাইন ইন',
      'choose_language': 'ভাষা নির্বাচন করুন',
      'bangla': 'বাংলা',
      'english': 'ইংরেজি',
      'value': 'মান',
      'from': 'থেকে',
      'to': 'এবং',
      'result': 'ফলাফল',
      'logout': 'লগআউট',
      'area': 'এলাকা',
      'length': 'দৈর্ঘ্য',
      'volume': 'আয়তন',
      'weight': 'ওজন',
      'settings': 'সেটিংস',
    },
  };

  static String t(String key, String code) {
    return _localized[code]?[key] ?? key;
  }
}
