import 'dart:convert';
import 'package:css_website/questionaire/closing_page.dart';
import 'package:css_website/questionaire/survey_page_comment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'survey_page.dart'; // Includes SurveyPage, SurveyPageComment, and ClosingPage

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final PageController pageController = PageController();
  bool isLoading = true;
  Map<String, List<Map<String, dynamic>>> sections = {};
  int currentSectionIndex = 0;
  Map<String, String?> allResponses = {}; // Store all user responses

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // Fetch questions from the PHP backend
  Future<void> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.53/database/questionaire/get_question_customer_page.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final parsedSections = data.map((sectionName, questions) {
        final questionList =
            List<Map<String, dynamic>>.from(questions.map((question) {
          return Map<String, dynamic>.from(question);
        }));
        return MapEntry(sectionName, questionList);
      });

      setState(() {
        sections = parsedSections;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load data');
    }
  }

  // Navigate to the next page and save responses
  void navigateToNextPage(Map<String, String?> sectionResponses) {
    setState(() {
      allResponses.addAll(sectionResponses); // Accumulate responses
      currentSectionIndex++;
    });
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    print("Current Index $currentSectionIndex");
  }

  // Navigate to the previous page
  void navigateToPreviousPage() {
    setState(() {
      currentSectionIndex--;
    });
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Handle feedback submission and move to ClosingPage
  void onSubmitFeedback(String feedback) {
    setState(() {
      allResponses['feedback'] = feedback; // Add feedback to responses
    });
    print("All User Responses: $allResponses"); // Print all responses
    navigateToNextPage({}); // Move to ClosingPage (no new section responses)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Survey and feedback submitted!')),
    );
  }

  // Handle submitting another response (reset to start)
  void onSubmitAnotherResponse() {
    setState(() {
      currentSectionIndex = 0; // Reset to first page
      allResponses.clear(); // Clear previous responses
    });
    pageController.jumpToPage(0); // Jump back to start
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: screenWidth,
      height: screenHeight * 0.69,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sections.length + 2, // Add 2 for Comment and Closing pages
        onPageChanged: (index) {
          setState(() {
            currentSectionIndex = index;
          });
        },
        itemBuilder: (context, index) {
          // ClosingPage
          if (index == sections.length + 1) {
            return ClosingPage(
              onSubmitAnotherResponse: onSubmitAnotherResponse,
            );
          }
          // SurveyPageComment
          if (index == sections.length) {
            return SurveyPageComment(
              onSubmit: onSubmitFeedback,
              onBack: navigateToPreviousPage,
            );
          }

          // Survey sections
          final sectionName = sections.keys.elementAt(index);
          final questions = sections[sectionName] ?? [];

          return SurveyPage(
            currentIndex: currentSectionIndex,
            sectionName: sectionName,
            questions: questions,
            onNext: navigateToNextPage, // Pass updated onNext
            onBack: index > 0 ? navigateToPreviousPage : null,
            totalSections: sections.length,
          );
        },
      ),
    );
  }
}
