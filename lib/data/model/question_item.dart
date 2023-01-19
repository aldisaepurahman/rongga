class QuestionItem {
  String question;
  List<String> choices;
  String groupValue;
  String? category;
  dynamic alternativeValue;

  QuestionItem({required this.question, required this.choices, required this.groupValue, this.category, this.alternativeValue});
}