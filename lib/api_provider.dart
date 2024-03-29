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

  Future<http.Response> addcomment(String comment) async {
    // String _url = '$endPoint/branch_location';
    var _url = Uri.parse('$endPoint/addcomment');
    var json = jsonEncode({"comment": '$comment'});

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

  Future<http.Response> controller_box(String control, String id_box) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/controller_box');
    var json = jsonEncode({"control": '$control', "id_box": '$id_box'});
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

  Future<http.Response> add_use_washcar(String email, String car_idname,
      int credit_free, int check_send_data) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/add_use_washcar');
    var json = jsonEncode({
      "email_cus": '$email',
      "car_idname": '$car_idname',
      "credit_free": '$credit_free',
      "check_send_data": check_send_data
    });
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> send_use_carwash(String email, String price,
      String promotion, String id_car, String balance, int status_check) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/send_use_carwash');
    var json = jsonEncode({
      "email_cus": '$email',
      "price": '$price',
      "promotion": '$promotion',
      "id_car": '$id_car',
      "balance": '$balance',
      "status_check": '$status_check'
    });
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> end_use_carwash(
      String email, String id_car, int status_check, String promotion) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/end_use_carwash');
    var json = jsonEncode({
      "id_car": '$id_car',
      "promotion": '$promotion',
      "email_cus": '$email',
      "status_check": '$status_check'
    });
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  Future<http.Response> controller_box_error(String id_car) async {
    // String _url = '$endPoint/data_payment';
    var _url = Uri.parse('$endPoint/end_use_carwash');
    var json = jsonEncode({"id_car": '$id_car'});
    return await http.post(_url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  // controller_box_error
}
