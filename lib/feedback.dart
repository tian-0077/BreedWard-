import 'package:breedward/feedbackconfirm.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;

  Map<String, bool> improvementOptions = {
    "App Responsiveness": false,
    "Ease of Navigation": false,
    "Visual Design and Layout": false,
    "Real-Time Data Display": false,
    "Overall User Experience": false,
  };

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('tester_feedback').add({
          'feedback': _feedbackController.text,
          'timestamp': Timestamp.now(),
          'rating': _rating,
          'improvements':
              improvementOptions.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Feedbackconfirm()),
        );

        _feedbackController.clear();
        setState(() {
          improvementOptions.updateAll((key, value) => false);
        });
      } catch (e) {
        print('Error submitting feedback: $e');
      }
    }
  }

  Widget _buildToggleButton(String label) {
    bool isSelected = improvementOptions[label] ?? false;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          improvementOptions[label] = !isSelected;
        });
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          textStyle: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 41, 41, 41),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: GoogleFonts.outfit(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            height: 20,
            thickness: 15,
            color: const Color.fromARGB(255, 198, 198, 198),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate Your Experience",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Are you satisfied with the service?",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: List.generate(5, (index) {
                      int starIndex = index + 1;
                      IconData iconData;
                      if (_rating >= starIndex) {
                        iconData = Icons.star;
                      } else if (_rating == starIndex - 0.5) {
                        iconData = Icons.star_half;
                      } else {
                        iconData = Icons.star_border;
                      }

                      return IconButton(
                        icon: Icon(iconData, color: Colors.green, size: 50),
                        onPressed: () {
                          setState(() {
                            _rating = starIndex;
                          });
                        },
                      );
                    }),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Tell us what can we improve?',
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children:
                        improvementOptions.keys
                            .map((label) => _buildToggleButton(label))
                            .toList(),
                  ),

                  SizedBox(height: 25),
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here...',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Feedback cannot be empty' : null,
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        backgroundColor: Colors.green,
                       
                        
                        
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.outfit(
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
