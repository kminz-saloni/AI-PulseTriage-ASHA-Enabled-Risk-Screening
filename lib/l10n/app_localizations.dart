import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Asha Triage'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabPatients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get tabPatients;

  /// No description provided for @tabReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get tabReferrals;

  /// No description provided for @tabTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tabTasks;

  /// No description provided for @tabIncentives.
  ///
  /// In en, this message translates to:
  /// **'Incentives'**
  String get tabIncentives;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTitle;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @emergencyPanel.
  ///
  /// In en, this message translates to:
  /// **'Active Emergencies'**
  String get emergencyPanel;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @newVisit.
  ///
  /// In en, this message translates to:
  /// **'New Visit'**
  String get newVisit;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlert;

  /// No description provided for @searchPatient.
  ///
  /// In en, this message translates to:
  /// **'Search Patient'**
  String get searchPatient;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get lastSync;

  /// No description provided for @pendingUploads.
  ///
  /// In en, this message translates to:
  /// **'Pending uploads'**
  String get pendingUploads;

  /// No description provided for @patientList.
  ///
  /// In en, this message translates to:
  /// **'Patient List'**
  String get patientList;

  /// No description provided for @patientDetails.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientDetails;

  /// No description provided for @demographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get demographics;

  /// No description provided for @visitTimeline.
  ///
  /// In en, this message translates to:
  /// **'Visit Timeline'**
  String get visitTimeline;

  /// No description provided for @riskTrend.
  ///
  /// In en, this message translates to:
  /// **'Risk Trend'**
  String get riskTrend;

  /// No description provided for @startNewVisit.
  ///
  /// In en, this message translates to:
  /// **'Start New Visit'**
  String get startNewVisit;

  /// No description provided for @createEmergency.
  ///
  /// In en, this message translates to:
  /// **'Create Emergency'**
  String get createEmergency;

  /// No description provided for @viewReferrals.
  ///
  /// In en, this message translates to:
  /// **'View Referrals'**
  String get viewReferrals;

  /// No description provided for @referralTracker.
  ///
  /// In en, this message translates to:
  /// **'Referral Tracker'**
  String get referralTracker;

  /// No description provided for @referralOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get referralOpen;

  /// No description provided for @referralPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get referralPartial;

  /// No description provided for @referralCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get referralCompleted;

  /// No description provided for @referralHospitalIssue.
  ///
  /// In en, this message translates to:
  /// **'Hospital Issue'**
  String get referralHospitalIssue;

  /// No description provided for @referralOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get referralOther;

  /// No description provided for @markPatientInformed.
  ///
  /// In en, this message translates to:
  /// **'Mark Patient Informed'**
  String get markPatientInformed;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @markTransportIssue.
  ///
  /// In en, this message translates to:
  /// **'Mark Transport Issue'**
  String get markTransportIssue;

  /// No description provided for @urgency.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgency;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdDate;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @phcOutcome.
  ///
  /// In en, this message translates to:
  /// **'PHC Outcome'**
  String get phcOutcome;

  /// No description provided for @taskList.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get taskList;

  /// No description provided for @taskOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get taskOpen;

  /// No description provided for @taskDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskDone;

  /// No description provided for @taskBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get taskBlocked;

  /// No description provided for @quickComplete.
  ///
  /// In en, this message translates to:
  /// **'Quick Complete'**
  String get quickComplete;

  /// No description provided for @taskFollowUpVisit.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Visit'**
  String get taskFollowUpVisit;

  /// No description provided for @taskAdherenceCheck.
  ///
  /// In en, this message translates to:
  /// **'Adherence Check'**
  String get taskAdherenceCheck;

  /// No description provided for @taskPhcReminder.
  ///
  /// In en, this message translates to:
  /// **'PHC Reminder'**
  String get taskPhcReminder;

  /// No description provided for @taskEmergencyFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Emergency Follow-up'**
  String get taskEmergencyFollowUp;

  /// No description provided for @incentiveTracker.
  ///
  /// In en, this message translates to:
  /// **'Incentive Tracker'**
  String get incentiveTracker;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// No description provided for @incentiveEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get incentiveEligible;

  /// No description provided for @incentivePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get incentivePending;

  /// No description provided for @incentiveApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get incentiveApproved;

  /// No description provided for @incentivePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get incentivePaid;

  /// No description provided for @newVisitWizard.
  ///
  /// In en, this message translates to:
  /// **'New Visit'**
  String get newVisitWizard;

  /// No description provided for @stepVitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get stepVitals;

  /// No description provided for @stepSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get stepSymptoms;

  /// No description provided for @stepAdherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get stepAdherence;

  /// No description provided for @stepAiResult.
  ///
  /// In en, this message translates to:
  /// **'AI Result'**
  String get stepAiResult;

  /// No description provided for @stepConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get stepConfirmation;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @chestPain.
  ///
  /// In en, this message translates to:
  /// **'Chest Pain'**
  String get chestPain;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @breathlessness.
  ///
  /// In en, this message translates to:
  /// **'Breathlessness'**
  String get breathlessness;

  /// No description provided for @cough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get cough;

  /// No description provided for @fever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get fever;

  /// No description provided for @weightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get weightLoss;

  /// No description provided for @polyuria.
  ///
  /// In en, this message translates to:
  /// **'Polyuria'**
  String get polyuria;

  /// No description provided for @polydipsia.
  ///
  /// In en, this message translates to:
  /// **'Polydipsia'**
  String get polydipsia;

  /// No description provided for @adherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get adherence;

  /// No description provided for @missedDoses.
  ///
  /// In en, this message translates to:
  /// **'Missed Doses'**
  String get missedDoses;

  /// No description provided for @riskAssessment.
  ///
  /// In en, this message translates to:
  /// **'Risk Assessment'**
  String get riskAssessment;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @reasons.
  ///
  /// In en, this message translates to:
  /// **'Reasons'**
  String get reasons;

  /// No description provided for @recommendedAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended Action'**
  String get recommendedAction;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @emergencyCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Emergency'**
  String get emergencyCreate;

  /// No description provided for @emergencyList.
  ///
  /// In en, this message translates to:
  /// **'Emergency List'**
  String get emergencyList;

  /// No description provided for @emergencyType.
  ///
  /// In en, this message translates to:
  /// **'Emergency Type'**
  String get emergencyType;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumPriority;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowPriority;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @manualSync.
  ///
  /// In en, this message translates to:
  /// **'Manual Sync'**
  String get manualSync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @riskGreen.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get riskGreen;

  /// No description provided for @riskYellow.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get riskYellow;

  /// No description provided for @riskRed.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get riskRed;

  /// No description provided for @emptyTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks available'**
  String get emptyTasks;

  /// No description provided for @emptyPatients.
  ///
  /// In en, this message translates to:
  /// **'No patients found'**
  String get emptyPatients;

  /// No description provided for @emptyReferrals.
  ///
  /// In en, this message translates to:
  /// **'No referrals found'**
  String get emptyReferrals;

  /// No description provided for @emptyIncentives.
  ///
  /// In en, this message translates to:
  /// **'No incentive entries'**
  String get emptyIncentives;

  /// No description provided for @emptyEmergencies.
  ///
  /// In en, this message translates to:
  /// **'No active emergencies'**
  String get emptyEmergencies;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoading;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving data'**
  String get errorSaving;

  /// No description provided for @errorSync.
  ///
  /// In en, this message translates to:
  /// **'Error syncing data'**
  String get errorSync;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @otherSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Other Symptoms'**
  String get otherSymptoms;

  /// No description provided for @otherSymptomsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any other symptoms...'**
  String get otherSymptomsHint;

  /// No description provided for @patientHistory.
  ///
  /// In en, this message translates to:
  /// **'Patient History'**
  String get patientHistory;

  /// No description provided for @patientHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter patient medical history...'**
  String get patientHistoryHint;

  /// No description provided for @familyHistory.
  ///
  /// In en, this message translates to:
  /// **'Family History'**
  String get familyHistory;

  /// No description provided for @familyHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter family medical history...'**
  String get familyHistoryHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'ASHA Worker Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials'**
  String get loginSubtitle;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials'**
  String get demoCredentials;

  /// No description provided for @demoUsername.
  ///
  /// In en, this message translates to:
  /// **'Demo Username: demo_asha'**
  String get demoUsername;

  /// No description provided for @demoPassword.
  ///
  /// In en, this message translates to:
  /// **'Demo Password: demo123'**
  String get demoPassword;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidCredentials;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
