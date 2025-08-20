// lib/Model/user_model.dart
class UserAddress {
  final String? address;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;

  UserAddress({
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  String get fullAddress {
    List<String> parts = [];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }
}

class UserModel {
  final int id;
  final String email;
  final String username;
  final String? firstname;
  final String? lastname;
  final String? mobile;
  final UserAddress? address;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.firstname,
    this.lastname,
    this.mobile,
    this.address,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstname: json['firstname'],
      lastname: json['lastname'],
      mobile: json['mobile'],
      address: json['address'] != null 
          ? UserAddress.fromJson(json['address'])
          : null,
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'address': address?.toJson(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullName {
    if (firstname != null && lastname != null) {
      return '$firstname $lastname';
    }
    return username;
  }

  String get displayName {
    return fullName.isNotEmpty ? fullName : email;
  }
}

class AuthResponse {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;
  final Map<String, dynamic>? errors;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.token,
    this.errors,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['status'] == 'success',
      message: json['message'],
      user: json['data']?['user'] != null 
          ? UserModel.fromJson(json['data']['user'])
          : null,
      token: json['data']?['token'],
      errors: json['errors'],
    );
  }
}

class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String passwordConfirmation;
  final bool agree;
  final String? firstname;
  final String? lastname;
  final String? mobile;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    required this.passwordConfirmation,
    required this.agree,
    this.firstname,
    this.lastname,
    this.mobile,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'email': email,
      'username': username,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'agree': agree ? 1 : 0,
    };

    if (firstname != null) data['firstname'] = firstname!;
    if (lastname != null) data['lastname'] = lastname!;
    if (mobile != null) data['mobile'] = mobile!;

    return data;
  }
}

class LoginRequest {
  final String login; // pode ser username ou email
  final String password;

  LoginRequest({
    required this.login,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}

class UpdateProfileRequest {
  final String? firstname;
  final String? lastname;
  final String? mobile;
  final UserAddress? address;

  UpdateProfileRequest({
    this.firstname,
    this.lastname,
    this.mobile,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (firstname != null) data['firstname'] = firstname;
    if (lastname != null) data['lastname'] = lastname;
    if (mobile != null) data['mobile'] = mobile;
    if (address != null) data['address'] = address!.toJson();

    return data;
  }
}
