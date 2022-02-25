import 'package:url_launcher/url_launcher.dart';

// class MapUtils {
//   MapUtils._();

//   static Future<void> openMap(double latitude, double longitude) async {
//     String googleMapurl =
//         "http://maps.google.com/maps?z=12&t=m&q=loc:$latitude+-$longitude";
//     // "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

//     if (await canLaunch(googleMapurl)) {
//       await launch(googleMapurl);
//     } else {
//       throw 'Could not open the Map';
//     }
//   }
// }
class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
