//import 'package:flutter/services.dart' show rootBundle;
import 'package:api_flutter/models/country.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'carousel_screen.dart';
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Country>>? _listCountries;
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<Country>> _getCountries() async {
    final response = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/region/europe')); //https://restcountries.com/v3.1/region/europe
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((country) => Country.fromJson(country)).toList();
    } else {
      throw Exception('Error al cargar países');
    }
  }

/*  Future<List<Country>> _getCountries() async {
    try {
      // Lee el archivo JSON desde assets
      final String jsonString =
          await rootBundle.loadString('assets/rest_countries.json');
      // Decodifica el JSON
      final List<dynamic> data = jsonDecode(jsonString);
      // Convierte los datos en una lista de objetos Country
      return data.map((country) => Country.fromJson(country)).toList();
    } catch (e) {
      throw Exception('Error al cargar países desde archivo local: $e');
    }
  }*/

  void _filterCountries(String query, List<Country> countries) {
    setState(() {
      _filteredCountries = countries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.capital.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showCountryDetails(Country country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (country.flag.isNotEmpty)
                  Center(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(country.flag),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                DetailRow(
                  icon: Icons.location_city,
                  label: 'Capital',
                  value: country.capital.isEmpty ? 'N/A' : country.capital,
                ),
                DetailRow(
                  icon: Icons.public,
                  label: 'Región',
                  value: '${country.region} - ${country.subregion}',
                ),
                DetailRow(
                  icon: Icons.people,
                  label: 'Población',
                  value: NumberFormat.compact().format(country.population),
                ),
                DetailRow(
                  icon: Icons.language,
                  label: 'Idiomas',
                  value: country.languages.join(', '),
                ),
                DetailRow(
                  icon: Icons.attach_money,
                  label: 'Monedas',
                  value: country.currencies.values.join(', '),
                ),
                if (country.borders.isNotEmpty)
                  DetailRow(
                    icon: Icons.border_all,
                    label: 'Fronteras',
                    value: country.borders.join(', '),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _listCountries = _getCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CarouselScreen()),
            );
          },
        ),
        title: const Text(
          'Países del Mundo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar países...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                if (_listCountries != null) {
                  _listCountries!.then((countries) {
                    _filterCountries(value, countries);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: _listCountries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      /*children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],*/
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error al cargar países',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Error: ${snapshot.error}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _listCountries = _getCountries();
                            });
                          },
                          child: const Text('Reintentar'),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final countries = _searchController.text.isEmpty
                      ? snapshot.data!
                      : _filteredCountries;

                  return countries.isEmpty
                      ? const Center(
                          child: Text('Ningún país encontrado'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            final country = countries[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: InkWell(
                                onTap: () => _showCountryDetails(country),
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      if (country.flag.isNotEmpty)
                                        Container(
                                          width: 80,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(country.flag),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              country.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Capital: ${country.capital}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Región: ${country.region}',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Población: ${NumberFormat.compact().format(country.population)} personas',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                } else {
                  return const Center(child: Text('Ningún país encontrado'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
