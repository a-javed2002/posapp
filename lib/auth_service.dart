import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<Map<String, String>> getCsrfTokenAndCookies() async {
    final response = await http
        .get(Uri.parse('https://alarahi.nanotechnology.com.pk/login'));

    if (response.statusCode == 200) {
      final csrfToken = RegExp(r'XSRF-TOKEN=([^;]+)')
          .firstMatch(response.headers['set-cookie'] ?? '')
          ?.group(1);

      final sessionCookie = RegExp(r'pos_session=([^;]+)')
          .firstMatch(response.headers['set-cookie'] ?? '')
          ?.group(1);
var x = "";
          var document = html.parse(response.body);
      var csrfTokenElement = document.querySelector('input[name="_token"]');
      if (csrfTokenElement != null) {
        x= csrfTokenElement.attributes['value'] ?? '';
      }

      if (csrfToken != null && sessionCookie != null) {
        print(csrfToken);
        print(sessionCookie);
        return {
          'csrfToken': csrfToken,
          'sessionCookie': sessionCookie,
          'csrf': x,
        };
      } else {
        throw Exception('Failed to get CSRF token or session cookie');
      }
    } else {
      throw Exception('Failed to load login page');
    }
  }

  Future<bool> login(String username, String password) async {
    final tokenData = await getCsrfTokenAndCookies();
    final csrfToken = tokenData['csrfToken'];
    final sessionCookie = tokenData['sessionCookie'];
    final csrf = tokenData['csrf'];

        print("csrf is ${csrf}");

    final response = await http.post(
      Uri.parse('https://alarahi.nanotechnology.com.pk/login'),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': csrfToken!,
        'Cookie': 'XSRF-TOKEN=$csrfToken; pos_session=$sessionCookie',
      },
      body: json.encode({
        '_token': csrf,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 302) {
      print("hmmmm: ${response.body}");
      return true;
    } else {
      throw Exception('Failed to login ${response.statusCode}');
    }
  }
}
