import 'package:flutter/material.dart';
import 'services/connections.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final Connections connectionService = Connections();

  bool _isFastMode = true;
  bool _isRecording = false;
  bool _isFirstMessage = true;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    setState(() {
      _messages.add(_Message(
        text: "Hello! I'm your chatbot assistant. How can I help you today?",
        isUser: false,
        selectedAgent: "General",
        isFastMode: true,
      ));
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(
        text: text,
        isUser: true,
        selectedAgent: "User",
        isFastMode: _isFastMode,
      ));
    });
    _controller.clear();

    try {
      Map<String, String> botResponse = await connectionService
          .sendMessageToChatbot(text, _isFastMode, _isFirstMessage, _sessionId);
      setState(() {
        _messages.add(_Message(
          text: botResponse['response'] ?? "No response",
          isUser: false,
          selectedAgent: botResponse['selected_agent'] ?? "Unknown",
          isFastMode: _isFastMode,
        ));
        if (_isFirstMessage) {
          _isFirstMessage = false;
          _sessionId = botResponse['sessionId'];
        }
      });
    } catch (e) {
      setState(() {
        _messages.add(_Message(
          text: "Error: Unable to get response.",
          isUser: false,
          selectedAgent: "Error",
          isFastMode: _isFastMode,
        ));
      });
    }
  }

  // Updated method to handle record button press
  void _handleRecordButton() {
    setState(() {
      _isRecording = !_isRecording;
    });
    if (!_isRecording) {
      _uploadAudioFile(
          "C:/Users/Akindu Himan/OneDrive/Documents/Sound Recordings/Recording.m4a");
    }
  }

  // Updated method to upload audio file
  Future<void> _uploadAudioFile(String filePath) async {
    try {
      print("filePath: $filePath");
      String transcribedText = await connectionService.uploadAudio(filePath);
      print("transcribedText: $transcribedText");
      if (transcribedText.isNotEmpty) {
        _sendMessage(transcribedText);
      } else {
        // Handle empty transcription
        setState(() {
          _messages.add(_Message(
            text: "Error: Transcription returned empty.",
            isUser: false,
            selectedAgent: "Error",
            isFastMode: _isFastMode,
          ));
        });
      }
    } catch (e) {
      // Handle upload/transcription error
      setState(() {
        _messages.add(_Message(
          text: "Error: Unable to transcribe audio.",
          isUser: false,
          selectedAgent: "Error",
          isFastMode: _isFastMode,
        ));
      });
    }
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
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
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
                            : (message.isFastMode
                                ? Colors.green[300]
                                : Colors.blue[300]),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!message.isUser)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message.selectedAgent,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  message.isFastMode
                                      ? Icons.flash_on
                                      : Icons.hourglass_empty,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          MarkdownBody(
                            data: message.text,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Send a message'),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    color: _isRecording ? Colors.red : Colors.blue,
                    onPressed: _handleRecordButton,
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(_controller.text),
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
  final String selectedAgent;
  final bool isFastMode;

  _Message({
    required this.text,
    required this.isUser,
    required this.selectedAgent,
    required this.isFastMode,
  });
}
