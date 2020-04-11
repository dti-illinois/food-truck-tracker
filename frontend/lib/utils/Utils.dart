/* Title: Illinois Rokwire Source Code 
 * Author: Illinois Rokwire
 * Date: 2019
 * Availability: https://github.com/rokwire/illinois-client/blob/develop/lib/utils/Utils.dart
 */
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UiColors {
  static const Color illinoisBlue = Color(0xff002855);

  static const Color darkBlueGrey = Color(0xff0f2040);
  static const Color darkSlateBlue = Color(0xff244372);
  static const Color darkSlateBlueTwo = Color(0xff002855);
  static const Color darkSlateBlueTwoTransparent015 = Color(0x26002855);
  static const Color darkSlateBlueTwoTransparent03 = Color(0x4d002855);
  static const Color darkSlateBlueTwoTransparent05 = Color(0x80002855);
  static const Color illinoisOrange = Color(0xffe84a27);
  static const Color illinoisTransparentOrange05 = Color(0x80e84a27);
  static const Color illinoisWhiteBackground = Color(0xfff5f5f5);
  static const Color bodyText = Color(0xff5c5c5c);
  static const Color darkOrange = Color(0xffcc3e1e);
  static const Color disabledButton = Color(0xffdadde1);
  static const Color mango = Color(0xfff29835);
  static const Color mangoTransparent05 = Color(0x80f29835);
  static const Color greyishBrown = Color(0xff404040);
  static const Color teal = Color(0xff5fa7a3);
  static const Color cornflowerBlue = Color(0xff5182cf);
  static const Color illinoisSportsBackgroundColor = Color(0xffe8e9ea);
  static const Color lightPeriWinkle = Color(0xffdadde1);
  static const Color whiteTransparent06 = Color(0x99ffffff);
  static const Color blackTransparent06 = Color(0x99000000);
  static const Color white = Color(0Xffffffff);
  static const Color almostWhite = Color(0xffe8e8e8);
  static const Color lightGray = Color(0xffededed);
  static const Color lighterGray = Color(0xffe5e5ea);
  static const Color wellnessSocialMediaTextColor = Color(0xff737373);

  static const Color mediumGray = Color(0xff717372);
  static const Color disabledTextColor = Color(0xffbdbdbd);
  static const Color disabledTextColorTwo = Color(0xff868F9D);
  static const Color transparentShadowColor = Color(0x55132949);
  static const Color grayText1 = Color(0xff5d5d5d);
  static const Color grayText2 = Color(0xff5d5e5d);
  static const Color blueText = Color(0xff112f56);

  static const Color illinoisEventColor = Color(0xffe54b30);
  static const Color illinoisDiningColor = Color(0xfff09842);
  static const Color illinoisPlaceColor = Color(0xff62a7a3);

  static Color fromHex(String value) {
    if (value != null) {
      final buffer = StringBuffer();
      if (value.length == 6 || value.length == 7) {
        buffer.write('ff');
      }
      buffer.write(value.replaceFirst('#', ''));

      try { return Color(int.parse(buffer.toString(), radix: 16)); }
      on Exception catch (e) { print(e.toString()); }
    }
    return null;
  }

  static String toHex(Color value, {bool leadingHashSign = true}) {
    if (value != null) {
      return "${leadingHashSign ? '#' : ''}" +
        "${value.alpha.toRadixString(16)}" +
        "${value.red.toRadixString(16)}" +
        "${value.green.toRadixString(16)}" +
        "${value.blue.toRadixString(16)}";
    }
    return null;
  }
}

class LocationUtils {
  static final double defaultLocationLat = 40.096230;
  static final double defaultLocationLng = -88.235899;
  static final int defaultLocationRadiusInMeters = 1000;

  static double distance(double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) 
                    * sin(deg2rad(lat2))
                    + cos(deg2rad(lat1))
                    * cos(deg2rad(lat2))
                    * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    return (dist);
  }
  static double deg2rad(double deg) {
      return (deg * pi / 180.0);
  }

  static double rad2deg(double rad) {
      return (rad * 180.0 / pi);
  }  
}

class AssetUtils {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
}

class TimeUtils{
  static String formatTimestamp(String timestamp) {
    return DateFormat("hh:mm a").format(DateTime.parse(timestamp));
  }
  static String formatTimeOfDay(TimeOfDay tod){
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }
}