// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Workshop';

  @override
  String get listPageTitle => 'List';

  @override
  String get journalEntries => 'Journal entries';

  @override
  String get settings => 'Settings';

  @override
  String get landingPageTitle => 'Landing Page';

  @override
  String get landingPageWelcome => 'Welcome to the Landing Page!';

  @override
  String get sampleBeginningTitle => 'A New Beginning';

  @override
  String get sampleBeginningNote => 'Started writing in my journal today.';

  @override
  String get sampleAfternoonTitle => 'A Quiet Afternoon';

  @override
  String get sampleAfternoonNote =>
      'Enjoyed a peaceful walk and some time to reflect.';

  @override
  String get sampleRememberTitle => 'Something to Remember';

  @override
  String get sampleRememberNote =>
      'Small moments can make an ordinary day special.';

  @override
  String get addJournalEntryTooltip => 'Add journal entry';

  @override
  String get editJournalEntryTooltip => 'Edit journal entry';

  @override
  String get deleteJournalEntryTitle => 'Delete journal entry?';

  @override
  String deleteJournalEntryConfirmation(String title) {
    return 'Delete \"$title\"? This cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get sortNameAscending => 'Name (A-Z)';

  @override
  String get sortNameDescending => 'Name (Z-A)';

  @override
  String get sortDateAscending => 'Date (oldest first)';

  @override
  String get sortDateDescending => 'Date (newest first)';

  @override
  String get initialEntriesSaveError =>
      'Could not save the initial journal entries.';

  @override
  String get storedEntriesNotListError =>
      'Stored journal entries are not a list.';

  @override
  String readSavedEntriesError(String details) {
    return 'Could not read saved journal entries: $details';
  }

  @override
  String invalidSavedEntriesError(String details) {
    return 'Saved journal entries have an invalid format: $details';
  }

  @override
  String loadEntriesError(String details) {
    return 'Could not load journal entries: $details';
  }

  @override
  String get preferencesRejectedEntriesError =>
      'The preferences store rejected the journal data.';

  @override
  String saveEntriesError(String details) {
    return 'Could not save journal entries: $details';
  }

  @override
  String get discardChangesTitle => 'Discard changes?';

  @override
  String get discardChangesConfirmation =>
      'Your changes will not be saved. Leave this page?';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get discard => 'Discard';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get cameraPermissionName => 'camera';

  @override
  String get photoLibraryPermissionName => 'photo library';

  @override
  String get permissionRequiredTitle => 'Permission required';

  @override
  String photoPermissionExplanation(String permission) {
    return 'Access to the $permission is needed to add a photo to your journal entry. You can enable it in app settings.';
  }

  @override
  String get openSettings => 'Open settings';

  @override
  String get openAppSettingsError => 'Could not open app settings.';

  @override
  String selectImageError(String details) {
    return 'Could not select an image: $details';
  }

  @override
  String saveImageError(String details) {
    return 'Could not save the selected image: $details';
  }

  @override
  String get missingTitleError =>
      'Title is missing. Please enter a title before saving.';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get title => 'Title';

  @override
  String get titleRequiredError => 'Please enter a title';

  @override
  String get optionalNote => 'Note (optional)';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get selectedImageUnavailable => 'Selected image is unavailable.';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionTraditionalChinese => 'Traditional Chinese';

  @override
  String languagePreferenceSaveError(String details) {
    return 'Could not save the language preference: $details';
  }

  @override
  String get languagePreferenceSaveRejected =>
      'The language preference could not be saved.';

  @override
  String languagePreferenceLoadError(String details) {
    return 'Could not load the language preference: $details';
  }

  @override
  String createdOnDate(String date) {
    return 'Created on $date';
  }

  @override
  String get localStorageSizeTitle => 'Local storage';

  @override
  String localStorageUsage(int size) {
    return '$size KB used';
  }

  @override
  String localStorageSizeLoadError(String details) {
    return 'Could not read local storage size: $details';
  }

  @override
  String get formatClearJournalData => 'Format / Clear';

  @override
  String get clearAllFirstTitle => 'Clear all journal data?';

  @override
  String get clearAllFirstMessage =>
      'This permanently deletes every journal entry and its photos.';

  @override
  String get continueAction => 'Continue';

  @override
  String get clearAllSecondTitle => 'Final confirmation';

  @override
  String get clearAllSecondMessage =>
      'Are you absolutely sure? This cannot be undone.';

  @override
  String get clearAllConfirm => 'Delete everything';

  @override
  String get clearAllSuccess => 'All journal entries and photos were cleared.';

  @override
  String clearAllError(String details) {
    return 'Could not clear journal data: $details';
  }
}
