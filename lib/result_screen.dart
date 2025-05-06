import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final resultColor = percentage >= 70 ? Colors.green : (percentage >= 50 ? Colors.orange : Colors.red);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: resultColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
             child: Center(
  child: Text(
    '${percentage.toStringAsFixed(2)}%', // Rounds to 2 decimal places
    style: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: resultColor,
    ),
  ),
),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$score out of $totalQuestions questions',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            _buildResultMessage(percentage),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultMessage(double percentage) {
    String message;
    IconData icon;
    Color color;

    if (percentage >= 80) {
      message = 'Excellent!';
      icon = Icons.emoji_events;
      color = Colors.green;
    } else if (percentage >= 60) {
      message = 'Good job!';
      icon = Icons.thumb_up;
      color = Colors.blue;
    } else if (percentage >= 40) {
      message = 'You can do better!';
      icon = Icons.trending_up;
      color = Colors.orange;
    } else {
      message = 'Try again!';
      icon = Icons.refresh;
      color = Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          message,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}