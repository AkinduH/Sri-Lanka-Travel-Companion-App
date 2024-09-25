import 'package:flutter/material.dart';
import 'services/connections.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_Message> _fastMessages = [];
  final List<_Message> _lengthyMessages = [];
  final TextEditingController _controller = TextEditingController();
  final Connections connectionService = Connections();

  String? _selectedGPT;
  bool _isFastMode = true;

  @override
  void initState() {
    super.initState();
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    setState(() {
      _fastMessages.add(_Message(
        text:
            "Hello! I'm your fast chatbot assistant. How can I help you today?",
        isUser: false,
      ));
      _lengthyMessages.add(_Message(
        text:
            "Hello! I'm your lengthy chatbot assistant. How can I help you today?",
        isUser: false,
      ));
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      (_isFastMode ? _fastMessages : _lengthyMessages)
          .add(_Message(text: text, isUser: true));
    });
    _controller.clear();

    try {
      String botResponse = await connectionService.sendMessageToChatbot(
          text, _selectedGPT, _isFastMode); // Pass isFastMode here
      setState(() {
        (_isFastMode ? _fastMessages : _lengthyMessages)
            .add(_Message(text: botResponse, isUser: false));
      });
    } catch (e) {
      setState(() {
        (_isFastMode ? _fastMessages : _lengthyMessages).add(
            _Message(text: "Error: Unable to get response.", isUser: false));
      });
    }
  }

  Widget _buildGPTSelector() {
    return DropdownButton<String>(
      value: _selectedGPT,
      hint: const Text("Select GPT"),
      items: <String>[
        'Default',
        'AgentGPT',
        'ShopGPT',
        'StayGPT',
        'TravelGPT',
        'PlacesGPT'
      ].map((String? value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value ?? 'None'),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGPT = newValue;
        });
      },
      isExpanded: false,
      underline: Container(),
    );
  }

  Widget _buildModeToggle() {
    return Switch(
      value: _isFastMode,
      onChanged: (value) {
        setState(() {
          _isFastMode = value;
        });
      },
      activeColor: Colors.green,
      inactiveTrackColor: Colors.blue,
      activeThumbImage: AssetImage('assets/fast_icon.png'),
      inactiveThumbImage: AssetImage('assets/lengthy_icon.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chatbot'),
          actions: [
            _buildModeToggle(),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount:
                    (_isFastMode ? _fastMessages : _lengthyMessages).length,
                itemBuilder: (context, index) {
                  final message =
                      (_isFastMode ? _fastMessages : _lengthyMessages)[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: MarkdownBody(
                        data: message.text,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      _buildGPTSelector(),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Send a message'),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message({required this.text, required this.isUser});
}
