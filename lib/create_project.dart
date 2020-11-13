import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:second_attempt/models/project_model.dart';
import 'providers/home_tab_provider.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  final projectTitleTextController = TextEditingController();

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Projects')),
        ),
        body: createProjectDialog(context));
  }

  void createProject(String a, String b, int c) {
    Provider.of<HomeTabProvider>(context, listen: false)
        .addProject(Project(a, b, c));
  }

  Widget createProjectDialog(context) {
    return Container(
      child: Column(children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            // icon: Icon(Icons.),
            labelText: 'Project Name',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please name your project';
            } else {
              return null;
            }
          },
          controller: projectTitleTextController,
        ),
        BlockPicker(
          pickerColor: currentColor,
          onColorChanged: changeColor,
        ),
        RaisedButton(
          onPressed: () => {
            Provider.of<HomeTabProvider>(context, listen: false).addProject(
                Project(projectTitleTextController.text,
                    projectTitleTextController.text, pickerColor.value)),
            // createProject(projectTitleTextController.text,
            //     projectTitleTextController.text, pickerColor.value),
            Navigator.pop(context),
          },
          child: Text(
            "Create",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]),
    );
  }
}
