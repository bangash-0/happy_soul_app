import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happy_soul/screens/SplashScreen.dart';
import 'package:happy_soul/screens/articles/Articles.dart';
import 'package:happy_soul/screens/articles/article_display.dart';
import 'package:happy_soul/screens/activities/breating_activity.dart';
import 'package:happy_soul/screens/chatting_screen.dart';
import 'package:happy_soul/screens/comfort_box.dart';
import 'package:happy_soul/screens/email_verification.dart';
import 'package:happy_soul/screens/happy_chunks.dart';
import 'package:happy_soul/screens/journals/journal_display.dart';
import 'package:happy_soul/screens/journals/journal_list.dart';
import 'package:happy_soul/screens/psychiatrist_data/meeting_request_screen.dart';
import 'package:happy_soul/screens/psychiatrist_data/patient_report.dart';
import 'package:happy_soul/screens/psychiatrist_data/psychiatrist_screen.dart';
import 'package:happy_soul/screens/quotes/quote_display.dart';
import 'package:happy_soul/screens/quotes/quotes_categories.dart';
import 'package:happy_soul/screens/quotes/quotes_list.dart';
import 'package:happy_soul/screens/resetPasswordScreen.dart';
import 'package:happy_soul/screens/services/firebase_msg_api.dart';
import 'package:happy_soul/screens/tracking/weekly_tracking.dart';
import 'package:happy_soul/screens/login_screen.dart';
import 'package:happy_soul/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:happy_soul/screens/journals/write_journal.dart';
import 'firebase_options.dart';
import 'screens/Shorts/home_page.dart';
import 'screens/harmony/home/screens/home.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();

  runApp(const ProviderScope(child: FlashChat()));
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false,

      // home: ShortsScreen(),
      navigatorKey: navigatorKey,

      initialRoute: SplashScreen.id,

      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        EmailVerification.routeName: (context) => const EmailVerification(),
        ChattingScreen.id: (context) => const ChattingScreen(),
        PsychiatristScreen.id: (context) => const PsychiatristScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ResetPaswordScreen.id: (context) => const ResetPaswordScreen(),
        BreathingActivity.id: (context) => const BreathingActivity(),
        QuotesCategories.id: (context) => QuotesCategories(),
        ComfortBox.id: (context) => const ComfortBox(),
        HappyChunksMenu.id: (context) => HappyChunksMenu(),
        QuotesList.id: (context) => const QuotesList(),
        QuoteDisplay.id: (context) => QuoteDisplay(),
        Articles.id: (context) => const Articles(),
        Article_Display.id: (context) => const Article_Display(),
        JournalList.id: (context) => const JournalList(),
        JournalWrittingScreen.id: (context) => const JournalWrittingScreen(),
        JournalDisplayScreen.id: (context) => const JournalDisplayScreen(),
        HarmonyHomeScreen.id: (context) => const HarmonyHomeScreen(),
        WeeklyReport.id: (context) => const WeeklyReport(),
        ShortsScreen.id: (context) => ShortsScreen(),
        meetingRequest.id: (context) => const meetingRequest(),
        PatientReport.id: (context) => const PatientReport(),
      },
    );
  }
}