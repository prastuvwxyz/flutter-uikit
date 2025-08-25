import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

/// Example of a searchable select dropdown
class SearchableSelectExample extends StatefulWidget {
  /// Creates a searchable select example
  const SearchableSelectExample({super.key});

  @override
  State<SearchableSelectExample> createState() =>
      _SearchableSelectExampleState();
}

class _SearchableSelectExampleState extends State<SearchableSelectExample> {
  String? _selectedValue;
  bool _isLoading = false;
  List<SelectOption<String>> _filteredOptions = [];

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
    // Add more countries as needed
  ];

  @override
  void initState() {
    super.initState();
    _filteredOptions = _allCountries;
  }

  void _handleSearch(String searchTerm) {
    // Simulate async search
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isLoading = false;
        _filteredOptions = _allCountries
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MinimalSelect<String>(
            label: 'Country',
            placeholder: 'Select a country',
            options: _filteredOptions,
            value: _selectedValue,
            searchable: true,
            loading: _isLoading,
            onSearch: _handleSearch,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text('Selected country: ${_selectedValue ?? 'none'}'),
        ],
      ),
    );
  }
}
