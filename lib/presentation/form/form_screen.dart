import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/core/widget/date_picker.dart';
import 'package:task_manager/core/widget/text_form_field.dart';
import 'package:task_manager/presentation/form/widget/form_widget.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorApp,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Todo'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsetsDirectional.all(18),
            child: ListView(
              children: [
                TextFormWidget(label: 'Title', icon: FontAwesomeIcons.t),
                TextFormWidget(
                  label: 'Description',
                  icon: FontAwesomeIcons.paragraph,
                  maxLines: 9,
                ),
                DatePickerWidget(),
                PriorityDropdown(),
                StatusDropdown()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
