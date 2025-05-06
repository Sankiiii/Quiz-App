import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'result_screen.dart'; // Assuming you have a ResultScreen widget

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _timeLeft = 10; // Timer for each question
  late Timer _timer; // Timer for the question countdown

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What programming language is Flutter built with?',
      'options': ['Java', 'Dart', 'Kotlin', 'Swift'],
      'correctAnswer': 'Dart',
      'hint': 'It starts with the letter D.',
    },
    {
      'question': 'Which company developed Flutter?',
      'options': ['Apple', 'Google', 'Microsoft', 'Facebook'],
      'correctAnswer': 'Google',
      'hint': 'It\'s also the creator of Android.',
    },
    {
      'question': 'What is the purpose of the `pubspec.yaml` file in Flutter?',
      'options': [
        'To define project dependencies',
        'To write Dart code',
        'To configure the app\'s UI',
        'To manage state'
      ],
      'correctAnswer': 'To define project dependencies',
      'hint': 'It\'s used to manage packages and assets.',
    },
    {
      'question': 'Which command is used to run a Flutter app in debug mode?',
      'options': [
        'flutter build',
        'flutter run',
        'flutter start',
        'flutter debug'
      ],
      'correctAnswer': 'flutter run',
      'hint': 'It starts the app on an emulator or device.',
    },
    {
      'question': 'What is the purpose of the `setState` method in Flutter?',
      'options': [
        'To update the UI',
        'To fetch data from an API',
        'To navigate to a new screen',
        'To manage global state'
      ],
      'correctAnswer': 'To update the UI',
      'hint': 'It triggers a rebuild of the widget.',
    },
    {
      'question': 'Which widget is used to create a scrollable list in Flutter?',
      'options': ['Column', 'ListView', 'GridView', 'Stack'],
      'correctAnswer': 'ListView',
      'hint': 'It allows vertical scrolling.',
    },
    {
      'question': 'What is the primary function of the `MaterialApp` widget?',
      'options': [
        'To define the app\'s theme',
        'To create a material design app',
        'To manage state',
        'To handle navigation'
      ],
      'correctAnswer': 'To create a material design app',
      'hint': 'It provides a framework for material design apps.',
    },
    {
      'question': 'Which widget is used to add space between other widgets?',
      'options': ['Padding', 'Spacer', 'Container', 'SizedBox'],
      'correctAnswer': 'Spacer',
      'hint': 'It expands to fill available space.',
    },
    {
      'question': 'What is the purpose of the `async` and `await` keywords in Dart?',
      'options': [
        'To define asynchronous functions',
        'To create animations',
        'To manage state',
        'To handle navigation'
      ],
      'correctAnswer': 'To define asynchronous functions',
      'hint': 'They are used for non-blocking operations.',
    },
    {
      'question': 'Which widget is used to create a button with an icon in Flutter?',
      'options': [
        'TextButton',
        'IconButton',
        'ElevatedButton',
        'FloatingActionButton'
      ],
      'correctAnswer': 'IconButton',
      'hint': 'It displays an icon and responds to taps.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _startTimer(); // Start the timer when the quiz screen initializes
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel(); // Stop the timer when time runs out
          _handleTimeOut(); // Handle the timeout scenario
        }
      });
    });
  }

  void _handleTimeOut() {
    // Automatically select a wrong answer
    final options = _questions[_currentQuestionIndex]['options'];
    final correctAnswer = _questions[_currentQuestionIndex]['correctAnswer'];
    String wrongAnswer = options.firstWhere((option) => option != correctAnswer);

    _checkAnswer(wrongAnswer); // Pass the wrong answer to checkAnswer
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _checkAnswer(String selectedOption) {
    try {
      final correctAnswer = _questions[_currentQuestionIndex]['correctAnswer'];

      if (selectedOption == correctAnswer) {
        setState(() {
          _score++;
        });
      }

      // Check if there are more questions
      if (_currentQuestionIndex < _questions.length - 1) {
        _nextQuestion();
      } else {
        setState(() {
          _isQuizCompleted = true;
        });
      }
    } catch (e) {
      // Handle any exceptions that might occur
      print('Error: $e');
      setState(() {
        _isQuizCompleted = true; // End the quiz if an error occurs
      });
    }
  }

  void _nextQuestion() {
    _timer.cancel(); // Cancel the current timer
    _animationController.reset();

    // Check if there are more questions
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 10; // Reset the timer for the next question
      });
      _animationController.forward();
      _startTimer(); // Start the timer for the next question
    } else {
      // If no more questions, mark the quiz as completed
      setState(() {
        _isQuizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizCompleted = false;
      _timeLeft = 10; // Reset the timer
    });
    _animationController.reset();
    _animationController.forward();
    _startTimer(); // Start the timer again
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 10,
        shadowColor: Colors.blue.withOpacity(0.5),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _isQuizCompleted
                ? ResultScreen(
              score: _score,
              totalQuestions: _questions.length,
              onRestart: _restartQuiz,
            )
                : _buildQuizScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _questions[_currentQuestionIndex]['options'].length,
              itemBuilder: (context, index) {
                final option = _questions[_currentQuestionIndex]['options'][index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildOptionButton(option),
                );
              },
            ),
          ),
          Text(
            'Time Left: $_timeLeft seconds',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: () {
              _showHintDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(option),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Text(
        option,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: Text(_questions[_currentQuestionIndex]['hint']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}