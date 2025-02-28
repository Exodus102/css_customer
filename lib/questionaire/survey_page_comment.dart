import 'package:css_website/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class SurveyPageComment extends StatefulWidget {
  final Function(String) onSubmit; // Updated to pass feedback
  final VoidCallback? onBack;

  const SurveyPageComment({super.key, required this.onSubmit, this.onBack});

  @override
  State<SurveyPageComment> createState() => _SurveyPageCommentState();
}

class _SurveyPageCommentState extends State<SurveyPageComment> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your thoughts matter!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'We\'d love to hear your comments and suggestions to serve you better.',
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Comments and suggestions:',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF064089),
                        width: 2.0,
                      ),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.trim().toLowerCase() == 'none') {
                      return 'Please enter a valid response';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _feedback = value;
                    });
                  },
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtons(
                      onPressed: widget.onBack ?? () {},
                      label: "Back",
                    ),
                    CustomButtons(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(_feedback); // Pass feedback to onSubmit
                        }
                      },
                      label: "Submit",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}