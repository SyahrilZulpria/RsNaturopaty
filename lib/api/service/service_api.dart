// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:rsnaturopaty/api/Endpoint.dart';
// import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';

// class ServiceApi {
//   decodeToken() async {
//     print(Endpoint.decodeToken);
//     try {
//       final response = await http.post(
//         Uri.parse(Endpoint.decodeToken),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'X-auth-token': token,
//         },
//       ).timeout(const Duration(seconds: 60));

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseJson =
//             json.decode(response.body.toString());
//         dataLoginToSP(responseJson['content']);
//       }
//     } catch (e) {
//       CustomDialog().warning(context, '', e.toString());
//     }
//   }
// }
