import 'package:flutter/material.dart';

class SyncStatusScreen extends StatelessWidget {
  static const String routeName = '/sync-status';
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const textDark = Color(0xFF263238);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Connection status
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.cloud_done, color: Colors.green, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Connected',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Last sync: 5 minutes ago',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pending uploads
                    const Text(
                      'Pending Uploads',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image, color: primaryBlue),
                            title: const Text('Scan_2026_02_20.jpg'),
                            subtitle: const Text('Waiting to upload'),
                            trailing: const SizedBox(
                              width: 40,
                              child: LinearProgressIndicator(value: 0.7),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.check_circle, color: Colors.green),
                            title: const Text('Scan_2026_02_19.jpg'),
                            subtitle: const Text('Uploaded successfully'),
                          ),
                        ],
                      ),
                    ),

                    // Offline mode toggle
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Offline Mode',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Work without internet',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Switch(
                              value: false,
                              onChanged: (value) {},
                              activeColor: primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
