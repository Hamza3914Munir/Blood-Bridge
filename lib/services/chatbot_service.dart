import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {

  static const String _apiKey = 'AIzaSyCBX1BpzcfuuQ0hEn4BS0xSHDSL5jYL4og'; // Replace with your key
  late final GenerativeModel _model;

  ChatbotService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> sendMessage(String userMessage) async {
    try {
      final contextualPrompt = '''
You are BloodBridge AI, an intelligent assistant for a blood donation mobile application called "BloodBridge". You are specifically designed to help users with blood donation related queries, health information, eligibility criteria, and general support.

Your knowledge includes:
- Blood donation eligibility criteria (age 18-65, weight 50kg+, good health)
- Blood types and compatibility (A+, A-, B+, B-, AB+, AB-, O+, O-)
- Health requirements for donation (hemoglobin levels, blood pressure, pulse rate)
- Waiting periods (6 months after tattoos, 12 months after certain procedures)
- General health tips for donors
- Information about the donation process
- Medical center guidance
- Emergency blood request procedures

Always respond in a helpful, professional, and caring tone. If asked about medical advice beyond general donation information, recommend consulting healthcare professionals.

User's question: $userMessage

Please provide a helpful response as BloodBridge AI:''';

      final content = [Content.text(contextualPrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Sorry, I could not generate a response. Please try again.';
    } catch (e) {
      debugPrint('ChatbotService Error: $e');
      return 'Sorry, I\'m experiencing technical difficulties. Please try again later.';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}