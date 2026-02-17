import 'package:flutter/material.dart';
import 'widgets/message.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/chat_input_field.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<Message> _messages = [
    Message(text: 'Hello! How can I assist you today? 👋', isUser: false),
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });

    _scrollToBottom();
    _simulateAiResponse(text);
  }

  void _simulateAiResponse(String userMessage) {
    setState(() => _isTyping = true);

    // Simulate AI thinking time
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      String response = _generateResponse(userMessage);

      setState(() {
        _isTyping = false;
        _messages.add(Message(text: response, isUser: false));
      });

      _scrollToBottom();
    });
  }

  String _generateResponse(String userMessage) {
    final lowerMsg = userMessage.toLowerCase();

    if (lowerMsg.contains('trail') || lowerMsg.contains('hike')) {
      return 'I recommend checking out the Appalachian Trail and the Pacific Crest Trail. They offer stunning views and great hiking experiences! 🏔️';
    } else if (lowerMsg.contains('weather')) {
      return 'For accurate weather information, please check your local forecast. Always be prepared for changing conditions on the trail! ⛅';
    } else if (lowerMsg.contains('gear') || lowerMsg.contains('equipment')) {
      return 'Essential hiking gear includes proper footwear, water, navigation tools, first aid kit, and appropriate clothing layers. Would you like specific recommendations? 🎒';
    } else if (lowerMsg.contains('safety')) {
      return 'Trail safety is paramount! Always let someone know your plans, carry essentials, stay on marked trails, and be aware of your surroundings. 🛡️';
    } else {
      return 'That\'s an interesting question! I\'m here to help with trail recommendations, hiking tips, gear advice, and safety information. What would you like to know more about? 🤔';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B4EFF), Color(0xFF9B4EFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Always here to help',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey[50]!, Colors.grey[100]!],
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return const TypingIndicator();
                    }
                    return MessageBubble(message: _messages[index]);
                  },
                ),
              ),
            ),
            ChatInputField(
              controller: _textController,
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
