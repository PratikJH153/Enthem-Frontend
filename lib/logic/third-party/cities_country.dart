import 'package:dio/dio.dart';
import 'package:enthem2/constants/country_api.dart';
import 'package:enthem2/services/debug_console.dart';

class CityCountryAPI {
  final Dio _dio = Dio();
  final String baseUrlCountryState = "https://api.countrystatecity.in/v1";
  final String baseUrlCityAPI = "https://api.api-ninjas.com/v1";
  final headersCountryState = {"X-CSCAPI-KEY": countryCityAPI};
  final headersCity = {"X-Api-Key": cityLocationAPI};

  final String filename = "cities_country.dart";

  Future<List<Map<String, dynamic>>> getCountries() async {
    try {
      final result = await _dio.get("$baseUrlCountryState/countries",
          options: Options(headers: headersCountryState));

      if (result.statusCode == 200) {
        final countries = result.data as List<dynamic>;
        return countries.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      debugError(e.toString(), filename);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCitiesForCountry(
      String countryCode) async {
    try {
      final result = await _dio.get(
          "$baseUrlCountryState/countries/$countryCode/cities",
          options: Options(headers: headersCountryState));

      if (result.statusCode == 200) {
        final cityList = result.data as List<dynamic>;
        return cityList.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      debugError(e.toString(), filename);
      return [];
    }
  }

  Future<dynamic> getLatitudeLongitudeForCity(String city) async {
    try {
      final result = await _dio.get("$baseUrlCityAPI/city?name=$city",
          options: Options(headers: headersCity));

      final cityList = result.data as List<dynamic>;
      return cityList;
    } catch (e) {
      debugError(e.toString(), filename);
    }
  }
}
