import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:second_attempt/models/project_model.dart';

import '../projects_list_screen/create_project_screen.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Center(child: const Text('Projects')),
        // ),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create New Project',
                ),
              ),
            ),
            onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateProject()))
                }),
        Container(
          child: Consumer<List<Project>>(builder: (context, projects, child) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (projects == null) ? 0 : projects.length,
              itemBuilder: (context, index) {
                return InkWell(
                    child: Card(
                      color: new Color(projects[index].color),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          projects[index].title,
                        ),
                      ),
                    ),
                    onTap: () => {});
              },
            );
          }),
        )
      ],
    ));
  }
}
