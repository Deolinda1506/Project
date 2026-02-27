import 'package:flutter/material.dart';

class HospitalMapScreen extends StatelessWidget {
  static const String routeName = '/hospital-map';
  const HospitalMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const textDark = Color(0xFF263238);

    // Mock hospitals
    final hospitals = [
      {
        'name': 'Gasabo District Hospital',
        'distance': '2.5 km',
        'status': 'Primary Referral',
        'phone': '+250 788 123 456',
      },
      {
        'name': 'Kigali Central Hospital',
        'distance': '8.2 km',
        'status': 'Specialist Center',
        'phone': '+250 788 987 654',
      },
      {
        'name': 'University Teaching Hospital',
        'distance': '12.1 km',
        'status': 'Tertiary',
        'phone': '+250 788 555 555',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Hospitals'),
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
                    'Nearby Hospitals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  const SizedBox(height: 16),
                  ...hospitals.map((hospital) {
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
                                Expanded(
                                  child: Text(
                                    hospital['name'] as String,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(Icons.location_on, color: primaryBlue, size: 20),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Distance: ${hospital['distance']}',
                              style: const TextStyle(fontSize: 14, color: textDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Type: ${hospital['status']}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Calling ${hospital['phone']}')),
                                );
                              },
                              icon: const Icon(Icons.phone),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
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
