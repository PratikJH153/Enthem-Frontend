import 'package:enthem2/logic/third-party/cities_country.dart';
import 'package:flutter/material.dart';

class CountryCityDialog extends StatefulWidget {
  const CountryCityDialog({super.key});

  @override
  _CountryCityDialogState createState() => _CountryCityDialogState();
}

class _CountryCityDialogState extends State<CountryCityDialog> {
  final CityCountryAPI _api = CityCountryAPI();
  List<Map<String, dynamic>> _countries = [];
  List<String> _cities = [];
  String? _selectedCountry;
  String? _selectedCity;

  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _api.getCountries();
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      print('Error loading countries: $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> _loadCities(String countryCode) async {
    try {
      final cities = await _api.getCitiesForCountry(countryCode);
      setState(() {
        _cities = cities.map((city) => city['name'] as String).toList();
        // Clear the city field when new cities are loaded
        _cityController.clear();
        _selectedCity = null;
      });
    } catch (e) {
      print('Error loading cities: $e');
      setState(() {
        _cities = [];
        _cityController.clear();
        _selectedCity = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Country and City'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<Map<String, dynamic>>(
            displayStringForOption: (Map<String, dynamic> option) =>
                option['name'] as String,
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _countries.where((Map<String, dynamic> option) {
                return (option['name'] as String)
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (Map<String, dynamic> selection) {
              setState(() {
                _selectedCountry = selection['name'] as String;
                _countryController.text = selection['name'] as String;
                _loadCities(selection['iso2'] as String);
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              _countryController = controller;
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: InputBorder.none,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (_cities.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _cities.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() {
                _selectedCity = selection;
                _cityController.text = selection;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              _cityController = controller;
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'City',
                  enabled: _cities.isNotEmpty,
                  hintText: _cities.isEmpty
                      ? 'Select a country first'
                      : 'Start typing a city name',
                ),
                onChanged: (value) {
                  // Force rebuild of Autocomplete options
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_selectedCountry != null && _selectedCity != null) {
              Navigator.of(context).pop({
                'country': _selectedCountry,
                'city': _selectedCity,
              });
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
