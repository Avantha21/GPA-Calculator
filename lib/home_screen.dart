import 'package:flutter/material.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _courses = [];
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _universityNameController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  String _selectedGrade = 'A+';

  final List<String> _grades = [
    'A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'E'
  ];

  void _addCourse() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _courses.add({
          'name': _courseNameController.text,
          'credit': int.parse(_creditController.text),
          'grade': _selectedGrade,
        });
        _courseNameController.clear();
        _creditController.clear();
      });
    }
  }

  void _deleteCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  void _clearAllCourses() {
    setState(() {
      _courses.clear(); // Clear the list of courses
    });
  }

  void _navigateToResultScreen() {
    if (_universityNameController.text.isEmpty || _studentNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter University Name and Student Name')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          courses: _courses,
          universityName: _universityNameController.text,
          studentName: _studentNameController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPA Calculator',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Your Courses',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),
                // University Name Field
                TextFormField(
                  controller: _universityNameController,
                  decoration: InputDecoration(
                    labelText: 'University Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your university name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Student Name Field
                TextFormField(
                  controller: _studentNameController,
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Course Name Field
                TextFormField(
                  controller: _courseNameController,
                  decoration: InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a course name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Credit Field
                TextFormField(
                  controller: _creditController,
                  decoration: InputDecoration(
                    labelText: 'Credit',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the credit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Grade Dropdown
                DropdownButtonFormField(
                  value: _selectedGrade,
                  items: _grades.map((String grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Grade',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Add Course Button
                ElevatedButton(
                  onPressed: _addCourse,
                  child: Text('Add Course'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                // Display Courses in a DataTable
                if (_courses.isNotEmpty)
                  DataTable(
                    columns: [
                      DataColumn(label: Text('Course Name')),
                      DataColumn(label: Text('Credit')),
                      DataColumn(label: Text('Grade')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: _courses.map((course) {
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return _courses.indexOf(course) % 2 == 0
                                ? Colors.grey[200]!
                                : Colors.white;
                          },
                        ),
                        cells: [
                          DataCell(Text(course['name'])),
                          DataCell(Text(course['credit'].toString())),
                          DataCell(Text(course['grade'])),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteCourse(_courses.indexOf(course)),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                SizedBox(height: 20),
                // Calculate GPA Button
                ElevatedButton(
                  onPressed: _navigateToResultScreen,
                  child: Text('Calculate GPA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                // Clear All Courses Button
                if (_courses.isNotEmpty)
                  ElevatedButton(
                    onPressed: _clearAllCourses,
                    child: Text('Clear All Courses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}