import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/scan_bloc.dart';
import 'bloc/scan_event.dart';
import 'bloc/scan_state.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'screens/patient_history_screen.dart';
import 'screens/hospital_map_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/sync_status_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const StrokeLinkApp());
}

class StrokeLinkApp extends StatelessWidget {
  const StrokeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0); // Primary Blue
    const lightBlue = Color(0xFF42A5F5); // Light Blue
    const background = Color(0xFFF5F7FA); // Background
    const textDark = Color(0xFF263238); // Text Dark

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ScanBloc()),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
      title: 'StrokeLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: lightBlue,
          background: background,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textDark),
          bodyMedium: TextStyle(color: textDark),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textDark,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        DashboardScreen.routeName: (_) => const DashboardScreen(),
        ScanCaptureScreen.routeName: (_) => const ScanCaptureScreen(),
        AnalysisScreen.routeName: (_) => const AnalysisScreen(),
        TriageResultsScreen.routeName: (_) => const TriageResultsScreen(),
        ReferralScreen.routeName: (_) => const ReferralScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        PatientHistoryScreen.routeName: (_) => const PatientHistoryScreen(),
        HospitalMapScreen.routeName: (_) => const HospitalMapScreen(),
        NotificationsScreen.routeName: (_) => const NotificationsScreen(),
        SyncStatusScreen.routeName: (_) => const SyncStatusScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
    ),
    );
  }
}

/// Simple horizontal stepper used on the clinical flow screens
class StrokeStepHeader extends StatelessWidget {
  final int currentStep; // 1–5
  const StrokeStepHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const background = Colors.white;

    final steps = ['Dashboard', 'Scan', 'Analysis', 'Results', 'Referral'];

    final icons = [
      Icons.dashboard_customize_outlined,
      Icons.camera_alt_outlined,
      Icons.analytics_outlined,
      Icons.monitor_heart_outlined,
      Icons.local_hospital_outlined,
    ];

    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final stepNumber = index + 1;
          final isActive = stepNumber == currentStep;
          final isCompleted = stepNumber < currentStep;

          Color circleColor;
          if (isActive || isCompleted) {
            circleColor = primaryBlue;
          } else {
            circleColor = Colors.grey.shade300;
          }

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (stepNumber == currentStep) return;
                switch (stepNumber) {
                  case 1:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      DashboardScreen.routeName,
                      (route) => false,
                    );
                    break;
                  case 2:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ScanCaptureScreen.routeName,
                      ModalRoute.withName(DashboardScreen.routeName),
                    );
                    break;
                  case 3:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AnalysisScreen.routeName,
                      ModalRoute.withName(DashboardScreen.routeName),
                    );
                    break;
                  case 4:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      TriageResultsScreen.routeName,
                      ModalRoute.withName(DashboardScreen.routeName),
                    );
                    break;
                  case 5:
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ReferralScreen.routeName,
                      ModalRoute.withName(DashboardScreen.routeName),
                    );
                    break;
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: circleColor,
                    child: Icon(
                      icons[index],
                      size: 18,
                      color: isActive || isCompleted
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? primaryBlue : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Splash Screen (Logo)
class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.health_and_safety, size: 72, color: primaryBlue),
            const SizedBox(height: 16),
            const Text(
              'StrokeLink',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 0 – Secure Authentication (Login)
class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool useEmailPassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const background = Color(0xFFF5F7FA);
    const textDark = Color(0xFF263238);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
      // Soft gradient background for a calmer, premium feel.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.health_and_safety,
                          size: 40,
                          color: primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'StrokeLink',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Secure Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      useEmailPassword
                          ? 'Healthcare professional sign in.'
                          : 'Sign in with phone number (SMS verification).',
                      style: const TextStyle(color: textDark, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => useEmailPassword = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: useEmailPassword
                                      ? primaryBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Email / Password',
                                  style: TextStyle(
                                    color: useEmailPassword
                                        ? Colors.white
                                        : textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => useEmailPassword = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: !useEmailPassword
                                      ? primaryBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Phone (SMS)',
                                  style: TextStyle(
                                    color: !useEmailPassword
                                        ? Colors.white
                                        : textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            if (useEmailPassword) ...[
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ] else ...[
                              TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone number',
                                  prefixIcon: Icon(Icons.phone_android),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'You will receive an SMS verification code.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            BlocBuilder<AuthBloc, AuthState>(
                              buildWhen: (p, c) => p is AuthLoading || c is AuthLoading,
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            final email = _emailController.text.trim();
                                            final password = _passwordController.text;
                                            if (useEmailPassword) {
                                              context.read<AuthBloc>().add(
                                                    AuthLoginRequested(
                                                      email: email,
                                                      password: password,
                                                    ),
                                                  );
                                            } else {
                                              context.read<AuthBloc>().add(
                                                    AuthPhoneLoginRequested(
                                                      _phoneController.text.trim(),
                                                    ),
                                                  );
                                            }
                                          },
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demo: connects to Firebase Authentication.\n'
                      'Sessions stored with AES-256 encryption in secure storage.',
                      style: TextStyle(fontSize: 12, color: textDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

// Screen 1 – Diagnostic Dashboard (Home)
class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const alertRed = Color(0xFFD32F2F);
    const successGreen = Color(0xFF43A047);
    const textDark = Color(0xFF263238);

    const userName = 'Nurse Marie Uwase';
    const location = 'Kigali District Hospital';

    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Column(
        children: [
          const StrokeStepHeader(currentStep: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textDark,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: textDark,
                          ),
                          SizedBox(width: 4),
                          Text(
                            location,
                            style: TextStyle(fontSize: 12, color: textDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(fontSize: 12, color: textDark),
                    ),
                    Text(
                      'Feb 11, 2026',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'StrokeLink',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Diagnostic Dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionTile(
                                icon: Icons.camera_alt_outlined,
                                label: 'Scan',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ScanCaptureScreen.routeName,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionTile(
                                icon: Icons.image_outlined,
                                label: 'Image',
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final XFile? file = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 90,
                                  );
                                  if (file != null && context.mounted) {
                                    context.read<ScanBloc>().add(
                                          ScanImageSelected(file.path),
                                        );
                                    Navigator.pushNamed(
                                      context,
                                      AnalysisScreen.routeName,
                                    );
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('No image selected.')),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Quick Actions card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0x1FFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'QUICK ACTIONS',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 1,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF43A047),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ScanCaptureScreen.routeName,
                                  );
                                },
                                icon: const Icon(Icons.camera_alt_outlined),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0x1FFFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'QUICK LINKS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 1,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _QuickLinkButton(
                                      icon: Icons.history,
                                      label: 'Patient History',
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        PatientHistoryScreen.routeName,
                                      ),
                                    ),
                                    _QuickLinkButton(
                                      icon: Icons.local_hospital_outlined,
                                      label: 'Hospital Map',
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        HospitalMapScreen.routeName,
                                      ),
                                    ),
                                    _QuickLinkButton(
                                      icon: Icons.notifications_none,
                                      label: 'Notifications',
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        NotificationsScreen.routeName,
                                      ),
                                    ),
                                    _QuickLinkButton(
                                      icon: Icons.sync_outlined,
                                      label: 'Sync Status',
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        SyncStatusScreen.routeName,
                                      ),
                                    ),
                                    _QuickLinkButton(
                                      icon: Icons.settings_outlined,
                                      label: 'Settings',
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        SettingsScreen.routeName,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                label: const Text(
                                  'Start New Scan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final XFile? file = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 90,
                                  );
                                  if (file != null && context.mounted) {
                                    context.read<ScanBloc>().add(
                                          ScanImageSelected(file.path),
                                        );
                                    Navigator.pushNamed(
                                      context,
                                      AnalysisScreen.routeName,
                                    );
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('No image selected.')),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.image_outlined),
                                label: const Text(
                                  'Upload from Gallery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Today's activity card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0x1FFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TODAY\'S ACTIVITY',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 1,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _DashboardStatTile(
                                    value: '24',
                                    label: 'Total Scans',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  _DashboardStatTile(
                                    value: '5',
                                    label: 'High Risk',
                                    color: alertRed,
                                  ),
                                  const SizedBox(width: 8),
                                  _DashboardStatTile(
                                    value: '156',
                                    label: 'This Week',
                                    color: successGreen,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _DashboardStatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickLinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}

// Screen 2 – Real-time Scanning / Image Capture
class ScanCaptureScreen extends StatefulWidget {
  static const routeName = '/scan-capture';
  const ScanCaptureScreen({super.key});

  @override
  State<ScanCaptureScreen> createState() => _ScanCaptureScreenState();
}

class _ScanCaptureScreenState extends State<ScanCaptureScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureAndAnalyze() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (!mounted) return;
    if (file != null) {
      context.read<ScanBloc>().add(ScanImageSelected(file.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Frame captured. Running Edge-AI analysis...'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pushNamed(context, AnalysisScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image captured.')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (!mounted) return;
    if (file != null) {
      context.read<ScanBloc>().add(ScanImageSelected(file.path));
      Navigator.pushNamed(context, AnalysisScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const textDark = Color(0xFF263238);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const StrokeStepHeader(currentStep: 2),
          // Top bar for scan state
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Text(
                    'Live Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Live feed area
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const Text(
                      'Ultrasound Feed',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                // Green “Artery detected” pill
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Artery detected. Hold still...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Guidance frame
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 260,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.greenAccent, width: 3),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.white,
                            size: 26,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Align Common Carotid Artery',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Center the artery in the frame',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Capture button
          Padding(
            padding: const EdgeInsets.only(bottom: 32, top: 12),
            child: GestureDetector(
              onTap: _captureAndAnalyze,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: const BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              width: 220,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('Upload Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 3 – AI Analysis (Processing)
class AnalysisScreen extends StatelessWidget {
  static const routeName = '/analysis';
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBloc, ScanState>(
      buildWhen: (prev, curr) => prev.imagePath != curr.imagePath,
      builder: (context, scanState) {
        final imagePath = scanState.imagePath;
    const primaryBlue = Color(0xFF1565C0);
    const background = Color(0xFFF5F7FA);
    const textDark = Color(0xFF263238);

    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          const StrokeStepHeader(currentStep: 3),
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'AI Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: imagePath != null && File(imagePath).existsSync()
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.contain,
                          )
                        : const Text(
                            'Captured Frame',
                            style: TextStyle(color: Colors.white70),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Running Edge-AI Analysis (INT8 Optimized)...',
                    style: TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.white,
                    color: primaryBlue,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SwinUNETR model running locally on-device.\n'
                    'When backend is connected, IMT will be computed here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: textDark),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          TriageResultsScreen.routeName,
                        );
                      },
                      child: const Text(
                        'View Analysis Results',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

// Screen 4 – Triage Results & Quantification
class TriageResultsScreen extends StatelessWidget {
  static const routeName = '/triage-results';
  const TriageResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBloc, ScanState>(
      builder: (context, scanState) {
        final imagePath = scanState.imagePath;
        final imtMm = scanState.imtMm ?? 1.28;
        final isHighRisk = scanState.isHighRisk ?? true;
    const primaryBlue = Color(0xFF1565C0);
    const alertRed = Color(0xFFD32F2F);
    const background = Color(0xFFF5F7FA);
    const textDark = Color(0xFF263238);

    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          const StrokeStepHeader(currentStep: 4),
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Analysis Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            alignment: Alignment.center,
                            child: imagePath != null && File(imagePath).existsSync()
                                ? Image.file(
                                    File(imagePath),
                                    fit: BoxFit.contain,
                                  )
                                : const Text(
                                    'Scan + Segmentation Mask',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'AI Analyzed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'INTIMA-MEDIA THICKNESS',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  imtMm.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    'mm',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isHighRisk ? 'MEDIUM RISK' : 'LOW RISK',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            const Text(
                              'SCAN INFORMATION',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const _SummaryRow(
                              label: 'Patient ID',
                              value: 'PT4395',
                            ),
                            const _SummaryRow(
                              label: 'Scan Time',
                              value: '06:22 PM',
                            ),
                            const _SummaryRow(
                              label: 'Location',
                              value: 'Kigali District Hospital',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43A047),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ReferralScreen.routeName);
                      },
                      child: const Text(
                        'Confirm & Notify Hospital',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        context.read<ScanBloc>().add(ScanCleared());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ScanCaptureScreen.routeName,
                          ModalRoute.withName(DashboardScreen.routeName),
                        );
                      },
                      child: const Text('Re-scan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

// Screen 5 – Automated Referral / API UI
class ReferralScreen extends StatelessWidget {
  static const routeName = '/referral';
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const background = Color(0xFFF5F7FA);
    const textDark = Color(0xFF263238);

    const patientId = 'PT4395';
    const imtValue = 1.28;
    const gps = '−1.9536°, 30.0606°';

    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          const StrokeStepHeader(currentStep: 5),
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Referral Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF43A047),
                      size: 72,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Referral Sent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Successfully submitted to Neurology Department',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textDark, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'REFERRAL DETAILS',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            SizedBox(height: 12),
                            _SummaryRow(label: 'Patient ID', value: patientId),
                            _SummaryRow(
                              label: 'IMT Measurement',
                              value: '$imtValue mm • MEDIUM RISK',
                            ),
                            _SummaryRow(
                              label: 'GPS Location',
                              value: 'Kigali District Hospital\n$gps',
                            ),
                            _SummaryRow(
                              label: 'Timestamp',
                              value: 'Feb 11, 2026, 6:22 PM',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'Next Steps for Health Worker\n\n'
                        'Please advise the patient to visit the hospital within '
                        '48 hours for comprehensive cardiovascular assessment and '
                        'consultation with a neurologist.',
                        style: TextStyle(color: textDark, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            DashboardScreen.routeName,
                            (_) => false,
                          );
                        },
                        child: const Text('Back to Dashboard'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 6 – User Profile & Settings
class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1565C0);
    const background = Color(0xFFF5F7FA);
    const successGreen = Color(0xFF43A047);
    const textDark = Color(0xFF263238);

    const userId = 'USR-2031';
    const role = 'CHW / Nurse';
    const healthCenter = 'Kigali District';

    final recentScans = [
      {'id': 'SCAN-1021', 'imt': '1.18 mm', 'risk': 'High', 'date': 'Today'},
      {
        'id': 'SCAN-1019',
        'imt': '0.92 mm',
        'risk': 'Normal',
        'date': 'Yesterday',
      },
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nurse Marie Uwase',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Text('StrokeLink User', style: TextStyle(color: textDark)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Identity Details',
              style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(label: 'User ID', value: userId),
                    _SummaryRow(label: 'Role', value: role),
                    _SummaryRow(
                      label: 'Assigned Health Center',
                      value: healthCenter,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Scans (linked to userID)',
              style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: recentScans.map((scan) {
                  final isHigh = scan['risk'] == 'High';
                  return ListTile(
                    leading: Icon(
                      Icons.medical_information_outlined,
                      color: isHigh ? Colors.red : successGreen,
                    ),
                    title: Text(
                      scan['id']!,
                      style: const TextStyle(color: textDark),
                    ),
                    subtitle: Text(
                      'IMT: ${scan['imt']} • Risk: ${scan['risk']} • ${scan['date']}',
                      style: const TextStyle(fontSize: 12, color: textDark),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Security Settings',
              style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset_outlined),
                    title: const Text('Update Credentials'),
                    subtitle: const Text(
                      'Change password or phone-based login.',
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Local Database Encryption'),
                    subtitle: const Text(
                      'Status: AES-256 encryption enabled for cached scans.',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.verified_user,
                      color: successGreen,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF263238);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: textDark)),
          ),
        ],
      ),
    );
  }
}
