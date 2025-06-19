import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_flutter/data/image_path.dart';
import 'package:weather_flutter/services/location_provider.dart';
import 'package:weather_flutter/services/weather_service_provider.dart';
import 'package:weather_flutter/utils/apptext.dart';
import 'package:weather_flutter/utils/custom_divider_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {

    final locationProvider=Provider.of<LocationProvider>(context,listen: false);

    locationProvider.determinePosition().then((_){


      if(locationProvider.currentLocationnName!=null){

        var city=locationProvider.currentLocationnName!.locality;
        if(city!=null){
          Provider.of<WeatherServiceProvider>(context,listen: false).fetchWeatherDataByCity(city);
        }
      }
    });
    // Provider.of<LocationProvider>(context, listen: false).determinePosition();
    //
    // Provider.of<WeatherServiceProvider>(
    //   context,
    //   listen: false,
    // ).fetchWeatherDataByCity("Dubai");
    super.initState();
  }
  TextEditingController _cityController=TextEditingController();
  var city;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
  bool _clicked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherProvider=Provider.of<WeatherServiceProvider>(context);

    // Get the sunrise timestamp from the API response
    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0; // Replace 0 with a default timestamp if needed
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0; // Replace 0 with a default timestamp if needed

// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),

      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),

        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(background[weatherProvider.weather!.weather![0].main??"N/A"]??"assets/img/default.png"),
          ),
        ),
        child: Stack(
          children: [


            Container(
              height: 50,
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  var locationCity;
                  if (locationProvider.currentLocationnName != null) {
                    locationCity =
                        locationProvider.currentLocationnName!.locality;
                  } else {
                    locationCity = "Unknown Location";
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.red),
                            SizedBox(width: 10),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: locationCity.isEmpty
                                      ? "Unknown Location"
                                      : locationCity,
                                  color: Colors.white,
                                  fw: FontWeight.w700,
                                  size: 18,
                                ),


                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),

            Align(
              alignment: Alignment(0, -0.7),
              child: Image.asset(imagePath[weatherProvider.weather?.weather![0].main??"N/A"]??"assets/img/default.png"),
            ),

            Align(
              alignment: Alignment(0, 0),
              child: Container(
                height: 150,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      data: "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)}\u00B0 C" ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.bold,
                      size: 32,
                    ),
                    AppText(
                      data: weatherProvider.weather?.name ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.w600,
                      size: 22,
                    ),
                    AppText(
                      data: weatherProvider.weather?.weather![0].main ?? "N/A",
                      color: Colors.white,
                      fw: FontWeight.w600,
                      size: 20,
                    ),

                    AppText(
                      data: DateFormat("hh:mm a").format(DateTime.now()),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment(0.0, 0.75),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.4),
                ),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/temperature-high.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Max",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0)}\u00B0 C"??"N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Image.asset(
                              'assets/img/temperature-low.png',
                              height: 55,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Temp Min",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0)}\u00B0 C"??"N/A",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomDivider(
                      startIndent: 20,
                      endIndent: 20,
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/img/sun.png', height: 55),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Sunrise",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "${formattedSunrise} AM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Image.asset('assets/img/moon.png', height: 55),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data: "Sunset",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                                AppText(
                                  data: "${formattedSunset} PM",
                                  color: Colors.white,
                                  size: 14,
                                  fw: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                height: 45,

                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: "Search by city",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    
                    IconButton(onPressed: (){
                      print(_cityController.text);
                      weatherProvider.fetchWeatherDataByCity(_cityController.text);

                    }, icon: Icon(Icons.search))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
