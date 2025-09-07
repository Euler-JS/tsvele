// lib/Model/subscription_model.dart
import 'package:flutter/material.dart';

class SubscriptionPlan {
  final int id;
  final String type;
  final String name;
  final double price;
  final int durationDays;
  final String description;

  SubscriptionPlan({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.description,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      durationDays: json['duration_days'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'price': price.toString(),
      'duration_days': durationDays,
      'description': description,
    };
  }

  // Método para obter a cor do plano baseada no tipo
  Color get planColor {
    switch (type) {
      case 'weekly':
        return const Color(0xFF4CAF50); // Verde
      case 'monthly':
        return const Color(0xFF2196F3); // Azul
      case 'quarterly':
        return const Color(0xFFFF9800); // Laranja
      case 'semi_annual':
        return const Color(0xFF9C27B0); // Roxo
      case 'yearly':
        return const Color(0xFFC7A87B); // Dourado
      default:
        return const Color(0xFF757575); // Cinza
    }
  }

  // Método para obter ícone do plano
  IconData get planIcon {
    switch (type) {
      case 'weekly':
        return Icons.calendar_view_week;
      case 'monthly':
        return Icons.calendar_view_month;
      case 'quarterly':
        return Icons.calendar_today;
      case 'semi_annual':
        return Icons.event_note;
      case 'yearly':
        return Icons.event;
      default:
        return Icons.star;
    }
  }

  // Método para obter duração formatada
  String get formattedDuration {
    if (durationDays < 30) {
      return '$durationDays dias';
    } else if (durationDays < 365) {
      int months = (durationDays / 30).round();
      return months == 1 ? '1 mês' : '$months meses';
    } else {
      int years = (durationDays / 365).round();
      return years == 1 ? '1 ano' : '$years anos';
    }
  }

  // Método para obter preço formatado
  String get formattedPrice {
    return 'MT ${price.toStringAsFixed(2)}';
  }

  // Método para calcular valor por dia
  double get pricePerDay {
    return price / durationDays;
  }

  // Método para obter valor por dia formatado
  String get formattedPricePerDay {
    return 'MT ${pricePerDay.toStringAsFixed(2)}/dia';
  }

  // Verificar se é o plano mais popular (mensal)
  bool get isPopular {
    return type == 'monthly';
  }

  // Verificar se é o melhor valor (anual)
  bool get isBestValue {
    return type == 'yearly';
  }
}

class SubscriptionPlansResponse {
  final String status;
  final List<SubscriptionPlan> data;
  final String message;

  SubscriptionPlansResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SubscriptionPlan.fromJson(item))
          .toList() ?? [],
      message: json['message'] ?? '',
    );
  }

  bool get isSuccess => status == 'success';
}

// Modelo para pagamento M-Pesa
class MpesaPaymentRequest {
  final int planType;
  final String phoneNumber;

  MpesaPaymentRequest({
    required this.planType,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'plan_type': planType,
      'phone_number': phoneNumber,
    };
  }
}

class MpesaPaymentResponse {
  final String status;
  final Map<String, dynamic>? data;
  final String message;
  final List<String>? errors;

  MpesaPaymentResponse({
    required this.status,
    this.data,
    required this.message,
    this.errors,
  });

  factory MpesaPaymentResponse.fromJson(Map<String, dynamic> json) {
    return MpesaPaymentResponse(
      status: json['status'] ?? '',
      data: json['data'],
      message: json['message'] ?? '',
      errors: (json['errors'] as List<dynamic>?)?.cast<String>(),
    );
  }

  bool get isSuccess => status == 'success';
}

// Modelo para histórico de assinaturas do usuário
class UserSubscription {
  final int id;
  final int userId;
  final int planId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final double amount;
  final String? paymentMethod;
  final String? transactionId;
  final SubscriptionPlan? plan;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.amount,
    this.paymentMethod,
    this.transactionId,
    this.plan,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      status: json['status'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'],
      transactionId: json['transaction_id'],
      plan: json['plan'] != null ? SubscriptionPlan.fromJson(json['plan']) : null,
    );
  }

  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now());
  bool get isExpired => endDate.isBefore(DateTime.now());
  
  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  String get formattedAmount => 'MT ${amount.toStringAsFixed(2)}';
}
