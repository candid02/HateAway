import 'package:flutter/material.dart';
import '../widgets/result_card.dart';
import 'educational_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  bool _hasResult = false;
  List<Map<String, dynamic>> _history = [];

  Future<void> _analyzeText() async {
    final text = _textController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to analyze')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate API call with a delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock result - this would come from your ML model in the real app
    final mockResult = {
      'is_hate_speech': text.toLowerCase().contains('hate'),
      'confidence': 0.85,
      'category': text.toLowerCase().contains('hate') ? 'Hate speech' : 'None',
    };

    setState(() {
      _isAnalyzing = false;
      _hasResult = true;
      _history.add({
        'text': text,
        'result': mockResult,
        'timestamp': DateTime.now().toString(),
      });
    });
  }

  Future<void> _pickTextFile() async {
    // Simulate file picking
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock file content
    const String fileContent = "This is sample text from a file that would be analyzed for potential hate speech content.";
    
    setState(() {
      _textController.text = fileContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hate Speech Detector',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 58, 3),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationalScreen(),
                ),
              );
            },
            tooltip: 'Learn about hate speech',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistory,
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add the image here
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  'assets/images/hate_speech.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              _buildInputCard(),
              const SizedBox(height: 20),
              if (_isAnalyzing)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Analyzing text...'),
                    ],
                  ),
                )
              else if (_hasResult)
                ResultCard(
                  isHateSpeech: _history.last['result']['is_hate_speech'],
                  confidence: _history.last['result']['confidence'],
                  category: _history.last['result']['category'],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter text to analyze:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type or paste text here...',
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickTextFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Text'),
                ),
                ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeText,
                  icon: const Icon(Icons.search),
                  label: const Text('Analyze'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Analysis History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _history.isEmpty
                        ? const Center(
                            child: Text('No history yet'),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              final item = _history[_history.length - 1 - index];
                              final result = item['result'];
                              final isHateSpeech = result['is_hate_speech'];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    isHateSpeech
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle,
                                    color: isHateSpeech
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  title: Text(
                                    item['text'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'Date: ${DateTime.parse(item['timestamp']).toString().substring(0, 16)}',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _textController.text = item['text'];
                                    setState(() {
                                      _hasResult = true;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: const Text('Settings options will be implemented soon.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}