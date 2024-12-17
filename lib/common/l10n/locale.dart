import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'locale_en.dart';
import 'locale_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Lang
/// returned by `Lang.of(context)`.
///
/// Applications need to include `Lang.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/locale.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Lang.localizationsDelegates,
///   supportedLocales: Lang.supportedLocales,
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
/// be consistent with the languages listed in the Lang.supportedLocales
/// property.
abstract class Lang {
  Lang(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Lang of(BuildContext context) {
    return Localizations.of<Lang>(context, Lang)!;
  }

  static const LocalizationsDelegate<Lang> delegate = _LangDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get languageCode;

  /// No description provided for @localeCode.
  ///
  /// In en, this message translates to:
  /// **'en_US'**
  String get localeCode;

  /// No description provided for @actionTAB.
  ///
  /// In en, this message translates to:
  /// **'------ACTIONS------'**
  String get actionTAB;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @clean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get clean;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editAlt.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAlt;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @enterText.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get enterText;

  /// No description provided for @commonTAB.
  ///
  /// In en, this message translates to:
  /// **'------COMMONS------'**
  String get commonTAB;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @authorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get authorization;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @contactForm.
  ///
  /// In en, this message translates to:
  /// **'Contact form'**
  String get contactForm;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get users;

  /// No description provided for @settingsTAB.
  ///
  /// In en, this message translates to:
  /// **'------ERRORS------'**
  String get settingsTAB;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @standart.
  ///
  /// In en, this message translates to:
  /// **'Standart'**
  String get standart;

  /// No description provided for @errorTAB.
  ///
  /// In en, this message translates to:
  /// **'------ERRORS------'**
  String get errorTAB;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @permissionError.
  ///
  /// In en, this message translates to:
  /// **'Permission error'**
  String get permissionError;

  /// No description provided for @serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get serviceUnavailable;

  /// No description provided for @stateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Unexpected state'**
  String get stateEmpty;

  /// No description provided for @taskRemoveError.
  ///
  /// In en, this message translates to:
  /// **'Error removing task'**
  String get taskRemoveError;

  /// No description provided for @taskRemoveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task removed'**
  String get taskRemoveSuccess;

  /// No description provided for @unsupportedFormatError.
  ///
  /// In en, this message translates to:
  /// **'Unsupported image format'**
  String get unsupportedFormatError;

  /// No description provided for @updateUserError.
  ///
  /// In en, this message translates to:
  /// **'Error updating user'**
  String get updateUserError;

  /// No description provided for @deleteUserError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user'**
  String get deleteUserError;

  /// No description provided for @hideUserError.
  ///
  /// In en, this message translates to:
  /// **'Error hiding user'**
  String get hideUserError;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @usersNotFound.
  ///
  /// In en, this message translates to:
  /// **'Users not found'**
  String get usersNotFound;

  /// No description provided for @networkConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get networkConnectionError;

  /// No description provided for @errorSavingToken.
  ///
  /// In en, this message translates to:
  /// **'Error saving token'**
  String get errorSavingToken;

  /// No description provided for @invalidToken.
  ///
  /// In en, this message translates to:
  /// **'Invalid token'**
  String get invalidToken;

  /// No description provided for @noNetworkFound.
  ///
  /// In en, this message translates to:
  /// **'No network found'**
  String get noNetworkFound;

  /// No description provided for @multicastLimitError.
  ///
  /// In en, this message translates to:
  /// **'Multicast Limit cannot be empty'**
  String get multicastLimitError;

  /// No description provided for @numberShouldBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Must be a number greater than 0'**
  String get numberShouldBeGreaterThanZero;

  /// No description provided for @routeTargetValidationError.
  ///
  /// In en, this message translates to:
  /// **'Invalid route target'**
  String get routeTargetValidationError;

  /// No description provided for @invalidCIDR.
  ///
  /// In en, this message translates to:
  /// **'Invalid CIDR format'**
  String get invalidCIDR;

  /// No description provided for @invalidIP.
  ///
  /// In en, this message translates to:
  /// **'Invalid IP format'**
  String get invalidIP;

  /// No description provided for @invalidIpRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid IP Range'**
  String get invalidIpRange;

  /// No description provided for @nameValidationError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameValidationError;

  /// No description provided for @confirmTAB.
  ///
  /// In en, this message translates to:
  /// **'------CONFIRMATIONS------'**
  String get confirmTAB;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @removeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete it?'**
  String get removeConfirm;

  /// No description provided for @networkSaved.
  ///
  /// In en, this message translates to:
  /// **'Network settings saved'**
  String get networkSaved;

  /// No description provided for @enterNetworkName.
  ///
  /// In en, this message translates to:
  /// **'Enter Network Name'**
  String get enterNetworkName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @addingUser.
  ///
  /// In en, this message translates to:
  /// **'Adding User'**
  String get addingUser;

  /// No description provided for @addUserManuallyByNodeID.
  ///
  /// In en, this message translates to:
  /// **'Add User Manually by Node ID'**
  String get addUserManuallyByNodeID;

  /// No description provided for @inviteUserByEmail.
  ///
  /// In en, this message translates to:
  /// **'Invite User'**
  String get inviteUserByEmail;

  /// No description provided for @textTAB.
  ///
  /// In en, this message translates to:
  /// **'------TEXT_ACTIONS------'**
  String get textTAB;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @tokenTAB.
  ///
  /// In en, this message translates to:
  /// **'------TOKEN_ACTIONS------'**
  String get tokenTAB;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @tokenName.
  ///
  /// In en, this message translates to:
  /// **'Token Name'**
  String get tokenName;

  /// No description provided for @savedTokens.
  ///
  /// In en, this message translates to:
  /// **'Saved Tokens'**
  String get savedTokens;

  /// No description provided for @noSavedTokens.
  ///
  /// In en, this message translates to:
  /// **'No saved tokens'**
  String get noSavedTokens;

  /// No description provided for @addToken.
  ///
  /// In en, this message translates to:
  /// **'Add Token'**
  String get addToken;

  /// No description provided for @networkTAB.
  ///
  /// In en, this message translates to:
  /// **'------NETWORK_ACTIONS------'**
  String get networkTAB;

  /// No description provided for @authorized.
  ///
  /// In en, this message translates to:
  /// **'Authorized'**
  String get authorized;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// No description provided for @ipAssignments.
  ///
  /// In en, this message translates to:
  /// **'IP Assignments'**
  String get ipAssignments;

  /// No description provided for @ipAssignment.
  ///
  /// In en, this message translates to:
  /// **'IP Assignment'**
  String get ipAssignment;

  /// No description provided for @ipRangeStart.
  ///
  /// In en, this message translates to:
  /// **'IP Range Start'**
  String get ipRangeStart;

  /// No description provided for @ipRangeEnd.
  ///
  /// In en, this message translates to:
  /// **'IP Range End'**
  String get ipRangeEnd;

  /// No description provided for @enableBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Enable Broadcast'**
  String get enableBroadcast;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @multicastLimit.
  ///
  /// In en, this message translates to:
  /// **'Multicast Limit'**
  String get multicastLimit;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @networks.
  ///
  /// In en, this message translates to:
  /// **'Networks'**
  String get networks;

  /// No description provided for @networkConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Network Configuration'**
  String get networkConfiguration;

  /// No description provided for @networkName.
  ///
  /// In en, this message translates to:
  /// **'Network Name'**
  String get networkName;

  /// No description provided for @routeTarget.
  ///
  /// In en, this message translates to:
  /// **'Routing Target (CIDR)'**
  String get routeTarget;

  /// No description provided for @createNetwork.
  ///
  /// In en, this message translates to:
  /// **'Create Network'**
  String get createNetwork;

  /// No description provided for @newNetwork.
  ///
  /// In en, this message translates to:
  /// **'New Network'**
  String get newNetwork;

  /// No description provided for @addIpToAssignments.
  ///
  /// In en, this message translates to:
  /// **'You can add IPs by separating them with commas'**
  String get addIpToAssignments;

  /// No description provided for @deleteNetwork.
  ///
  /// In en, this message translates to:
  /// **'Delete Network'**
  String get deleteNetwork;

  /// No description provided for @deviceIP.
  ///
  /// In en, this message translates to:
  /// **'Device IP'**
  String get deviceIP;

  /// No description provided for @nodeID.
  ///
  /// In en, this message translates to:
  /// **'Node ID'**
  String get nodeID;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get lastSeen;

  /// No description provided for @onlineAndQtyOfNodes.
  ///
  /// In en, this message translates to:
  /// **'online/nodes'**
  String get onlineAndQtyOfNodes;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @dateTAB.
  ///
  /// In en, this message translates to:
  /// **'------DATE_ACTIONS------'**
  String get dateTAB;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **'minute ago'**
  String get minuteAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'hour ago'**
  String get hourAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// No description provided for @fewDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get fewDaysAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;
}

class _LangDelegate extends LocalizationsDelegate<Lang> {
  const _LangDelegate();

  @override
  Future<Lang> load(Locale locale) {
    return SynchronousFuture<Lang>(lookupLang(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_LangDelegate old) => false;
}

Lang lookupLang(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return LangEn();
    case 'ru': return LangRu();
  }

  throw FlutterError(
    'Lang.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
