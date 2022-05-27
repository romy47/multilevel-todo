import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:second_attempt/models/project_model.dart';
import 'package:second_attempt/services/database_service.dart';

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  Color pickerColor = Colors.purple;
  // Color currentColor = Colors.green;
  final projectTitleTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void changeColor(Color color) {
    print(color.toString());
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    pickerColor = Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Create Project'),
            ),
            body: createProjectDialog(context)));
  }

  Widget createProjectDialog(context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Project Name',
            ),
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Please provide a name';
              } else {
                return null;
              }
            },
            controller: projectTitleTextController,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Project Color',
                  style: TextStyle(fontSize: 17),
                ),
                Ink(
                  decoration: ShapeDecoration(
                    color: pickerColor,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                              title: const Text('Pick a Color'),
                              content: SingleChildScrollView(
                                child: SizedBox(
                                  height: 400.0,
                                  child: BlockPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                              )))
                    },
                    icon: Icon(Icons.colorize_outlined),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 50,
              width: double.maxFinite,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Save Project'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    DatabaseServices(FirebaseAuth.instance.currentUser.uid)
                        .addProject(new Project(
                            projectTitleTextController.text,
                            '',
                            pickerColor.value,
                            FirebaseAuth.instance.currentUser.uid));
                    Navigator.pop(context);
                  }
                },
              )),
        ]),
      ),
    );
  }
}
