import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:second_attempt/models/project_model.dart';

import 'providers/home_tab_provider.dart';

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Todo'),
        ),
        body: Center(
          child: Scaffold(
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
                  onTap: () => {createProjectDialog(context)}),
              Container(
                child: Consumer<HomeTabProvider>(
                    builder: (context, tabProvider, child) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: tabProvider.projects.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          child: Card(
                            color: new Color(tabProvider.projects[index].color),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                tabProvider.projects[index].title,
                              ),
                            ),
                          ),
                          onTap: () => {});
                    },
                  );
                }),
              )
            ],
          )),
        ),
      ),
    );
  }

  void createProjectDialog(context) {
    final projectTitleTextController = TextEditingController();
    Alert(
        context: context,
        title: "Create Project",
        content: Column(
          children: <Widget>[
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
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              Provider.of<HomeTabProvider>(context, listen: false).addProject(
                  Project(projectTitleTextController.text,
                      projectTitleTextController.text, pickerColor.value)),
            },
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
