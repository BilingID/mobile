import 'dart:convert';
import 'package:bilingid/models/konseling_session.dart';
import 'package:bilingid/models/psikotes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.150:8000/api/v1';
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> removeToken() async {
    await storage.delete(key: 'token');
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await setToken(responseData['data']['token']);

      return responseData['data']['token'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile  ${response.statusCode}');
    }
  }

  Future<String> cekToken() async {
    final token = await getToken();
    if (token == null) {
      return "Unauthenticated.";
    }
    final response = await http.get(
      Uri.parse('$baseUrl/users/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return token;
    } else {
      return jsonDecode(response.body)['message'];
    }
  }


  Future<List<Psikotes>> getPsychotests() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/psikotes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'] as List<dynamic>;
      return responseData.map((map) => Psikotes.fromJson(map)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<String> createPsychotest() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/psikotes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['code'];
    } else {
      throw Exception('Failed to create psychotest ${response.statusCode}');
    }
  }

  Future<int> createKonselingSession(
      int psychologistId, String meetDate, String meetTime) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/konseling'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'psychologist_id': psychologistId,
        'meet_date': meetDate,
        'meet_time': meetTime
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['id'];
    } else {
      throw Exception('Failed to create psychotest ${response.statusCode}');
    }
  }

  Future<String> processPaymentKonseling(int id) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/konseling/$id/process'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to process payment with ${response.statusCode}');
    }
  }

  Future<String> processPayment(String code) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/psikotes/$code/process'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to process payment with ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getQuestions(String code) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/psikotes/$code/questions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to get questions ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getPsychologs() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/psychologist'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to get psychologist ${response.statusCode}');
    }
  }

  Future<String> submitAnswers(
      String code, Map<String, dynamic> answers) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/psikotes/$code/answer'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(answers),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to submit answers ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getResults(String code) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/psikotes/$code/result'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load results ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }else {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await removeToken();
      } else {
        throw Exception('Failed to logout');
      }
    }
  }

  Future<String> register(bool agreement, String fullname, String email,
      String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'acceptAggrement': agreement
      }),
    );

    if (response.statusCode == 200) {
      return await login(
        email,
        password,
      );
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Registration error');
    } else if (response.statusCode == 422) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message'] ?? 'Registration error');
    } else {
      throw Exception(
          'Failed to register with status code: ${response.statusCode}');
    }
  }

  Future<String?> updateUser(Map<String, String> updatedFields) async {
    final token = await getToken();
    const String url = '$baseUrl/users';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll(updatedFields);
    var response = await request.send();

    if (response.statusCode == 200) {
      return await getToken();
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> changePassword(
      String password, String passwordConfirmation) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/users/password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.statusCode}');
    }
  }

  Future<List<KonselingSession>> getKonselingSessions() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/konseling'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'] as List<dynamic>;
      return responseData.map((map) => KonselingSession.fromJson(map)).toList();
    } else {
      throw Exception(
          'Failed to load konseling Sessions ${response.statusCode}');
    }
  }

  Future<String> finishKonselingSession(int id) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/konseling/$id/done'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to finish  konseling Session: ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception(
          'Failed to finish  konseling Session ${response.statusCode}');
    }
  }
}
