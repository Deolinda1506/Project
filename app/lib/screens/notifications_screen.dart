import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const textDark = Color(0xFF263238);

    // Mock notifications
    final notifications = [
      {
        'title': 'High-Risk Alert',
        'message': 'Patient scan shows IMT ≥ 0.9 mm. Immediate referral recommended.',
        'timestamp': '2 hours ago',
        'type': 'alert',
      },
      {
        'title': 'Data Synced',
        'message': 'Patient history uploaded to Gasabo District Hospital.',
        'timestamp': '1 day ago',
        'type': 'success',
      },
      {
        'title': 'Referral Accepted',
        'message': 'Hospital received referral and created appointment.',
        'timestamp': '2 days ago',
        'type': 'info',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
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
                  ...notifications.map((notif) {
                    final iconColor = notif['type'] == 'alert'
                        ? Colors.red
                        : notif['type'] == 'success'
                            ? Colors.green
                            : Colors.blue;
                    final icon = notif['type'] == 'alert'
                        ? Icons.warning
                        : notif['type'] == 'success'
                            ? Icons.check_circle
                            : Icons.info;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, color: iconColor, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif['title'] as String,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif['message'] as String,
                                    style: const TextStyle(fontSize: 14, color: textDark),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notif['timestamp'] as String,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
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
