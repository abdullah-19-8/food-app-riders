import 'package:url_launcher/url_launcher.dart';

class MapUtils{

  MapUtils._();

  static void lunchMapFromSourceToDestination(sourceLat, sourceLng, destinationLat, destinationLng)async
  {
    String mapOption =
        [
         "saddr=$sourceLat,$sourceLng",
         "daddr=$destinationLat,$destinationLng",
          "dir_action=navigate"
        ].join("&");

    //final mapUrl = "https://www.google.com/maps?$mapOption";

    //if(await canLaunch(mapUrl))
      final Uri googleMapUrl = Uri.parse("https://www.google.com/maps?$mapOption");

    if(!await launchUrl(googleMapUrl)) throw 'Could not launch $googleMapUrl';
  }
}