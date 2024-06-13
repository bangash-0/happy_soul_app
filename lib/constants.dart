import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(220, 4, 204, 132);
const kSecondaryColor = Color(0xFF0596FF);
const kFontColor = Color(0xFF0DAEB8);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageTextFieldStyle = TextStyle(
  color: Colors.black,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);


const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your Value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// set your your open ai token from here
const OPENAI_API_KEY = "";

const List<Map<String, String>> soundElements = [
  {
    'id': '101',
    "title": "Airplane",
    "icon": "ic_airplane_normal.png",
    "audio": "city_airplane.mp3"
  },
  {
    "id": "102",
    "title": "Car",
    "icon": "ic_car_normal.png",
    "audio": "city_car.mp3"
  },
  {
    "id": "103",
    "title": "Fan",
    "icon": "ic_fan_normal.png",
    "audio": "city_fan.mp3"
  },
  {
    "id": "104",
    "title": "Key board",
    "icon": "ic_keyboard_normal.png",
    "audio": "city_keyboard.mp3"
  },
  {
    "id": "105",
    "title": "Rails",
    "icon": "ic_rails_normal.png",
    "audio": "city_rails.mp3"
  },
  {
    "id": "106",
    "title": "Rest aurant",
    "icon": "ic_restaurant_normal.png",
    "audio": "city_restaurant.mp3"
  },
  {
    "id": "107",
    "title": "Subway",
    "icon": "ic_subway_normal.png",
    "audio": "city_subway.mp3"
  },
  {
    "id": "108",
    "title": "Traffic",
    "icon": "ic_traffic_normal.png",
    "audio": "city_traffic.mp3"
  },
  {
    "id": "109",
    "title": "Mach ine",
    "icon": "ic_washing_machine_normal.png",
    "audio": "city_washing_machine.mp3"
  },
  {
    "id": "201",
    "title": "Bells",
    "icon": "ic_bells_normal.png",
    "audio": "meditation_bells.mp3"
  },
  {
    "id": "202",
    "title": "Bowl",
    "icon": "ic_bowl_normal.png",
    "audio": "meditation_bowl.mp3"
  },
  {
    "id": "203",
    "title": "Brown Noise",
    "icon": "ic_brown_noise_normal.png",
    "audio": "meditation_brown_noise.mp3"
  },
  {
    "id": "204",
    "title": "Flute",
    "icon": "ic_flute_normal.png",
    "audio": "meditation_flute.mp3"
  },
  {
    "id": "205",
    "title": "Piano",
    "icon": "ic_piano_normal.png",
    "audio": "meditation_piano.mp3"
  },
  {
    "id": "206",
    "title": "Pink Noise",
    "icon": "ic_pink_noise_normal.png",
    "audio": "meditation_pink_noise.mp3"
  },
  {
    "id": "207",
    "title": "Stones",
    "icon": "ic_stones_normal.png",
    "audio": "meditation_stones.mp3"
  },
  {
    "id": "208",
    "title": "White Noise",
    "icon": "ic_white_noise_normal.png",
    "audio": "meditation_white_noise.mp3"
  },
  {
    "id": "209",
    "title": "Wind Chimes",
    "icon": "ic_wind_chimes_normal.png",
    "audio": "meditation_wind_chimes.mp3"
  },
  {
    "id": "301",
    "title": "Birds",
    "icon": "ic_birds_normal.png",
    "audio": "forest_birds.mp3"
  },
  {
    "id": "302",
    "title": "Creek",
    "icon": "ic_creek_normal.png",
    "audio": "forest_creek.mp3"
  },
  {
    "id": "303",
    "title": "Fire",
    "icon": "ic_fire_normal.png",
    "audio": "forest_fire.mp3"
  },
  {
    "id": "304",
    "title": "Forest",
    "icon": "ic_forest_normal.png",
    "audio": "forest_forest.mp3"
  },
  {
    "id": "305",
    "title": "Frogs",
    "icon": "ic_frogs_normal.png",
    "audio": "forest_frogs.mp3"
  },
  {
    "id": "306",
    "title": "Grasshoppers",
    "icon": "ic_grasshoppers_normal.png",
    "audio": "forest_grasshoppers.mp3"
  },
  {
    "id": "307",
    "title": "Leaves",
    "icon": "ic_leaves_normal.png",
    "audio": "forest_leaves.mp3"
  },
  {
    "id": "308",
    "title": "Water fall",
    "icon": "ic_waterfall_normal.png",
    "audio": "forest_waterfall.mp3"
  },
  {
    "id": "309",
    "title": "Wind",
    "icon": "ic_wind_normal.png",
    "audio": "forest_wind.mp3"
  },
  {
    "id": "401",
    "title": "Light Rain",
    "icon": "ic_light_normal.png",
    "audio": "rain_light.mp3"
  },
  {
    "id": "402",
    "title": "Ocean",
    "icon": "ic_ocean_normal.png",
    "audio": "rain_ocean.mp3"
  },
  {
    "id": "403",
    "title": "On Leaves",
    "icon": "ic_on_leaves_normal.png",
    "audio": "rain_on_leaves.mp3"
  },
  {
    "id": "404",
    "title": "On Roof",
    "icon": "ic_on_roof_normal.png",
    "audio": "rain_on_roof.mp3"
  },
  {
    "id": "405",
    "title": "On Window",
    "icon": "ic_on_window_normal.png",
    "audio": "rain_on_window.mp3"
  },
  {
    "id": "406",
    "title": "Rain",
    "icon": "ic_rain_normal.png",
    "audio": "rain_normal.mp3"
  },
  {
    "id": "407",
    "title": "Thunder",
    "icon": "ic_thunders_normal.png",
    "audio": "rain_thunders.mp3"
  },
  {
    "id": "408",
    "title": "Um brella",
    "icon": "ic_under_umbrella_normal.png",
    "audio": "rain_under_umbrella.mp3"
  },
  {
    "id": "409",
    "title": "Water Drops",
    "icon": "ic_water_normal.png",
    "audio": "rain_water.mp3"
  }
];
