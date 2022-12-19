import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'endpoint.dart';

class Api {
  static const online = Endpoint.BASE_URL;
  //static const MEDIA_SERVICE = Endpoint.MEDIA_SERVICE;

  static Future<Map<String, dynamic>> login(data) async {
    final response =
        await http.post(Uri.parse("$online/login/cek_user_data"), body: data);
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getNopol(data) async {
    final response = await http.get(
      Uri.parse("$online/matel/cari_nopol?nopol=$data"),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> data) async {
    try {
      File file = data['file_ktp'];
      var request = http.MultipartRequest(
          "POST", Uri.parse("$online/login/register_cust"));
      debugPrint('file path: ${file.path}');
      String ext = p.extension(file.path).split(".").last;
      debugPrint('ext: $ext');
      var media = await http.MultipartFile.fromPath(
        "file_ktp",
        file.path,
        filename: "ktp_${data['no_ktp']}.$ext",
        contentType:
            ext == 'jpg' ? MediaType("image", ext) : MediaType("video", ext),
      );
      debugPrint('media path: ${media.filename}');
      request.fields['nama'] = data['nama'];
      request.fields['no_hp'] = data['no_hp'];
      request.fields['no_ktp'] = data['no_ktp'];
      request.files.add(media);
      var response = await request.send();
      var resp = await http.Response.fromStream(response);
      return json.decode(resp.body);
    } on TimeoutException catch (_) {
      return {'error': true, 'message': 'Timeout when uploading media'};
    } on SocketException catch (_) {
      return {
        'error': true,
        'message': 'Connection error when uploading media'
      };
    } on Exception catch (_) {
      return {'error': true, 'message': 'Unknown Error'};
    }
  }

  static Future<Map<String, dynamic>> createTransaction(data) async {
    final response = await http
        .post(Uri.parse("$online/transaction/create_transaction"), body: data);
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getTransactions(data) async {
    final response = await http.get(
        Uri.parse("$online/transaction/get_transaction_list?id_user=$data"));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getSubsData() async {
    final response = await http.get(Uri.parse("$online/transaction/subs_data"));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> changePassword(data) async {
    final response =
        await http.post(Uri.parse("$online/login/change_password"), body: data);

    return json.decode(response.body);
  }
}
