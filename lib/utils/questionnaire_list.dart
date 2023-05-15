import 'package:non_cognitive/data/model/questionnaire_item.dart';
import 'package:non_cognitive/utils/question_list.dart';

final questionnaire_list = [
  QuestionnaireItem(
    title: "Tes Gaya Belajar Visual",
    description: "Tes ini bertujuan untuk menganalisa kecocokan anda dengan gaya belajar visual",
    question_list: visual_questions
  ),
  QuestionnaireItem(
    title: "Tes Gaya Belajar Auditorial",
    description: "Tes ini bertujuan untuk menganalisa kecocokan anda dengan gaya belajar auditorial",
    question_list: auditorial_questions
  ),
  QuestionnaireItem(
    title: "Tes Gaya Belajar Kinestetik",
    description: "Tes ini untuk menganalisa kecocokan anda dengan gaya belajar kinestetik",
    question_list: kinestetik_questions
  )
];