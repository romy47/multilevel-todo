import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/screens/projects_list_screen/edit_project_screen.dart';
import 'package:second_attempt/services/database_service.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                          child: Row(children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(projects[index].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.00,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5.0),
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  onPressed: () => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProject(projects[index])))
                                  },
                                  icon: Icon(Icons.edit_outlined),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                onPressed: () => {
                                  if (projects.length > 1)
                                    {
                                      new DatabaseServices(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .deleteProject(projects[index].id)
                                    }
                                  else
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              CupertinoAlertDialog(
                                                  // title: const Text('Sorry'),
                                                  content: Text(
                                                      'At least one project is required'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ])),
                                    }
                                },
                                icon: Icon(Icons.delete_outline),
                                color: Colors.red,
                              ),
                            )
                          ]),
                        ),
                      ),
                      onTap: () => {});
                },
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateProject()))
        },
        tooltip: 'Add Project',
        child: const Icon(Icons.add),
      ),
    );
  }
}
