class ForgetPasswordReq {
  final String email;

  ForgetPasswordReq({required this.email});

  Map<String, dynamic> toMap() {
    return {'email': email};
  }
}

class ForgetPasswordResponse {
  final String msg;

  ForgetPasswordResponse({required this.msg});

  factory ForgetPasswordResponse.fromMap(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      msg: json['msg'],
    );
  }
}
