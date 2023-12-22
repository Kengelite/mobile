import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';

class ApiProvider {
  ApiProvider();

 String endPoint = 'https://anxious-slug-peplum.cyclic.app/';
  // String endPoint = 'http://10.0.2.2:3000';
  Future<http.Response> doLogin(String username, String password) async {
    print("sswqwq");

    var _url = Uri.parse('$endPoint/check_customer');
    //  '$endPoint/check_customer';
    var json = jsonEncode(
        <String, String>{"username": '$username', "password": '$password'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> doRegister(String fname, String lname, String username,
      String password, String tel) async {
    var _url = Uri.parse('$endPoint/usersadd');
    // String _url = '$endPoint/usersadd';
    var json = jsonEncode(<String, String>{
      "fname": '$fname',
      "lname": '$lname',
      "username": '$username',
      "password": '$password',
      "tel": '$tel'
    });
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> editCustomer(
      String fname, String lname, String username, String tel) async {
    // String _url = '$endPoint/editCustomer';
    var _url = Uri.parse('$endPoint/editCustomer');
    var json = jsonEncode(<String, String>{
      "fname": '$fname',
      "lname": '$lname',
      "username": '$username',
      "tel": '$tel'
    });
    return await http.put(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> data_customer(String username) async {
    // String _url = '$endPoint/data_customer';
    var _url = Uri.parse('$endPoint/data_customer');
    var json = jsonEncode({"username": '$username'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> data_boxcar(double longi, lati) async {
    // String _url = '$endPoint/branch_location';
    var _url = Uri.parse('$endPoint/branch_location');
    var json = jsonEncode({"longi": '$longi', "lati": '$lati'});

    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> branch_data_car(String branch_id) async {
    // String _url = '$endPoint/branch_location';
    var _url = Uri.parse('$endPoint/branch_data_car');
    var json = jsonEncode({"branch_id": '$branch_id'});

    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> data_usecar(String username) async {
    // String _url = '$endPoint/data_usecar';
    var _url = Uri.parse('$endPoint/data_usecar');
    var json = jsonEncode({"username": '$username'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> create_qrcode_payment(
      String amount, String username) async {
    // String _url = '$endPoint/data_usecar';
    var _url = Uri.parse('$endPoint/create_qrcode_payment');
    var json = jsonEncode({"amount": '$amount', "username": '$username'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> data_payment(String username) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/data_payment');
    var json = jsonEncode({"username": '$username'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> controller_box(String control) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/controller_box');
    var json = jsonEncode({"control": '$control'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> choise_time_return_data_promotion(
      String id_branch) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/choise_time_return_data_promotion');
    var json = jsonEncode({"id_branch": '$id_branch'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> add_use_washcar(String email) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/add_use_washcar');
    var json = jsonEncode({"email_cus": '$email'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }
}
