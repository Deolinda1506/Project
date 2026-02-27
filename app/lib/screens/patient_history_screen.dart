import 'package:flutter/material.dart';

class PatientHistoryScreen extends StatelessWidget {
  static const String routeName = '/patient-history';
  const PatientHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const textDark = Color(0xFF263238);

    // Mock data
    final scans = [
      {
        'date': '2026-02-20',
        'imt': 0.92,
        'risk': 'High',
        'status': 'Completed',
      },
      {
        'date': '2026-02-13',
        'imt': 0.88,
        'risk': 'Moderate',
        'status': 'Completed',
      },
      {
        'date': '2026-02-06',
        'imt': 0.85,
        'risk': 'Moderate',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient History'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Past Scans & Risk Trends',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  const SizedBox(height: 16),
                  ...scans.map((scan) {
                    final riskColor = scan['risk'] == 'High' ? Colors.red : Colors.orange;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  scan['date'] as String,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: riskColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    scan['risk'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: riskColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'IMT: ${(scan['imt'] as double).toStringAsFixed(2)} mm',
                              style: const TextStyle(fontSize: 14, color: textDark),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
