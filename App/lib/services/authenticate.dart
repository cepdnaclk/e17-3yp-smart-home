// import 'package:dio/dio.dart';
//
// class AuthService {
//
//   String name;
//   String password;
//
//   AuthService()
//
//
//   Dio dio = new Dio();
//
//
//
//   login(name, password) async{
//     try{
//       return await dio.post('http://localhost:5005/api/user/signup',
//       data: {
//         "name" : name,
//         "password" : password
//       }, options: Options(contentType: Headers.formUrlEncodedContentType)
//       ) on DioError catch(e){
//         Fluttertoast.showToast(
//
//         )
//       }
//     }
//   }
//
//
// }
