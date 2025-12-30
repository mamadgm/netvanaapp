import 'dart:convert';
import 'package:flutter/foundation.dart';

String? extractDetailFromException(Object? e) {
  if (e == null) return null;
  // Convert to string
  String message = e.toString().trim();
  // If it starts with "Exception:", strip it off
  if (message.startsWith('Exception:')) {
    message = message.replaceFirst('Exception:', '').trim();
  }
  if (message.startsWith('Failed to send color: ')) {
    message = message.replaceFirst('Failed to send color:', '').trim();
  }

  try {
    // Try decoding the remaining string as JSON
    final data = jsonDecode(message);
    return data['detail'] ?? message;
  } catch (err) {
    try {
      final data = jsonDecode(message);
      final errorMessage = data['detail']?['detail']?['message'];
      return (errorMessage); // prints: کد وارد شده اشتباه است
    } catch (e) {
      // debugPrint('Error parsing message: $e');
    }

    return message;
  }
}
