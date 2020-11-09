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
  int finishedTodoCount = 0;
  int onGoingTodoCount = 0;
  int percentage = 0;
  @override
  Widget build(BuildContext context) {
    onGoingTodoCount = Provider.of<TodoProvider>(context, listen: false)
        .getTasksByLevel(TodoStatus.onGoing, 'all')
        .length;
    finishedTodoCount = Provider.of<TodoProvider>(context, listen: false)
        .getTasksByLevel(TodoStatus.finished, 'all')
        .length;
    if (onGoingTodoCount + finishedTodoCount != 0) {
      percentage =
          ((finishedTodoCount / (onGoingTodoCount + finishedTodoCount)) * 100)
              .floor();
    }

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 185,
                              width: 185,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        width: 2, color: Colors.grey[200]),
                                  ),
                                ),
                                child: Stack(children: <Widget>[
                                  DonutPieChart.withSampleData(context),
                                  Center(
                                      child: Container(
                                    margin: const EdgeInsets.only(bottom: 40.0),
                                    child: Text(
                                      percentage.toString() + "%",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ]),
                              ),
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   textDirection: TextDirection.rtl,
                            //   children: [
                            //     Text(
                            //       '✔️Finished ' + finishedTodoCount.toString(),
                            //       style: TextStyle(
                            //         fontSize: 20.0,
                            //       ),
                            //     ),
                            //     Text(
                            //       'Remaining ' + onGoingTodoCount.toString(),
                            //       style: TextStyle(
                            //         fontSize: 20.0,
                            //       ),
                            //     ),
                            //     const Divider(
                            //       color: Colors.black,
                            //       height: 20,
                            //       thickness: 5,
                            //       indent: 20,
                            //       endIndent: 0,
                            //     ),
                            //     Text(
                            //       'Bonus      ' + '0',
                            //       style: TextStyle(
                            //         fontSize: 20.0,
                            //       ),
                            //     ),
                            //   ],
                            // )
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
        strokeWidthPx: 0,
      ),
      behaviors: [
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
    List<TodoCompletion> data = [];
    data.add(new TodoCompletion(
        'Remaining',
        Provider.of<TodoProvider>(context, listen: false)
            .getTasksByLevel(TodoStatus.onGoing, 'all')
            .length,
        Colors.grey[200]));
    data.add(new TodoCompletion(
        'Completed',
        Provider.of<TodoProvider>(context, listen: false)
            .getTasksByLevel(TodoStatus.finished, 'all')
            .length,
        Colors.green[300]));

    // Provider.of<HomeTabProvider>(context, listen: false)
    //     .projects
    //     .forEach((pro) {
    //   if (Provider.of<TodoProvider>(context, listen: false)
    //           .getTasksByLevel(TodoStatus.finished, pro.id)
    //           .length >
    //       0) {
    //     data.add(new TodoCompletion(
    //         '✔️' + pro.title,
    //         Provider.of<TodoProvider>(context, listen: false)
    //             .getTasksByLevel(TodoStatus.finished, pro.id)
    //             .length,
    //         new Color(pro.color)));
    //   }
    // });
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

class DonutPieChartComppleted extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChartComppleted(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      _createTodoCompletionData(context),
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 15,
        strokeWidthPx: 0,
      ),
      behaviors: [
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

  factory DonutPieChartComppleted.withSampleData(context) {
    return new DonutPieChartComppleted(
      _createTodoCompletionData(context),
      animate: true,
    );
  }

  static List<charts.Series<TodoCompletion, String>> _createTodoCompletionData(
      context) {
    List<TodoCompletion> data = [];

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
        id: 'completion2',
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
