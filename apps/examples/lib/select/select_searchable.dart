import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Searchable select dropdown example screen
class SelectSearchable extends StatefulWidget {
  /// Creates a searchable select example screen
  const SelectSearchable({super.key});

  @override
  State<SelectSearchable> createState() => _SelectSearchableState();
}

class _SelectSearchableState extends State<SelectSearchable> {
  String? _selectedCountry;
  List<String> _selectedLanguages = [];
  bool _isLoading = false;
  List<SelectOption<String>> _filteredCountries = [];

  // Initial list of countries
  final List<SelectOption<String>> _allCountries = [
    const SelectOption(label: 'Afghanistan', value: 'AF'),
    const SelectOption(label: 'Albania', value: 'AL'),
    const SelectOption(label: 'Algeria', value: 'DZ'),
    const SelectOption(label: 'Andorra', value: 'AD'),
    const SelectOption(label: 'Angola', value: 'AO'),
    const SelectOption(label: 'Argentina', value: 'AR'),
    const SelectOption(label: 'Armenia', value: 'AM'),
    const SelectOption(label: 'Australia', value: 'AU'),
    const SelectOption(label: 'Austria', value: 'AT'),
    const SelectOption(label: 'Azerbaijan', value: 'AZ'),
    const SelectOption(label: 'Bahamas', value: 'BS'),
    const SelectOption(label: 'Bahrain', value: 'BH'),
    const SelectOption(label: 'Bangladesh', value: 'BD'),
    const SelectOption(label: 'Barbados', value: 'BB'),
    const SelectOption(label: 'Belarus', value: 'BY'),
    const SelectOption(label: 'Belgium', value: 'BE'),
    const SelectOption(label: 'Belize', value: 'BZ'),
    const SelectOption(label: 'Brazil', value: 'BR'),
    const SelectOption(label: 'Canada', value: 'CA'),
    const SelectOption(label: 'China', value: 'CN'),
    const SelectOption(label: 'France', value: 'FR'),
    const SelectOption(label: 'Germany', value: 'DE'),
    const SelectOption(label: 'India', value: 'IN'),
    const SelectOption(label: 'Japan', value: 'JP'),
    const SelectOption(label: 'Mexico', value: 'MX'),
    const SelectOption(label: 'United Kingdom', value: 'UK'),
    const SelectOption(label: 'United States', value: 'US'),
    // Add more countries as needed
  ];

  // List of languages
  final List<SelectOption<String>> _languages = [
    const SelectOption(label: 'English', value: 'en'),
    const SelectOption(label: 'Spanish', value: 'es'),
    const SelectOption(label: 'French', value: 'fr'),
    const SelectOption(label: 'German', value: 'de'),
    const SelectOption(label: 'Italian', value: 'it'),
    const SelectOption(label: 'Portuguese', value: 'pt'),
    const SelectOption(label: 'Russian', value: 'ru'),
    const SelectOption(label: 'Japanese', value: 'ja'),
    const SelectOption(label: 'Chinese', value: 'zh'),
    const SelectOption(label: 'Arabic', value: 'ar'),
    const SelectOption(label: 'Hindi', value: 'hi'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries;
  }

  void _handleCountrySearch(String searchTerm) {
    // Simulate async search
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
        _filteredCountries = _allCountries
            .where(
              (option) =>
                  option.label.toLowerCase().contains(searchTerm.toLowerCase()),
            )
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Searchable Select')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MinimalSelect<String>(
              label: 'Country',
              placeholder: 'Search for a country',
              options: _filteredCountries,
              value: _selectedCountry,
              searchable: true,
              loading: _isLoading,
              onSearch: _handleCountrySearch,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
              onOpen: () {
                print('Dropdown opened');
              },
              onClose: () {
                print('Dropdown closed');
              },
            ),
            const SizedBox(height: 32),

            MinimalSelect<String>(
              label: 'Languages',
              placeholder: 'Search for languages',
              options: _languages,
              value: _selectedLanguages,
              searchable: true,
              multiple: true,
              onChanged: (value) {
                setState(() {
                  _selectedLanguages = List<String>.from(value);
                });
              },
            ),
            const SizedBox(height: 32),

            Text(
              'Selected country: ${_selectedCountry ?? 'none'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Selected languages: ${_selectedLanguages.isEmpty ? 'none' : _selectedLanguages.join(', ')}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
