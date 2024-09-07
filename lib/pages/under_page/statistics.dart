import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> _fetchUserStatistics() async {
    final usersSnapshot = await _firestore.collection('users').get();
    final users = usersSnapshot.docs.map((doc) => doc.data()).toList();
    final stats = {'Apprenant': 0, 'Formateur': 0, 'Administrateur': 0};

    for (var user in users) {
      final role = user['role'];
      if (stats.containsKey(role)) {
        stats[role] = stats[role]! + 1;
      }
    }
    return stats;
  }

  Future<Map<String, int>> _fetchTicketStatistics() async {
    final ticketsSnapshot = await _firestore.collection('tickets').get();
    final tickets = ticketsSnapshot.docs.map((doc) => doc.data()).toList();
    final stats = {'Total': 0, 'Résolu': 0, 'Attente': 0};

    for (var ticket in tickets) {
      final etat = ticket['etat'];
      stats['Total'] = stats['Total']! + 1;
      if (etat == 'Résolu') {
        stats['Résolu'] = stats['Résolu']! + 1;
      } else if (etat == 'Attente') {
        stats['Attente'] = stats['Attente']! + 1;
      }
    }
    return stats;
  }

  Future<Map<String, int>> _fetchReponseStatistics(String ticketId) async {
    final reponsesSnapshot = await _firestore
        .collection('tickets')
        .doc(ticketId)
        .collection('reponses')
        .get();
    final reponses = reponsesSnapshot.docs.map((doc) => doc.data()).toList();
    final formateurStats = <String, int>{};

    for (var response in reponses) {
      final formateur = response['formateurId'];
      if (formateurStats.containsKey(formateur)) {
        formateurStats[formateur] = formateurStats[formateur]! + 1;
      } else {
        formateurStats[formateur] = 1;
      }
    }
    return formateurStats;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 251, 238),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFBEE),
          title: const Text('Statistiques'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Utilisateurs'),
              Tab(text: 'Tickets'),
              Tab(text: 'Réponses'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserStatistics(),
            _buildTicketStatistics(),
            _buildreponsestatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatistics() {
    return FutureBuilder<Map<String, int>>(
      future: _fetchUserStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final stats = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                _buildBarGroup(
                    0, stats['Apprenant']?.toDouble() ?? 0, Colors.blue),
                _buildBarGroup(
                    1, stats['Formateur']?.toDouble() ?? 0, Colors.green),
                _buildBarGroup(
                    2, stats['Administrateur']?.toDouble() ?? 0, Colors.red),
              ],
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Apprenant');
                        case 1:
                          return const Text('Formateur');
                        case 2:
                          return const Text('Administrateur');
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicketStatistics() {
    return FutureBuilder<Map<String, int>>(
      future: _fetchTicketStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final stats = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, stats['Total']?.toDouble() ?? 0),
                    FlSpot(1, stats['Résolu']?.toDouble() ?? 0),
                    FlSpot(2, stats['Attente']?.toDouble() ?? 0),
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildreponsestatistics() {
    return FutureBuilder<Map<String, int>>(
      future: _fetchTicketStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final formateurStats = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: formateurStats.entries
                  .map((entry) => _buildBarGroup(
                      formateurStats.keys.toList().indexOf(entry.key),
                      entry.value.toDouble(),
                      const Color.fromARGB(255, 255, 192, 34)))
                  .toList(),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(formateurStats.keys.elementAt(value.toInt()));
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 15,
        ),
      ],
    );
  }
}
