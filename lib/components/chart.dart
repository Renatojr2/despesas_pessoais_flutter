import 'package:appfinancas/components/chart_bar.dart';
import 'package:appfinancas/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYarn = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYarn) {
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekValue {
    return groupedTransaction.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Flexible(
        fit: FlexFit.tight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransaction.map((tr) {
              return ChartBar(
                label: tr['day'],
                value: tr['value'],
                percente:
                    _weekValue == 0 ? 0 : (tr['value'] as double) / _weekValue,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
