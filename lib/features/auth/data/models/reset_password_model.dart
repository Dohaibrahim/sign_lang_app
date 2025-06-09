class ResetPasswordReq {
  final String password, otp, email;

  ResetPasswordReq(
      {required this.password, required this.email, required this.otp});

  Map<String, dynamic> toMap() {
    return {'password': password, 'otp': otp, 'email': email};
  }
}

class ResetPasswordResponse {
  final String message;

  ResetPasswordResponse({required this.message});

  factory ResetPasswordResponse.fromMap(Map<String, dynamic> map) {
    return ResetPasswordResponse(
      message: map['message'] ?? '',
    );
  }
}
