import 'package:flutter/material.dart';
import 'package:css_website/questionaire/section_header.dart';
import 'package:css_website/widgets/custom_buttons.dart';
import 'package:css_website/widgets/custom_dropdown.dart';
import 'package:css_website/widgets/custom_textfield.dart';

class SurveyPage extends StatefulWidget {
  final String sectionName;
  final List<Map<String, dynamic>> questions;
  final Function(Map<String, String?>) onNext;
  final VoidCallback? onBack;
  final int currentIndex;
  final int totalSections;

  const SurveyPage({
    super.key,
    required this.sectionName,
    required this.questions,
    required this.onNext,
    this.onBack,
    required this.currentIndex,
    required this.totalSections,
  });

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  Map<String, String?> answers = {};
  final _formKey = GlobalKey<FormState>();
  Set<String> unansweredRequiredQuestions =
      {}; // Track unanswered required questions

  void validateAndHighlight() {
    setState(() {
      unansweredRequiredQuestions.clear();
      for (var question in widget.questions) {
        if (question['required'] == true &&
            (answers[question['id']] == null ||
                answers[question['id']]!.isEmpty)) {
          unansweredRequiredQuestions.add(question['id']);
        }
      }
    });

    if (unansweredRequiredQuestions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all required questions.'),
        ),
      );
    } else {
      widget.onNext(answers); // Proceed if all required questions are answered
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(sectionName: widget.sectionName),
                for (var question in widget.questions)
                  if (question['status'] == "1")
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (question['type'] == 'Multiple Choice')
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    question['question'],
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    spacing: 10,
                                    children: List<Widget>.generate(
                                      question['choices'].length,
                                      (index) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Radio<String>(
                                            value: question['choices'][index],
                                            groupValue: answers[question['id']],
                                            onChanged: (value) {
                                              setState(() {
                                                answers[question['id']] = value;
                                                unansweredRequiredQuestions
                                                    .remove(question['id']);
                                              });
                                            },
                                            activeColor: Colors.blue,
                                            // Red border if required and unanswered
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          Text(
                                            question['choices'][index],
                                            style: TextStyle(
                                              color: question['required'] ==
                                                          true &&
                                                      unansweredRequiredQuestions
                                                          .contains(
                                                              question['id'])
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (question['type'] == 'Dropdown')
                            CustomDropdown(
                              labelText: question['question'],
                              items: List<String>.from(question['choices']),
                              selectedValue: answers[question['id']],
                              onChanged: (value) {
                                setState(() {
                                  answers[question['id']] = value;
                                  unansweredRequiredQuestions
                                      .remove(question['id']);
                                });
                              },
                              // Pass error state for red border
                              hasError: question['required'] == true &&
                                  unansweredRequiredQuestions
                                      .contains(question['id']),
                            ),
                          if (question['type'] == 'Text Answer')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question['question'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  onChanged: (value) {
                                    setState(() {
                                      answers[question['id']] = value;
                                      if (value.isNotEmpty) {
                                        unansweredRequiredQuestions
                                            .remove(question['id']);
                                      }
                                    });
                                  },
                                  // Red border if required and unanswered
                                  hasError: question['required'] == true &&
                                      unansweredRequiredQuestions
                                          .contains(question['id']),
                                ),
                              ],
                            ),
                          if (question['type'] == 'Description')
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                question['question'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: widget.currentIndex > 0
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (widget.currentIndex > 0 && widget.onBack != null)
                      CustomButtons(
                        onPressed: widget.onBack!,
                        label: "Back",
                      ),
                    CustomButtons(
                      onPressed:
                          validateAndHighlight, // Call validation function
                      label: widget.currentIndex == widget.totalSections - 1
                          ? "Finish"
                          : "Next",
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
