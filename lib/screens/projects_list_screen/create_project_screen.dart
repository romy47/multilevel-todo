import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/services/database_service.dart';
import '../../providers/home_tab_provider.dart';

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
          title: Text('Create Project'),
        ),
        body: createProjectDialog(context));
  }

  Widget createProjectDialog(context) {
    return Scaffold(
      body: Column(children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
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
        SizedBox(
          height: 400.0,
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          ),
        ),
        RaisedButton(
          onPressed: () => {
            Provider.of<HomeTabProvider>(context, listen: false).addProject(
                Project(projectTitleTextController.text,
                    projectTitleTextController.text, pickerColor.value, 'sd')),
            DatabaseServices(FirebaseAuth.instance.currentUser.uid).addProject(
                new Project(projectTitleTextController.text, '',
                    pickerColor.value, FirebaseAuth.instance.currentUser.uid)),
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
