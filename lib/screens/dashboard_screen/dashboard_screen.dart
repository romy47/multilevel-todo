import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_attempt/helpers/todo_helper.dart';
import 'package:second_attempt/models/todo_model.dart';
import 'package:second_attempt/providers/home_tab_provider.dart';
import 'package:second_attempt/providers/todo_provider.dart';
import 'package:second_attempt/services/database_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int finishedTodoCount = 0;
  int onGoingTodoCount = 0;
  int percentage = 0;
  int todayBonus = 0;
  @override
  Widget build(BuildContext context) {
    onGoingTodoCount = TodoHelper.getTasksByLevel(
            Provider.of<List<Todo>>(context, listen: false),
            TodoStatus.onGoing,
            'all')
        .length;
    finishedTodoCount = TodoHelper.getTasksByLevel(
            Provider.of<List<Todo>>(context, listen: false),
            TodoStatus.finished,
            'all')
        .length;
    todayBonus = TodoHelper.getBonusTaskCount(TodoHelper.getTasksByLevel(
        Provider.of<List<Todo>>(context, listen: false),
        TodoStatus.finished,
        'all'));
    if (onGoingTodoCount + finishedTodoCount != 0) {
      percentage =
          ((finishedTodoCount / (onGoingTodoCount + finishedTodoCount)) * 100)
              .floor();
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Dashboard')),
      // ),
      body: Container(
        // scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            // Container
            children: [
              Card(
                // elevation: 7,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Container(
                        //         child: Text('Today',
                        //             style: TextStyle(fontSize: 17.0)))),
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
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Future Tasks ',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              finishedTodoCount.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 7.0),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey[300],
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Overdue Tasks ',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              finishedTodoCount.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.only(bottom: 7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Today's Bonus",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 100.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                color: todayBonus > 0
                                                    ? Colors.amber
                                                    : Colors.grey,
                                                size: 100.0,
                                              ),
                                              Text(
                                                todayBonus.toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
              // Card(
              //   elevation: 7,
              //   child: Padding(
              //       padding: EdgeInsets.all(16.0),
              //       child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Container(
              //                 margin: EdgeInsets.only(bottom: 8),
              //                 child: Text('Streaks',
              //                     style: TextStyle(fontSize: 17.0))),
              //             getStreakRow('No Overdue', 10, 5),
              //             getStreakRow('Daily Tasker', 10, 5),
              //             getStreakRow('Daily Planner', 10, 5),
              //             getStreakRow('Bonus Tasker', 10, 5),
              //           ])
              //       // child: Text('Streaks', style: TextStyle(fontSize: 17.0)),
              //       ),
              // ),
              Card(
                  // elevation: 7,
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child:
                          // Expanded(
                          //     child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Text('Last Week',
                                    style: TextStyle(fontSize: 17.0))),
                            Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Icon(Icons.cancel),
                                    // Icon(Icons.check),
                                    // Opacity(
                                    //     opacity: 0.0, child: Icon(Icons.check)),
                                    // Icon(Icons.check),
                                    // Icon(Icons.check),
                                    // Icon(Icons.star),
                                    // Opacity(
                                    //     opacity: 0.0, child: Icon(Icons.check)),
                                    Consumer<TodoProvider>(
                                      builder: (context, todoProvider, _) =>
                                          BarChartWidget(
                                              todoProvider: todoProvider),
                                    )
                                  ],
                                )),
                            // BarChartWidget()

                            Consumer<TodoProvider>(
                              builder: (context, todoProvider, _) =>
                                  BarChartWidget(todoProvider: todoProvider),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                    'Bonus tasks can be earned by completeing overdue and future tasks'))
                          ])
                      // )
                      )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStreakRow(String text, int count, int best) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Text(
            count.toString() + ' days',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Text(
            'Best ' + best.toString() + ' days',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  final TodoProvider todoProvider;
  const BarChartWidget({
    @required this.todoProvider,
    Key key,
  }) : super(key: key);
  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  void initState() {
    super.initState();
    // widget.todoProvider.fetchNextTodos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: new DatabaseServices(FirebaseAuth.instance.currentUser.uid)
          .getFinishedTodoListLast7(50), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Todo> todos = snapshot.data.docs.map((doc) {
              return Todo.fromJson(doc.data());
            }).toList();
            print('& day todos recieved ' + todos.toString());

            final List<TodoCompletionPerDay> data = [];
            List<DateTime> days = [];
            days = TodoHelper.getLastSevenDays();
            days.asMap().forEach((index, day) {
              data.add(new TodoCompletionPerDay(
                  (index == days.length - 1)
                      ? 'Today'
                      : DateFormat('EEE').format(day),
                  todos
                      .where(
                          (todo) => TodoHelper.isSameDay(todo.finishedAt, day))
                      .toList()
                      .length,
                  TodoHelper.getBonusTaskCount(todos
                      .where(
                          (todo) => TodoHelper.isSameDay(todo.finishedAt, day))
                      .toList())));
            });

            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: data.map((entry) {
                                Widget w;
                                if (entry.bonusCount > 0) {
                                  w = Icon(Icons.star, color: Colors.amber);
                                } else {
                                  // w = Icon(Icons.star);

                                  w = Opacity(
                                      opacity: 0.0, child: Icon(Icons.star));
                                }
                                return w;
                              }).toList()))),
                  Container(
                      width: double.maxFinite,
                      height: 200,
                      child: FinishedTaskBarChart.withSampleData(todos))
                ]);
          } // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
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
        'Due Today',
        TodoHelper.getTasksByLevel(
                Provider.of<List<Todo>>(context, listen: false),
                TodoStatus.onGoing,
                'all')
            .length,
        Colors.grey[200]));
    data.add(new TodoCompletion(
        'Done Today',
        TodoHelper.getTasksByLevel(
                Provider.of<List<Todo>>(context, listen: false),
                TodoStatus.finished,
                'all')
            .length,
        Colors.green[300]));
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

// class DonutPieChartComppleted extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   DonutPieChartComppleted(this.seriesList, {this.animate});

//   @override
//   Widget build(BuildContext context) {
//     return new charts.PieChart(
//       _createTodoCompletionData(context),
//       animate: animate,
//       defaultRenderer: new charts.ArcRendererConfig(
//         arcWidth: 15,
//         strokeWidthPx: 0,
//       ),
//       behaviors: [
//         new charts.DatumLegend(
//           position: charts.BehaviorPosition.bottom,
//           outsideJustification: charts.OutsideJustification.middleDrawArea,
//           horizontalFirst: false,
//           cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
//           showMeasures: true,
//           desiredMaxColumns: 2,
//           desiredMaxRows: 2,
//           legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
//           measureFormatter: (num value) {
//             return value == null ? '-' : "$value";
//           },
//           entryTextStyle: charts.TextStyleSpec(
//               color: charts.MaterialPalette.black,
//               fontFamily: 'Roboto',
//               fontSize: 16),
//         ),
//       ],
//     );
//   }

//   factory DonutPieChartComppleted.withSampleData(context) {
//     return new DonutPieChartComppleted(
//       _createTodoCompletionData(context),
//       animate: true,
//     );
//   }

//   static List<charts.Series<TodoCompletion, String>> _createTodoCompletionData(
//       context) {
//     List<TodoCompletion> data = [];

//     Provider.of<HomeTabProvider>(context, listen: false)
//         .projects
//         .forEach((pro) {
//       if (Provider.of<TodoProvider>(context, listen: false)
//               .getTasksByLevel(TodoStatus.finished, pro.id)
//               .length >
//           0) {
//         data.add(new TodoCompletion(
//             pro.title,
//             Provider.of<TodoProvider>(context, listen: false)
//                 .getTasksByLevel(TodoStatus.finished, pro.id)
//                 .length,
//             new Color(pro.color)));
//       }
//     });
//     return [
//       new charts.Series<TodoCompletion, String>(
//         id: 'completion2',
//         domainFn: (TodoCompletion todo, _) => todo.category,
//         measureFn: (TodoCompletion todo, _) => todo.amount,
//         data: data,
//         colorFn: (TodoCompletion todo, _) =>
//             charts.ColorUtil.fromDartColor(todo.color),
//         labelAccessorFn: (TodoCompletion todo, _) => '${todo.amount}',
//       )
//     ];
//   }
// }

class TodoCompletion {
  final String category;
  final int amount;
  final Color color;
  TodoCompletion(this.category, this.amount, this.color);
}

class FinishedTaskBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  FinishedTaskBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory FinishedTaskBarChart.withSampleData(List<Todo> todos) {
    return new FinishedTaskBarChart(
      _createSampleData(todos),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TodoCompletionPerDay, String>> _createSampleData(
      List<Todo> todos) {
    final List<TodoCompletionPerDay> data = [
      // new TodoCompletionPerDay('Today', 5),
      // new TodoCompletionPerDay('Mon', 2),
      // new TodoCompletionPerDay('Sun', 0),
      // new TodoCompletionPerDay('Sat', 2),
      // new TodoCompletionPerDay('Fri', 4),
      // new TodoCompletionPerDay('Thu', 6),
      // new TodoCompletionPerDay('Wed', 1),
    ];
    List<DateTime> days = [];
    days = TodoHelper.getLastSevenDays();
    days.asMap().forEach((index, day) {
      data.add(new TodoCompletionPerDay(
          (index == days.length - 1) ? 'Today' : DateFormat('EEE').format(day),
          todos
              .where((todo) => TodoHelper.isSameDay(todo.finishedAt, day))
              .toList()
              .length,
          TodoHelper.getBonusTaskCount(todos
              .where((todo) => TodoHelper.isSameDay(todo.finishedAt, day))
              .toList())));
    });

    return [
      new charts.Series<TodoCompletionPerDay, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TodoCompletionPerDay day, _) => day.day,
          measureFn: (TodoCompletionPerDay day, _) => day.finishedTasks,
          data: data,
          labelAccessorFn: (TodoCompletionPerDay completeTodo, _) =>
              '${completeTodo.finishedTasks.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class TodoCompletionPerDay {
  final String day;
  final int finishedTasks;
  final int bonusCount;

  TodoCompletionPerDay(this.day, this.finishedTasks, this.bonusCount);
}
