import 'package:css_website/questionaire/landing_page_questionaire.dart';
import 'package:css_website/questionaire/survey_page1.dart';
import 'package:css_website/questionaire/survey_page2.dart';
import 'package:css_website/questionaire/survey_page3.dart';
import 'package:css_website/questionaire/survey_page4.dart';
import 'package:css_website/questionaire/survey_page5.dart';
import 'package:css_website/questionaire/survey_page6.dart';
import 'package:css_website/questionaire/survey_page7.dart';
import 'package:flutter/material.dart';

class Questionaire extends StatefulWidget {
  const Questionaire({super.key});

  @override
  State<Questionaire> createState() => _QuestionaireState();
}

class _QuestionaireState extends State<Questionaire> {
  String? campus;
  String? division;
  String? officeUnit;
  String? customerName;
  String? customerContact;
  String? customerType;
  String? transactionType;
  String? purposeOfVisit;
  List<int>? selectedValues;
  List<int>? selectedValuesPage5;
  final PageController pageController = PageController();
  void saveData(String campus, String division, String officeUnit) {
    setState(() {
      this.campus = campus;
      this.division = division;
      this.officeUnit = officeUnit;
    });
  }

  void saveCustomerData(String? name, String? contact, String? type) {
    setState(() {
      customerName = name;
      customerContact = contact;
      customerType = type;
    });
  }

  void saveTransaction(String transactionType, String purposeOfVisit) {
    setState(() {
      this.transactionType = transactionType;
      this.purposeOfVisit = purposeOfVisit;
    });
  }

  void saveRatings(List<int> values) {
    setState(() {
      selectedValues = values;
    });
  }

  void saveRatingsPage5(List<int> values) {
    setState(() {
      selectedValuesPage5 = values;
    });
  }

  void navigateToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight * 0.69,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          LandingPageQuestionaire(
            onNext: navigateToNextPage,
            onSaveData: saveData,
          ),
          SurveyPage1(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            onSaveCustomer: saveCustomerData,
          ),
          SurveyPage2(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            customerName: customerName,
            customerContact: customerContact,
            customerType: customerType,
            onSaveData: saveTransaction,
          ),
          SurveyPage3(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            customerName: customerName,
            customerContact: customerContact,
            customerType: customerType,
            transactionType: transactionType,
            purposeOfVisit: purposeOfVisit,
          ),
          SurveyPage4(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            customerName: customerName,
            customerContact: customerContact,
            customerType: customerType,
            transactionType: transactionType,
            purposeOfVisit: purposeOfVisit,
            onSaveData: saveRatings,
          ),
          SurveyPage5(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            customerName: customerName,
            customerContact: customerContact,
            customerType: customerType,
            transactionType: transactionType,
            purposeOfVisit: purposeOfVisit,
            selectedValues: selectedValues,
            onSaveData: saveRatingsPage5,
          ),
          SurveyPage6(
            onNext: navigateToNextPage,
            campus: campus,
            division: division,
            officeUnit: officeUnit,
            customerName: customerName,
            customerContact: customerContact,
            customerType: customerType,
            transactionType: transactionType,
            purposeOfVisit: purposeOfVisit,
            selectedValues: selectedValues,
            selectedValuesPage5: selectedValuesPage5,
          ),
          const SurveyPage7(),
        ],
      ),
    );
  }
}
