import 'dart:convert';
import 'package:css_website/questionaire/closing_page.dart';
import 'package:css_website/questionaire/survey_page_comment.dart';
import 'package:css_website/questionaire/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'survey_page.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final PageController pageController = PageController();
  bool isLoading = false;
  Map<String, List<Map<String, dynamic>>> sections = {};
  int currentSectionIndex = 0;
  Map<String, String?> allResponses = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchQuestions() async {
    String? selectedType = allResponses['transaction_type'];

    int typeParam = 0;
    if (selectedType == "Face-to-Face") typeParam = 1;
    if (selectedType == "Online") typeParam = 2;
    final response = await http.get(Uri.parse(
        'http://192.168.1.104/database/questionaire/get_question_customer_page.php?transaction_type=$typeParam'));

    print("Response: ${response.body}}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final parsedSections = data.map((sectionName, questions) {
          if (questions == null || questions is! List) {
            print(
                "Warning: Section '$sectionName' has null or invalid questions!");
            return MapEntry(sectionName, <Map<String, dynamic>>[]);
          }

          final questionList = questions.map<Map<String, dynamic>>((question) {
            if (question == null || question is! Map<String, dynamic>) {
              print("Warning: Skipping invalid question format: $question");
              return {};
            }
            return Map<String, dynamic>.from(question);
          }).toList();

          return MapEntry(sectionName, questionList);
        });

        setState(() {
          sections = parsedSections;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error decoding API response: $e");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  // Navigate to the next page and save responses
  void navigateToNextPage(Map<String, String?> sectionResponses) {
    setState(() {
      allResponses.addAll(sectionResponses);
      currentSectionIndex++;
    });

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    print("Current Index $currentSectionIndex");
  }

  Map<String, List<Map<String, dynamic>>> filterQuestionsByTransactionType(
      int transactionType) {
    Map<String, List<Map<String, dynamic>>> filteredSections = {};

    sections.forEach((sectionName, questions) {
      // Filter out questions based on the transaction type
      List<Map<String, dynamic>> filteredQuestions =
          questions.where((question) {
        int questionType = question['transaction_type'] ?? 0;
        return questionType == 0 || questionType == transactionType;
      }).toList();

      if (filteredQuestions.isNotEmpty) {
        filteredSections[sectionName] = filteredQuestions;
      }
    });

    return filteredSections;
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
  Future<void> onSubmitFeedback(String feedback, String sentiment) async {
    setState(() {
      allResponses['feedback'] = feedback;
      allResponses['sentiment'] = sentiment;
    });

    Map<String, dynamic> postData = {
      "responses": allResponses
        ..remove("feedback")
        ..remove("sentiment"),
      "comment": feedback,
      "analysis": sentiment,
    };

    final response = await http.post(
      Uri.parse("http://192.168.1.104/database/response/insert_response.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      print("Response saved successfully!");
    } else {
      print("Error saving response: ${response.body}");
    }

    navigateToNextPage({});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Survey and feedback submitted!')),
    );
  }

  void onSubmitAnotherResponse() {
    setState(() {
      currentSectionIndex = 0; // Reset to first page
      allResponses.clear(); // Clear previous responses
    });
    pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
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
        itemCount: sections.length + 3,
        onPageChanged: (index) {
          setState(() {
            currentSectionIndex = index;
          });
          print("Page changed to index: $index");
        },
        itemBuilder: (context, index) {
          // ClosingPage
          if (index == sections.length + 1) {
            return ClosingPage(
              onSubmitAnotherResponse: onSubmitAnotherResponse,
            );
          }
          // SurveyPageComment
          if (index == sections.length + 1) {
            return SurveyPageComment(
              onSubmit: onSubmitFeedback,
              onBack: navigateToPreviousPage,
            );
          }

          if (index == 0) {
            return TransactionTypePage(
              onNext: (Map<String, String?> answers) {
                final selected = answers['transaction_type'];
                setState(() {
                  allResponses['transaction_type'] = selected;
                });
                fetchQuestions();
                navigateToNextPage({'transaction_type': selected});
              },
            );
          }

          // Survey sections
          final sectionIndex = index - 1;
          final sectionName = sections.keys.elementAt(sectionIndex);
          final questions = sections[sectionName] ?? [];

          return SurveyPage(
            currentIndex: currentSectionIndex,
            sectionName: sectionName,
            questions: questions,
            onNext: navigateToNextPage,
            onBack: index > 0 ? navigateToPreviousPage : null,
            totalSections: sections.length,
          );
        },
      ),
    );
  }
}
