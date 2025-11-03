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
    debugPrint('Error parsing JSON: $err');
    // Fallback to the message itself if JSON parsing fails
    return message;
  }
}
