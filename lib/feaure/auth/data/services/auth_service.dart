import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://hrms.lifeinfotechinstitute.com/api/app";

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    print("REQUEST BODY: $body");

    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      body: body,
    );

    // helpful debug print
    print("POST $baseUrl/$endpoint -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> postWithToken(
      String endpoint, Map<String, dynamic> body) async {
    print("REQUEST BODY: $body");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    print("POST $baseUrl/$endpoint -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    Uri uri = Uri.parse("$baseUrl/$endpoint");
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      uri,
      headers: headers,
    );

    print("GET $uri -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    print("REQUEST BODY: $body");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    print("PUT $baseUrl/$endpoint -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    String? filePath,
    String? fileFieldName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final uri = Uri.parse("$baseUrl/$endpoint");
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (filePath != null && fileFieldName != null) {
      request.files.add(await http.MultipartFile.fromPath(fileFieldName, filePath));
    }

    print("MULTIPART POST $uri -> fields: ${request.fields}");

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("MULTIPART POST $uri -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final response = await http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
    );

    print("DELETE $baseUrl/$endpoint -> status ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorBody['message'] ?? "Network error ${response.statusCode}");
    }
  }
}
