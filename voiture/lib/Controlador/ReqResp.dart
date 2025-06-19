import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;
/// Classe de controle para fazer as requisições;
/// - A função fora da classe serve paraa fazzer requisições não seguras.
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

  Future<http.Response> delete(String endpoint, int id,{Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl/$endpoint/$id');
    final allHeaders = {...defaultHeaders, ...?headers};
    return await httpClient.delete(uri, headers: allHeaders); 
  }

  Future<http.Response> getByName(String endpoint, String id, {Map<String, String>? headers}) async {
    
    return await get('$endpoint$id', headers: headers);
  }
  Future<http.Response> getById(String endpoint, int id, {Map<String, String>? headers}) async {
    
    return await get('$endpoint$id', headers: headers);
  }
  

  Map<String, dynamic>? decodeJwtToken(String token) {
  if (token.isEmpty) {
    return null;
  }

  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null; 
    }

    final payloadBase64 = parts[1];
    final normalizedPayload = base64.normalize(payloadBase64);
    final payloadString = utf8.decode(base64.decode(normalizedPayload));
    final payload = json.decode(payloadString);

    return payload;
  } catch (e) {
    print('Erro ao decodificar o token JWT: $e');
    return null;
  }
}

}

http.Client createIgnoringCertificateClient() {
  final httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return io.IOClient(httpClient);
}