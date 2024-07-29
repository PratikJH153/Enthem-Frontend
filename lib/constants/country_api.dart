import 'package:flutter_dotenv/flutter_dotenv.dart';

final env = dotenv.env;
final String countryCityAPI = env['COUNTRY_CITY_API']!;
final String cityLocationAPI = env['CITY_LOCATION_API']!;
final String socketPort = env['socketPort']!;
