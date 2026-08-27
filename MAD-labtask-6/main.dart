import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _weatherData;
  
  // Replace with your actual API key
  final String apiKey = 'mAYSUkn5ry1jhdoJ';

  Future<void> _fetchWeatherData(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Meteoblue requires latitude/longitude, so we'll use a geocoding service first
      final geocodingUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1');
          
      final geocodingResponse = await http.get(
        geocodingUrl,
        headers: {'User-Agent': 'FlutterWeatherApp/1.0'},
      );

      if (geocodingResponse.statusCode == 200) {
        final List geocodingData = json.decode(geocodingResponse.body);
        
        if (geocodingData.isEmpty) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'City not found. Please try another city.';
          });
          return;
        }
        
        final latitude = geocodingData[0]['lat'];
        final longitude = geocodingData[0]['lon'];
        final locationName = geocodingData[0]['display_name'].toString().split(',')[0];
        
        // Now fetch weather data from Meteoblue using lat/lon
        final weatherUrl = Uri.parse(
          'https://my.meteoblue.com/packages/basic-1h?apikey=$apiKey&lat=$latitude&lon=$longitude&format=json&temperature=C'
        );
        
        final weatherResponse = await http.get(weatherUrl);
        
        setState(() {
          _isLoading = false;
        });
        
        if (weatherResponse.statusCode == 200) {
          final weatherData = json.decode(weatherResponse.body);
          
          // Add the location name to the weather data
          weatherData['locationName'] = locationName;
          
          setState(() {
            _weatherData = weatherData;
          });
        } else {
          setState(() {
            _errorMessage = 'Weather data not available for this location.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not find location. Please try another city.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: ${e.toString()}. Please check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _weatherData != null && _cityController.text.isNotEmpty
                ? () => _fetchWeatherData(_cityController.text)
                : null,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                hintText: 'e.g., London, Tokyo, New York',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      _fetchWeatherData(_cityController.text);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _fetchWeatherData(value);
                }
              },
            ),
            
            const SizedBox(height: 20),
            
            // Loading indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
              
            // Error message
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              
            // Weather information
            if (_weatherData != null && !_isLoading)
              Expanded(
                child: MeteoblueWeatherDisplay(weatherData: _weatherData!),
              ),
          ],
        ),
      ),
    );
  }
}

class MeteoblueWeatherDisplay extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  
  const MeteoblueWeatherDisplay({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract current weather information from the data
    final cityName = weatherData['locationName'] ?? 'Unknown Location';
    
    // Get the current hour's data (first element in each array)
    final data1h = weatherData['data_1h'];
    final currentTemp = data1h['temperature'][0];
    final currentHumidity = data1h['relativehumidity'][0];
    final currentWeatherCode = data1h['pictocode'][0];
    
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location info
              Text(
                cityName,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Weather icon
              _getWeatherIcon(currentWeatherCode),
              
              const SizedBox(height: 10),
              
              // Weather condition
              Text(
                _getWeatherDescription(currentWeatherCode).toUpperCase(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.thermostat, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    '${currentTemp.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 28),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Humidity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Humidity: $currentHumidity%',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Next few hours forecast
              Text(
                'Today\'s Forecast',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              
              // Hourly forecast
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8, // Show next 8 hours
                  itemBuilder: (context, index) {
                    // Skip the current hour, start from next hour
                    final hourIndex = index + 1;
                    
                    if (hourIndex < data1h['temperature'].length) {
                      final hourTemp = data1h['temperature'][hourIndex];
                      final hourCode = data1h['pictocode'][hourIndex];
                      final hourTime = data1h['time'][hourIndex].toString().substring(11, 16);
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(hourTime),
                            const SizedBox(height: 5),
                            _getWeatherIcon(hourCode, size: 30),
                            const SizedBox(height: 5),
                            Text('${hourTemp.toStringAsFixed(1)}°'),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              
              const Spacer(),
              
              // Attribution
              Text(
                'Data provided by Meteoblue',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(int pictocode, {double size = 80}) {
    IconData iconData;
    Color color;
    
    // Map Meteoblue pictocode to appropriate icon
    if (pictocode == 1) {
      iconData = Icons.wb_sunny; // Clear sky
      color = Colors.amber;
    } else if (pictocode >= 2 && pictocode <= 3) {
      iconData = Icons.wb_cloudy; // Partly cloudy
      color = Colors.orange;
    } else if (pictocode >= 4 && pictocode <= 9) {
      iconData = Icons.cloud; // Cloudy
      color = Colors.blueGrey;
    } else if ((pictocode >= 10 && pictocode <= 12) || (pictocode >= 18 && pictocode <= 19)) {
      iconData = Icons.grain; // Rain
      color = Colors.blue;
    } else if (pictocode >= 13 && pictocode <= 17) {
      iconData = Icons.ac_unit; // Snow
      color = Colors.lightBlue;
    } else if (pictocode >= 20 && pictocode <= 26) {
      iconData = Icons.flash_on; // Thunderstorm
      color = Colors.deepPurple;
    } else if (pictocode >= 27 && pictocode <= 29) {
      iconData = Icons.cloud_queue; // Fog/Mist
      color = Colors.grey;
    } else {
      iconData = Icons.help_outline; // Unknown
      color = Colors.grey;
    }
    
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
  
  String _getWeatherDescription(int pictocode) {
    // Map Meteoblue pictocode to weather description
    if (pictocode == 1) {
      return 'Clear Sky';
    } else if (pictocode >= 2 && pictocode <= 3) {
      return 'Partly Cloudy';
    } else if (pictocode >= 4 && pictocode <= 9) {
      return 'Cloudy';
    } else if (pictocode >= 10 && pictocode <= 12) {
      return 'Rain';
    } else if (pictocode >= 13 && pictocode <= 17) {
      return 'Snow';
    } else if (pictocode >= 18 && pictocode <= 19) {
      return 'Showers';
    } else if (pictocode >= 20 && pictocode <= 26) {
      return 'Thunderstorm';
    } else if (pictocode >= 27 && pictocode <= 29) {
      return 'Fog';
    } else {
      return 'Unknown';
    }
  }
}