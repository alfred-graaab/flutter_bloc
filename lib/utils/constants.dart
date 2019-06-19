import 'package:flutter/material.dart';

Map<String, String> timeZone = {
  'Asia/Baghdad': '+0300',
  'Asia/Bahrain': '+0300',
  'Asia/Baku': '+0400',
  'Asia/Brunei': '+0800',
  'Asia/Dhaka': '+0600',
  'Asia/Dili': '+0900',
  'Asia/Famagusta': '+0300',
  'Asia/Hong_Kong': '+0800',
  'Asia/Jakarta': '+0700',
  'Asia/Jayapura': '+0900',
  'Asia/Kabul': '+0430',
  'Asia/Kolkata': '+0530',
  'Asia/Kuala_Lumpur': '+0800',
  'Asia/Makassar': '+0800',
  'Asia/Nicosia': '+0300',
  'Asia/Phnom_Penh': '+07000',
  'Asia/Pontianak': '+0700',
  'Asia/Shanghai': '+0800',
  'Asia/Tehran': '+0430',
  'Asia/Tbilisi': '+0400',
  'Asia/Thimphu': '+0600',
  'Asia/Urumqi': '+0600',
  'Asia/Yerevan': '+0400'
};

const bool isProduction = false;

class NaviConstant {
  static const String splashScreen = '/';
  static const String dashBoard = "/dashBoard";
  static const String noProperty = '/noProperty';
  static const String preLogin = "/preLogin";
  static const String login = '/login';
  static const String forgotPass = '/forgotPass';
  static const String signUp = '/signUp';
  static const String setup = '/setup';
  static const String setupMyFamily = '/setupMyFamily';
  static const String contacts = '/contacts';
  static const String editIntercom = '/editIntercom';
  static const String editUser = '/editUser';
  static const String newFamilyMember = '/newFamilyMember';
  static const String familyDetail = '/tenantDetail';
  static const String myTenants = '/myTenants';
  static const String setupTenants = 'setupTenants';
  static const String newTenant = 'newTenant';
  static const String tenantUserDetails = 'tenantUserDetails';
  static const String setupHouseRules = '/setupHouseRules';
  static const String setupOtherContacts = '/setupOtherContacts';
  static const String otherContact = '/otherContact';
  static const String otherContactDetails = '/otherContactDetails';
  static const String visitor = '/visitor';
  static const String purposeOfVisit = '/purposeOfVisit';
  static const String newVisitor = '/newVisitor';
  static const String contractor = '/contractor';
  static const String fillInContractor = '/fillInContractor';
  static const String visitorQRCode = '/visitorQRCode';
  static const String unitAlertCountDown = '/unitAlertCountDown';
  static const String locationAlertCountDown = '/locationAlertCountDown';
  static const String unitAlert = '/unitAlert';
  static const String locationAlert = '/locationAlert';
  static const String inbox = '/inbox';
  static const String jagaHome = '/jagaHome';
  static const String jagaLocation = '/jagaLocation';
  static const String userInformation = '/userInformation';
  static const String userProfile = '/userProfile';
  static const String userQrCode = '/userQrCode';
}

class FirebaseConstant {
  static const String storageUrl = isProduction
      ? 'gs://redideas-79527.appspot.com/'
      : 'gs://graaab-app-staging.appspot.com/';
}

class FeatureConstant {
  static const int setup = 1;
  static const int visitor = 2;
  static const int inbox = 4;
  static const int contact = 8;
  static const int notice = 16;
  static const int feedback = 32;
  static const int facility = 64;
  static const int form = 128;
  static const int rule = 256;
  static const int tutorial = 512;
  static const int referral = 1024;
  static const int billing = 2048;
}

class DayConstant {
  static const int mon = 1;
  static const int tue = 2;
  static const int wed = 4;
  static const int thu = 8;
  static const int fri = 16;
  static const int sat = 32;
  static const int sun = 64;
}

class ColorConstant {
  static const primaryColor = 0xFFED3232;
  static const primaryColorDark = 0xFFAD2424; 

  static const MaterialColor grey = MaterialColor(0xFF333333, <int, Color>{
    50: Color(0xFFE8E8E8), //background
    100: Color(0xFFC8C8C8), //button disable
    150: Color(0xFFD0D0D0), //icon grey
    200: Color(0xFFB5B5B5), //light grey
    250: Color(0xFF999999),
    300: Color(0xFF6E6E6E), //dark grey
    400: Color(0xFF3C3C3C), //button drak grey
  });
}

class StyleConstant {
  static const double defaultMargin = 16.0;
  static const double defaultPadding = 16.0;
  static const double spaceBetweenTitleSubtitle = 8.0;
  static const double headerFontSize = 16.0;
  static const double titleFontSize = 14.0;
  static const double subtitleFontSize = 12.0;
  static const double cellHeight = 50.0;
}

class SignInMethodConstant {
  static const String facebook = 'facebook.com';
  static const String google = 'google.com';
  static const String email = 'Firebase';
}