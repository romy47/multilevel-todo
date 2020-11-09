import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';

class Dasjboard extends StatefulWidget {
  @override
  _DasjboardState createState() => _DasjboardState();
}

class _DasjboardState extends State<Dasjboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dashboard')),
      ),
      body: Center(
        child: Container(
          // scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            // Container
            children: [
              Card(
                elevation: 7,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                child: Text('Today',
                                    style: TextStyle(fontSize: 17.0)))),
                        Row(
                          children: [
                            Container(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: DonutPieChart.withSampleData(context),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Streaks', style: TextStyle(fontSize: 17.0)),
                ),
              ),
              Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('History', style: TextStyle(fontSize: 17.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      _createTodoCompletionData(context),
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 15,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            showLeaderLines: false,
            outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 18),
            // insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 18),
            labelPosition: charts.ArcLabelPosition.outside,
          )
        ],
      ),
      behaviors: [
        // our title behaviour
        new charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          desiredMaxColumns: 2,
          desiredMaxRows: 2,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : "$value";
          },
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontFamily: 'Roboto',
              fontSize: 16),
        ),
      ],
    );
  }

  factory DonutPieChart.withSampleData(context) {
    return new DonutPieChart(
      _createTodoCompletionData(context),
      animate: true,
    );
  }

  static List<charts.Series<TodoCompletion, String>> _createTodoCompletionData(
      context) {
    List<TodoCompletion> data = [
      // new TodoCompletion("Eating Out", 1, Colors.red),
    ];
    data.add(new TodoCompletion(
        'Unfinished',
        Provider.of<TodoProvider>(context, listen: false)
            .getTasksByLevel(TodoStatus.onGoing, 'all')
            .length,
        Colors.grey[300]));

    Provider.of<HomeTabProvider>(context, listen: false)
        .projects
        .forEach((pro) {
      if (Provider.of<TodoProvider>(context, listen: false)
              .getTasksByLevel(TodoStatus.finished, pro.id)
              .length >
          0) {
        data.add(new TodoCompletion(
            pro.title,
            Provider.of<TodoProvider>(context, listen: false)
                .getTasksByLevel(TodoStatus.finished, pro.id)
                .length,
            new Color(pro.color)));
      }
    });
    return [
      new charts.Series<TodoCompletion, String>(
        id: 'completion',
        domainFn: (TodoCompletion todo, _) => todo.category,
        measureFn: (TodoCompletion todo, _) => todo.amount,
        data: data,
        colorFn: (TodoCompletion todo, _) =>
            charts.ColorUtil.fromDartColor(todo.color),
        labelAccessorFn: (TodoCompletion todo, _) => '${todo.amount}',
      )
    ];
  }
}

class TodoCompletion {
  final String category;
  final int amount;
  final Color color;
  TodoCompletion(this.category, this.amount, this.color);
}
