import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/todo_provider.dart';

class CreateTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: TodoFormWidget(),
    );
  }
}

class TodoFormWidget extends StatefulWidget {
  @override
  _TodoFormWidgetState createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {
  final _todoFormKey = GlobalKey<FormState>();
  final _todoTitleTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _todoFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please name your todo';
              } else {
                return null;
              }
            },
            controller: _todoTitleTextController,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => {
                if (_todoFormKey.currentState.validate())
                  {
                    Provider.of<TodoProvider>(context, listen: false)
                        .addNewTodo(Todo(
                            _todoTitleTextController.text, TodoStatus.todo)),
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('"' +
                            _todoTitleTextController.text +
                            '" is added as a Todo')))
                  }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
