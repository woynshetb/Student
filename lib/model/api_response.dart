import 'dart:convert';

class ApiResponse {
  List get data => body["body"];
  bool get allGood => errors!.isEmpty;
  String get hasException => exception!;
  bool hasError() => errors!.isNotEmpty;
  bool hasMessageError() => messageError!.isNotEmpty;
  bool hasData() => data.isNotEmpty;

  int? code;
  String? message;
  dynamic body;
  List? errors;
  List? messageError;
  String? exception;

  ApiResponse({
    this.code,
    this.message,
    this.body,
    this.errors,
  });

  factory ApiResponse.fromResponse(
    dynamic response,
  ) {
    int code = response.statusCode;
    dynamic body = jsonDecode(response.body);
    List errors = [];
    String message = "";
    List messageError = [];

    switch (code) {
      
      case 200:
        try {
          message = body is Map ? body['message'] : "";
        } catch (error) {
          messageError.add(message);
        
        }

        break;

     

      case 400:
        try {
          message = body is Map ? body['errors'][0]['message'] : "";
          errors.add(message);
        } catch (error) {
          message = body is Map ? body['message'] : "";
          // debugPrint("Message reading error in QR Error ==> $error");
          errors.add(message);
        }
        break;
      case 404:
        try {
          message = body is Map
              ? body['message'] 
              : body['errors'][0]['message'] ??"";
          errors.add(message);
        } catch (error) {
          errors.add(message);
        }

        break;


      default:
        message = body["message"] ??
            "Sorry! Something went wrong, please contact support.";

        break;
    }

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }
}
