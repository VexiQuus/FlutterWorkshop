import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Workshop'**
  String get appTitle;

  /// No description provided for @listPageTitle.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listPageTitle;

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal entries'**
  String get journalEntries;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @landingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Landing Page'**
  String get landingPageTitle;

  /// No description provided for @landingPageWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Landing Page!'**
  String get landingPageWelcome;

  /// No description provided for @sampleBeginningTitle.
  ///
  /// In en, this message translates to:
  /// **'A New Beginning'**
  String get sampleBeginningTitle;

  /// No description provided for @sampleBeginningNote.
  ///
  /// In en, this message translates to:
  /// **'Started writing in my journal today.'**
  String get sampleBeginningNote;

  /// No description provided for @sampleAfternoonTitle.
  ///
  /// In en, this message translates to:
  /// **'A Quiet Afternoon'**
  String get sampleAfternoonTitle;

  /// No description provided for @sampleAfternoonNote.
  ///
  /// In en, this message translates to:
  /// **'Enjoyed a peaceful walk and some time to reflect.'**
  String get sampleAfternoonNote;

  /// No description provided for @sampleRememberTitle.
  ///
  /// In en, this message translates to:
  /// **'Something to Remember'**
  String get sampleRememberTitle;

  /// No description provided for @sampleRememberNote.
  ///
  /// In en, this message translates to:
  /// **'Small moments can make an ordinary day special.'**
  String get sampleRememberNote;

  /// No description provided for @addJournalEntryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add journal entry'**
  String get addJournalEntryTooltip;

  /// No description provided for @editJournalEntryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit journal entry'**
  String get editJournalEntryTooltip;

  /// No description provided for @deleteJournalEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete journal entry?'**
  String get deleteJournalEntryTitle;

  /// No description provided for @deleteJournalEntryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String deleteJournalEntryConfirmation(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sortNameAscending.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAscending;

  /// No description provided for @sortNameDescending.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortNameDescending;

  /// No description provided for @sortDateAscending.
  ///
  /// In en, this message translates to:
  /// **'Date (oldest first)'**
  String get sortDateAscending;

  /// No description provided for @sortDateDescending.
  ///
  /// In en, this message translates to:
  /// **'Date (newest first)'**
  String get sortDateDescending;

  /// No description provided for @initialEntriesSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the initial journal entries.'**
  String get initialEntriesSaveError;

  /// No description provided for @storedEntriesNotListError.
  ///
  /// In en, this message translates to:
  /// **'Stored journal entries are not a list.'**
  String get storedEntriesNotListError;

  /// No description provided for @readSavedEntriesError.
  ///
  /// In en, this message translates to:
  /// **'Could not read saved journal entries: {details}'**
  String readSavedEntriesError(String details);

  /// No description provided for @invalidSavedEntriesError.
  ///
  /// In en, this message translates to:
  /// **'Saved journal entries have an invalid format: {details}'**
  String invalidSavedEntriesError(String details);

  /// No description provided for @loadEntriesError.
  ///
  /// In en, this message translates to:
  /// **'Could not load journal entries: {details}'**
  String loadEntriesError(String details);

  /// No description provided for @preferencesRejectedEntriesError.
  ///
  /// In en, this message translates to:
  /// **'The preferences store rejected the journal data.'**
  String get preferencesRejectedEntriesError;

  /// No description provided for @saveEntriesError.
  ///
  /// In en, this message translates to:
  /// **'Could not save journal entries: {details}'**
  String saveEntriesError(String details);

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Your changes will not be saved. Leave this page?'**
  String get discardChangesConfirmation;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @cameraPermissionName.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get cameraPermissionName;

  /// No description provided for @photoLibraryPermissionName.
  ///
  /// In en, this message translates to:
  /// **'photo library'**
  String get photoLibraryPermissionName;

  /// No description provided for @permissionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionRequiredTitle;

  /// No description provided for @photoPermissionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Access to the {permission} is needed to add a photo to your journal entry. You can enable it in app settings.'**
  String photoPermissionExplanation(String permission);

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @openAppSettingsError.
  ///
  /// In en, this message translates to:
  /// **'Could not open app settings.'**
  String get openAppSettingsError;

  /// No description provided for @selectImageError.
  ///
  /// In en, this message translates to:
  /// **'Could not select an image: {details}'**
  String selectImageError(String details);

  /// No description provided for @saveImageError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the selected image: {details}'**
  String saveImageError(String details);

  /// No description provided for @missingTitleError.
  ///
  /// In en, this message translates to:
  /// **'Title is missing. Please enter a title before saving.'**
  String get missingTitleError;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get titleRequiredError;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get optionalNote;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @selectedImageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Selected image is unavailable.'**
  String get selectedImageUnavailable;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingTitle;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageOptionTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get languageOptionTraditionalChinese;

  /// No description provided for @languagePreferenceSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the language preference: {details}'**
  String languagePreferenceSaveError(String details);

  /// No description provided for @languagePreferenceSaveRejected.
  ///
  /// In en, this message translates to:
  /// **'The language preference could not be saved.'**
  String get languagePreferenceSaveRejected;

  /// No description provided for @languagePreferenceLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the language preference: {details}'**
  String languagePreferenceLoadError(String details);
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
