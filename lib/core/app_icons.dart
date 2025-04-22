// File: lib/core/app_icons.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  static const String outline_HomeNavPath =
      'assets/icons/heroicons-outline/home.svg';
  static const String solid_HomeNavPath =
      'assets/icons/heroicons-solid/home.svg';
  static const String outline_ProfileNavPath =
      'assets/icons/heroicons-outline/user.svg';
  static const String solid_ProfileNavPath =
      'assets/icons/heroicons-solid/user.svg';
  static const String outline_TripsNavPath =
      'assets/icons/heroicons-outline/calendar-days.svg';
  static const String solid_TripsNavPath =
      'assets/icons/heroicons-solid/calendar-days.svg';
  static const String outline_StationNavPath =
      'assets/icons/heroicons-outline/map.svg';
  static const String solid_StationNavPath =
      'assets/icons/heroicons-solid/map.svg';
  static const String outline_SearchAppPath =
      'assets/icons/heroicons-outline/magnifying-glass.svg';
  static const String outline_NotificationsAppPath = 'assets/icons/Vector.svg';
  static const String linePath = 'assets/icons/line.svg';
  static const String logoPath = 'assets/icons/png logo.png';
  static const String filterIcon = 'assets/icons/filterIcon.png';
  static const String mapiconpin = 'assets/icons/map-pin.png';
  static const String mapicon = 'assets/icons/map.png';
  static const String bustracking = 'assets/icons/bustracking.png';
  static const String outline_pin  = 'assets/icons/outline_pin.svg';
  static const String filled_pin  = 'assets/icons/filled_pin.svg';
  static const String user  = 'assets/icons/user.svg';
  static const String edit  = 'assets/icons/edit.svg';
  static const String background  = 'assets/images/background.svg';
  static const String transport_logo  = 'assets/images/transport_logo.svg';


  static Widget homeNav({double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_HomeNavPath,
        width: width, height: height, color: color);
  }

  static Widget profileNav({double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_ProfileNavPath,
        width: width, height: height, color: color);
  }

  static Widget tripsNav({double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_TripsNavPath,
        width: width, height: height, color: color);
  }

  static Widget stationNav({double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_StationNavPath,
        width: width, height: height, color: color);
  }

  static Widget searchApp({double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_SearchAppPath,
        width: width, height: height, color: color);
  }

  static Widget notificationsApp(
      {double? width, double? height, Color? color}) {
    return SvgPicture.asset(outline_NotificationsAppPath,
        width: width, height: height, color: color);
  }

  static Widget line({double? width, double? height, Color? color}) {
    return SvgPicture.asset(linePath,
        width: width, height: height, color: color);
  }

  static Widget logo_1({double? width, double? height, Color? color}) {
    return SvgPicture.asset(logoPath,
        width: width, height: height, color: color);
  }
}
