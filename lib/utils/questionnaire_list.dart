import 'package:non_cognitive/data/model/questionnaire_item.dart';
import 'package:non_cognitive/utils/question_list.dart';

final questionnaire_list = [
  QuestionnaireItem(
    title: "Tes Kesejahteraan Psikologi",
    description: "Tes ini bertujuan untuk menganalisa bagaimana kesejahteraan psikologi dan emosional dari siswa",
    question_list: psychology_questions
  ),
  QuestionnaireItem(
    title: "Tes Aktivitas Belajar",
    description: "Tes ini bertujuan untuk menganalisa bagaimana aktivitas dari siswa selama belajar di rumah",
    question_list: study_habit_questions
  ),
  QuestionnaireItem(
    title: "Tes Kondisi Keluarga",
    description: "Tes ini bertujuan untuk menganalisa bagaimana kondisi keluarga dari siswa",
    question_list: family_questions
  ),
  QuestionnaireItem(
    title: "Tes Gaya Belajar",
    description: "Tes ini bertujuan untuk menganalisa bagaimana cara belajar dari siswa",
    question_list: study_style_questions
  )
];