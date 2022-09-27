import 'package:jais/mappers/jmapper.dart';
import 'package:jais/models/country.dart';
import 'package:jais/utils/const.dart';

class CountryMapper extends JMapper<Country> {
  static final CountryMapper instance = CountryMapper();
  static Country? selectedCountry;

  CountryMapper() : super(url: getCountriesUrl(), fromJson: Country.fromJson);

  @override
  Future<void> update() async {
    await super.update();
    // Set the selected country to the first one in the list
    selectedCountry = list.first;
  }
}
