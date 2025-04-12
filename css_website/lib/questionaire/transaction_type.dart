import 'package:flutter/material.dart';
import 'package:css_website/widgets/custom_buttons.dart';
import 'package:css_website/widgets/custom_dropdown.dart';

class TransactionTypePage extends StatefulWidget {
  final Function(Map<String, String?>) onNext;

  const TransactionTypePage({super.key, required this.onNext});

  @override
  State<TransactionTypePage> createState() => _TransactionTypePageState();
}

class _TransactionTypePageState extends State<TransactionTypePage> {
  String? selectedType;
  bool hasError = false;

  Map<String, String?> answers = {};

  int getTransactionTypeId(String? type) {
    if (type == "Face-to-Face") return 1;
    if (type == "Online") return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Getting started!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            const Text(
              "Help us understand what we are working on today by providing the following information:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30),
            CustomDropdown(
              labelText: "Transaction Type",
              items: const ['Face-to-Face', 'Online'],
              selectedValue: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  hasError =
                      value == null;
                });
              },
              hasError: hasError,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButtons(
                label: "Next",
                onPressed: () {
                  if (selectedType == null) {
                    setState(() => hasError = true);
                    return;
                  }
                  answers['transaction_type'] =
                      selectedType; // Save selected type as value
                  widget.onNext(answers);
                  print("answers: $answers");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
