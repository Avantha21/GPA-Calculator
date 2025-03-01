import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final String universityName;
  final String studentName;

  ResultScreen({
    required this.courses,
    required this.universityName,
    required this.studentName,
  });

  // Calculate total credits
  int _calculateTotalCredits() {
    return courses.fold(
        0, (int sum, course) => sum + (course['credit'] as int));
  }

  // Calculate total grade points
  double _calculateTotalGradePoints() {
    return courses.fold(0.0, (sum, course) {
      double gradePoint = _getGradePoint(course['grade']);
      return sum + (gradePoint * (course['credit'] as int));
    });
  }

  // Calculate GPA
  double _calculateGPA() {
    int totalCredits = _calculateTotalCredits();
    double totalGradePoints = _calculateTotalGradePoints();
    return totalGradePoints / totalCredits;
  }

  // Helper function to get grade points
  double _getGradePoint(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      case 'E':
        return 0.7;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalCredits = _calculateTotalCredits();
    final double totalGradePoints = _calculateTotalGradePoints();
    final double gpa = _calculateGPA();

    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Result'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.blue, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200]!.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GPA Result',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18),
                _buildResultRow('University Name', universityName),
                _buildResultRow('Student Name', studentName),
                _buildResultRow('Total Credits', totalCredits.toString()),
                _buildResultRow(
                    'Total Grade Points', totalGradePoints.toStringAsFixed(2)),
              ],
            ),
          ),
        ),
      ),
      // GPA Bar at the bottom
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              'Your GPA: ${gpa.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      // Back button
      floatingActionButton: Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Go back to HomeScreen
          },
          child: Text('Back'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Helper widget to build a result row
  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
