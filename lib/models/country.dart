// Api: https://restcountries.com/v3.1/all

class Country {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final List<String> languages;
  final String flag;
  final Map<String, String> currencies;
  final List<String> borders;

  Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.languages,
    required this.flag,
    required this.currencies,
    required this.borders,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    // Manejo de capital (puede ser una lista o no existir)
    String capitalCity = '';
    if (json['capital'] != null && json['capital'].isNotEmpty) {
      capitalCity = json['capital'][0];
    }

    // Manejo de languages (puede ser null)
    List<String> languagesList = [];
    if (json['languages'] != null) {
      languagesList = json['languages'].values.cast<String>().toList();
    }

    // Manejo de currencies (puede ser null)
    Map<String, String> currencyMap = {};
    if (json['currencies'] != null) {
      json['currencies'].forEach((key, value) {
        currencyMap[key] = value['name'];
      });
    }

    // Manejo de borders (puede ser null)
    List<String> bordersList = [];
    if (json['borders'] != null) {
      bordersList = List<String>.from(json['borders']);
    }

    return Country(
      name: json['name']['common'],
      officialName: json['name']['official'],
      capital: capitalCity,
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      population: json['population'] ?? 0,
      languages: languagesList,
      flag: json['flags']['png'] ?? '',
      currencies: currencyMap,
      borders: bordersList,
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': name,
        'official': officialName,
      },
      'capital': [capital],
      'region': region,
      'subregion': subregion,
      'population': population,
      'languages': {
        for (var e in languages) languages.indexOf(e).toString(): e
      },
      'flags': {
        'png': flag,
      },
      'currencies': currencies,
      'borders': borders,
    };
  }

  @override
  String toString() {
    return 'Country{name: $name, capital: $capital, region: $region, population: $population}';
  }
}
