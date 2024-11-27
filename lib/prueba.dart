import 'package:http/http.dart' as http;

void main() {
  checkCountriesApi();
}

Future<void> checkCountriesApi() async {
  final url = Uri.parse('https://restcountries.com/v3.1/all');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('API is responding correctly');
      print('Total countries: ${response.body.length}');
    } else {
      print('API error: Status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error connecting to API: $e');
  }
}

/*import 'dart:async';
import 'dart:convert';
import 'dart:html';

void main() {
  checkCountriesApi();
}

Future<void> checkCountriesApi() async {
  final url = 'https://restcountries.com/v3.1/all';
  
  try {
    final request = await HttpRequest.request(url);
    
    if (request.status == 200) {
      final List countries = json.decode(request.responseText!);
      print('API is responding correctly');
      print('Total countries: ${countries.length}');
    } else {
      print('API error: Status code ${request.status}');
    }
  } catch (e) {
    print('Error connecting to API: $e');
  }
}*/