import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key? key}) : super(key: key);

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consentGiven = false;

  Future<void> _acceptConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('consent_given', true);
    await prefs.setString('consent_date', DateTime.now().toIso8601String());
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Consent'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'StrokeLink Research Study',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Supervised Undergraduate Project\nUniversity of Strathclyde, 2026',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              'Purpose of the Study',
              'This app is part of a research study to evaluate the use of AI-assisted '
              'ultrasound analysis for stroke risk assessment in Rwanda. The app uses '
              'machine learning to analyze carotid artery ultrasound images and estimate '
              'Intima-Media Thickness (IMT).',
            ),
            
            _buildSection(
              'What Data We Collect',
              '• Patient identifiers (anonymized)\n'
              '• Ultrasound images\n'
              '• IMT measurements\n'
              '• Healthcare facility information\n'
              '• No personally identifiable information (names, addresses) is stored.',
            ),
            
            _buildSection(
              'How We Use Your Data',
              '• To provide IMT analysis and stroke risk assessment\n'
              '• To improve the machine learning model\n'
              '• For research publication (anonymized data only)',
            ),
            
            _buildSection(
              'Data Protection (Rwanda DPA Law N°058/2021)',
              '• All data is encrypted and stored securely\n'
              '• You can access, correct, or delete your data at any time\n'
              '• You can export your data in portable format\n'
              '• Data will be retained for 1 year, then permanently deleted\n'
              '• You can withdraw from the study up to 30 days after data collection',
            ),
            
            _buildSection(
              'AI Model Limitations',
              '• The AI model is a research tool, not a diagnostic device\n'
              '• Results should be verified by qualified medical professionals\n'
              '• Model may have reduced accuracy on certain populations\n'
              '• Not a substitute for clinical judgment',
            ),
            
            _buildSection(
              'Your Rights',
              '• You can withdraw consent at any time\n'
              '• You can request deletion of your data (Settings > Delete Account)\n'
              '• You can export your data (Settings > Export Data)\n'
              '• Withdrawal deadline: 30 days after data collection',
            ),
            
            _buildSection(
              'Contact Information',
              'Supervisor: [Supervisor Name]\n'
              'Email: [supervisor@strath.ac.uk]\n\n'
              'Student Researcher: [Your Name]\n'
              'Email: [your.email@strath.ac.uk]',
            ),
            
            const SizedBox(height: 24),
            
            CheckboxListTile(
              value: _consentGiven,
              onChanged: (value) => setState(() => _consentGiven = value ?? false),
              title: const Text(
                'I have read and understood the information above. '
                'I voluntarily consent to participate in this research study.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _consentGiven ? _acceptConsent : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Accept and Continue'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Exit app or show decline message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Consent Required'),
                      content: const Text(
                        'You must provide consent to use this research application.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Decline'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
