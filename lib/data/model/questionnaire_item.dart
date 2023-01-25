import 'package:non_cognitive/data/model/question_item.dart';

class QuestionnaireItem {
  final String title;
  final String description;
  final List<QuestionItem> question_list;

  QuestionnaireItem({required this.title, required this.description, required this.question_list});
}