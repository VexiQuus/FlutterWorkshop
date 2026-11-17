// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter 工作坊';

  @override
  String get listPageTitle => '日記列表';

  @override
  String get journalEntries => '日記';

  @override
  String get settings => '設定';

  @override
  String get landingPageTitle => '首頁';

  @override
  String get landingPageWelcome => '歡迎來到首頁！';

  @override
  String get sampleBeginningTitle => '新的開始';

  @override
  String get sampleBeginningNote => '今天開始寫日記了。';

  @override
  String get sampleAfternoonTitle => '寧靜的午後';

  @override
  String get sampleAfternoonNote => '享受了一段平靜的散步時光，也留些時間沉澱思緒。';

  @override
  String get sampleRememberTitle => '值得記住的事';

  @override
  String get sampleRememberNote => '平凡日子裡的小片刻，也能讓一天變得特別。';

  @override
  String get addJournalEntryTooltip => '新增日記';

  @override
  String get editJournalEntryTooltip => '編輯日記';

  @override
  String get deleteJournalEntryTitle => '要刪除這篇日記嗎？';

  @override
  String deleteJournalEntryConfirmation(String title) {
    return '確定要刪除「$title」嗎？此操作無法復原。';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get retry => '重試';

  @override
  String get sortNameAscending => '名稱（A-Z）';

  @override
  String get sortNameDescending => '名稱（Z-A）';

  @override
  String get sortDateAscending => '日期（最舊優先）';

  @override
  String get sortDateDescending => '日期（最新優先）';

  @override
  String get initialEntriesSaveError => '無法儲存初始日記。';

  @override
  String get storedEntriesNotListError => '儲存的日記資料格式不正確。';

  @override
  String readSavedEntriesError(String details) {
    return '無法讀取已儲存的日記：$details';
  }

  @override
  String invalidSavedEntriesError(String details) {
    return '已儲存的日記格式無效：$details';
  }

  @override
  String loadEntriesError(String details) {
    return '無法載入日記：$details';
  }

  @override
  String get preferencesRejectedEntriesError => '偏好設定儲存區拒絕儲存日記資料。';

  @override
  String saveEntriesError(String details) {
    return '無法儲存日記：$details';
  }

  @override
  String get discardChangesTitle => '要捨棄變更嗎？';

  @override
  String get discardChangesConfirmation => '您的變更將不會儲存。確定要離開此頁面嗎？';

  @override
  String get keepEditing => '繼續編輯';

  @override
  String get discard => '捨棄';

  @override
  String get chooseFromGallery => '從相簿選取';

  @override
  String get takePhoto => '拍攝照片';

  @override
  String get cameraPermissionName => '相機';

  @override
  String get photoLibraryPermissionName => '相片圖庫';

  @override
  String get permissionRequiredTitle => '需要權限';

  @override
  String photoPermissionExplanation(String permission) {
    return '新增照片至日記需要存取$permission。您可以在應用程式設定中啟用權限。';
  }

  @override
  String get openSettings => '開啟設定';

  @override
  String get openAppSettingsError => '無法開啟應用程式設定。';

  @override
  String selectImageError(String details) {
    return '無法選取圖片：$details';
  }

  @override
  String saveImageError(String details) {
    return '無法儲存所選圖片：$details';
  }

  @override
  String get missingTitleError => '尚未輸入標題，請先輸入標題再儲存。';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get title => '標題';

  @override
  String get titleRequiredError => '請輸入標題';

  @override
  String get optionalNote => '內容（選填）';

  @override
  String get addPhoto => '新增照片';

  @override
  String get selectedImageUnavailable => '無法使用所選圖片。';

  @override
  String get save => '儲存';

  @override
  String get saveChanges => '儲存變更';

  @override
  String get languageSettingTitle => '語言';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionTraditionalChinese => '繁體中文';

  @override
  String languagePreferenceSaveError(String details) {
    return '無法儲存語言設定：$details';
  }

  @override
  String get languagePreferenceSaveRejected => '無法儲存語言設定。';

  @override
  String languagePreferenceLoadError(String details) {
    return '無法載入語言設定：$details';
  }

  @override
  String createdOnDate(String date) {
    return '$date 建立';
  }

  @override
  String get localStorageSizeTitle => '本機儲存空間';

  @override
  String localStorageUsage(int size) {
    return '已使用 $size KB';
  }

  @override
  String localStorageSizeLoadError(String details) {
    return '無法讀取本機儲存空間大小：$details';
  }

  @override
  String get formatClearJournalData => '格式化／清除';

  @override
  String get clearAllFirstTitle => '要清除所有日記資料嗎？';

  @override
  String get clearAllFirstMessage => '這會永久刪除所有日記及其照片。';

  @override
  String get continueAction => '繼續';

  @override
  String get clearAllSecondTitle => '再次確認';

  @override
  String get clearAllSecondMessage => '確定要永久刪除嗎？此操作無法復原。';

  @override
  String get clearAllConfirm => '全部刪除';

  @override
  String get clearAllSuccess => '所有日記及其照片都已清除。';

  @override
  String clearAllError(String details) {
    return '無法清除日記資料：$details';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'Flutter 工作坊';

  @override
  String get listPageTitle => '日記列表';

  @override
  String get journalEntries => '日記';

  @override
  String get settings => '設定';

  @override
  String get landingPageTitle => '首頁';

  @override
  String get landingPageWelcome => '歡迎來到首頁！';

  @override
  String get sampleBeginningTitle => '新的開始';

  @override
  String get sampleBeginningNote => '今天開始寫日記了。';

  @override
  String get sampleAfternoonTitle => '寧靜的午後';

  @override
  String get sampleAfternoonNote => '享受了一段平靜的散步時光，也留些時間沉澱思緒。';

  @override
  String get sampleRememberTitle => '值得記住的事';

  @override
  String get sampleRememberNote => '平凡日子裡的小片刻，也能讓一天變得特別。';

  @override
  String get addJournalEntryTooltip => '新增日記';

  @override
  String get editJournalEntryTooltip => '編輯日記';

  @override
  String get deleteJournalEntryTitle => '要刪除這篇日記嗎？';

  @override
  String deleteJournalEntryConfirmation(String title) {
    return '確定要刪除「$title」嗎？此操作無法復原。';
  }

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get retry => '重試';

  @override
  String get sortNameAscending => '名稱（A-Z）';

  @override
  String get sortNameDescending => '名稱（Z-A）';

  @override
  String get sortDateAscending => '日期（最舊優先）';

  @override
  String get sortDateDescending => '日期（最新優先）';

  @override
  String get initialEntriesSaveError => '無法儲存初始日記。';

  @override
  String get storedEntriesNotListError => '儲存的日記資料格式不正確。';

  @override
  String readSavedEntriesError(String details) {
    return '無法讀取已儲存的日記：$details';
  }

  @override
  String invalidSavedEntriesError(String details) {
    return '已儲存的日記格式無效：$details';
  }

  @override
  String loadEntriesError(String details) {
    return '無法載入日記：$details';
  }

  @override
  String get preferencesRejectedEntriesError => '偏好設定儲存區拒絕儲存日記資料。';

  @override
  String saveEntriesError(String details) {
    return '無法儲存日記：$details';
  }

  @override
  String get discardChangesTitle => '要捨棄變更嗎？';

  @override
  String get discardChangesConfirmation => '您的變更將不會儲存。確定要離開此頁面嗎？';

  @override
  String get keepEditing => '繼續編輯';

  @override
  String get discard => '捨棄';

  @override
  String get chooseFromGallery => '從相簿選取';

  @override
  String get takePhoto => '拍攝照片';

  @override
  String get cameraPermissionName => '相機';

  @override
  String get photoLibraryPermissionName => '相片圖庫';

  @override
  String get permissionRequiredTitle => '需要權限';

  @override
  String photoPermissionExplanation(String permission) {
    return '新增照片至日記需要存取$permission。您可以在應用程式設定中啟用權限。';
  }

  @override
  String get openSettings => '開啟設定';

  @override
  String get openAppSettingsError => '無法開啟應用程式設定。';

  @override
  String selectImageError(String details) {
    return '無法選取圖片：$details';
  }

  @override
  String saveImageError(String details) {
    return '無法儲存所選圖片：$details';
  }

  @override
  String get missingTitleError => '尚未輸入標題，請先輸入標題再儲存。';

  @override
  String get add => '新增';

  @override
  String get edit => '編輯';

  @override
  String get title => '標題';

  @override
  String get titleRequiredError => '請輸入標題';

  @override
  String get optionalNote => '內容（選填）';

  @override
  String get addPhoto => '新增照片';

  @override
  String get selectedImageUnavailable => '無法使用所選圖片。';

  @override
  String get save => '儲存';

  @override
  String get saveChanges => '儲存變更';

  @override
  String get languageSettingTitle => '語言';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageOptionTraditionalChinese => '繁體中文';

  @override
  String languagePreferenceSaveError(String details) {
    return '無法儲存語言設定：$details';
  }

  @override
  String get languagePreferenceSaveRejected => '無法儲存語言設定。';

  @override
  String languagePreferenceLoadError(String details) {
    return '無法載入語言設定：$details';
  }

  @override
  String createdOnDate(String date) {
    return '$date 建立';
  }

  @override
  String get localStorageSizeTitle => '本機儲存空間';

  @override
  String localStorageUsage(int size) {
    return '已使用 $size KB';
  }

  @override
  String localStorageSizeLoadError(String details) {
    return '無法讀取本機儲存空間大小：$details';
  }

  @override
  String get formatClearJournalData => '格式化／清除';

  @override
  String get clearAllFirstTitle => '要清除所有日記資料嗎？';

  @override
  String get clearAllFirstMessage => '這會永久刪除所有日記及其照片。';

  @override
  String get continueAction => '繼續';

  @override
  String get clearAllSecondTitle => '再次確認';

  @override
  String get clearAllSecondMessage => '確定要永久刪除嗎？此操作無法復原。';

  @override
  String get clearAllConfirm => '全部刪除';

  @override
  String get clearAllSuccess => '所有日記及其照片都已清除。';

  @override
  String clearAllError(String details) {
    return '無法清除日記資料：$details';
  }
}
