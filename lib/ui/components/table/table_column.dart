import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

List<DataColumn> createTableHeaders(List<String> field_list) {
  return field_list.map((field) {
    return DataColumn(
        label: Expanded(
            child: Container(
              color: lightGray,
              height: double.infinity,
              alignment: Alignment.center,
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: field,
                align: TextAlign.center,
              ),
            )
        ),
    );
  }).toList();
}