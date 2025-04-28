import 'dart:convert';
import 'package:http/http.dart' as http;

class ReqResp {
  final String baseUrl;
  Map<String, String> defaultHeaders = {'Content-Type': 'application/json'};

  ReqResp(this.baseUrl);

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    return await http.get(uri, headers: allHeaders);
  }

  Future<http.Response> post(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    final jsonBody = jsonEncode(body);
    return await http.post(uri, headers: allHeaders, body: jsonBody);
  }

  Future<http.Response> patch(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    final jsonBody = jsonEncode(body);
    return await http.patch(uri, headers: allHeaders, body: jsonBody);
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    return await http.delete(uri, headers: allHeaders);
  }

  

  Future<http.Response> getByName(String name, {Map<String, String>? headers}) async {
    return await get('users?name=$name', headers: headers);
  }

  Future<http.Response> postByName(String name, dynamic body, {Map<String, String>? headers}) async {
    final requestBody = {...body, 'name': name};
    return await post('users', requestBody, headers: headers);
  }

  Future<http.Response> patchByName(String name, dynamic body, {Map<String, String>? headers}) async {
    return await patch('users/$name', body, headers: headers);
  }

  Future<http.Response> deleteByName(String name, {Map<String, String>? headers}) async {
    return await delete('users/$name', headers: headers);
  }
}