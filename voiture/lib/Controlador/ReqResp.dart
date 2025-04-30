import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;

class ReqResp {
  final String baseUrl;
  final http.Client httpClient; 
  Map<String, String> defaultHeaders = {'Content-Type': 'application/json'};

  ReqResp(this.baseUrl, {http.Client? httpClient})
      : httpClient = httpClient ?? http.Client(); 

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    return await httpClient.get(uri, headers: allHeaders); 
  }

  Future<http.Response> post(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    final jsonBody = jsonEncode(body);
    return await httpClient.post(uri, headers: allHeaders, body: jsonBody); 
  }

  Future<http.Response> patch(String endpoint, dynamic body, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    final jsonBody = jsonEncode(body);
    return await httpClient.patch(uri, headers: allHeaders, body: jsonBody); 
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final allHeaders = {...defaultHeaders, ...?headers};
    return await httpClient.delete(uri, headers: allHeaders); 
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


http.Client createIgnoringCertificateClient() {
  final _httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return io.IOClient(_httpClient);
}