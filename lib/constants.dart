import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

// Default values
const bool defaultBoolean = false;
const int defaultInt = 0;
const double defaultDouble = 0.0;
const String defaultString = "";
const String spaceString = " ";
const String newLineString = "\n";

// App colors (main)
const Color colorPrimary = const Color(0xFF172031);
const Color colorAccent = const Color(0xFFFFFFFF);
const Color colorHighlight = const Color(0xFFFBB217);
const Color colorBottomBarBackground = const Color(0xFF1C2635);
const Color colorDisabled = const Color(0xFF6F787A);

// App colors (text)
const Color colorTextRegular = const Color(0xFF272B37);
const Color colorTextSecondary = const Color(0xFFB9BAC8);
const Color colorTextTertiary = const Color(0xFF6B7285);
const Color colorTextWarning = const Color(0xFFF1775C);

// App colors (others)
const Color colorInputFieldBackground = const Color(0xFFF9F9F9);
const Color colorInputFieldBorder = const Color(0xFFEEEEEE);
const Color colorPageBackground = const Color(0xFF172031);
const Color colorItemInactiveBackground = const Color(0xFFEBF2FE);
const Color colorItemActiveBackground = const Color(0xFF3580F7);
const Color colorExamItemInactiveBackground = const Color(0xFFF5F6FC);
const Color colorExamItemActiveBackground = const Color(0xFF3580F7);
const Color colorUserActive = const Color(0xFF00D563);
const Color colorWinningTeamBackground = const Color(0xFF6CE6E1);
const Color colorWinProgress = const Color(0xFF27AE60);
const Color colorLoseProgress = const Color(0xFFEB5757);
const Color colorTieProgress = colorAccent;
const Color colorSkipProgress = colorWinningTeamBackground;
const Color colorOrange = const Color(0xFFF2994A);

// Text styles
const TextStyle textStyleBottomBarItem = const TextStyle(
  color: colorDisabled,
  fontSize: 14.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w700,
);

const TextStyle textStyleSectionTitle = const TextStyle(
  color: colorTextRegular,
  fontSize: 18.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w400,
);

const TextStyle textStyleSectionItemTitle = const TextStyle(
  color: colorTextRegular,
  fontSize: 16.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w700,
);

const TextStyle textStyleSectionItemBody = const TextStyle(
  color: colorTextRegular,
  fontSize: 16.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w400,
);

const TextStyle textStyleAppBar = const TextStyle(
  color: colorTextRegular,
  fontSize: 20.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w600,
);

const TextStyle textStyleFocused = const TextStyle(
  color: colorAccent,
  fontSize: 16.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w700,
);

const TextStyle textStyleRegular = const TextStyle(
  color: colorTextRegular,
  fontSize: 14.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w400,
);

const TextStyle textStyleSmall = const TextStyle(
  color: colorAccent,
  fontSize: 12.0,
  fontFamily: "Product Sans",
  fontWeight: FontWeight.w400,
);

// Input Decoration
const InputDecoration inputDecorationForm = const InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
  //hintStyle: textStyleInputFormHint,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  border: InputBorder.none,
);

// Box Decoration
const BoxDecoration boxDecorationBorderForm = const BoxDecoration(
  color: colorInputFieldBackground,
  borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
  border: const Border.fromBorderSide(
    const BorderSide(color: colorInputFieldBorder),
  ),
);

const BoxDecoration boxDecorationSectionCardBackground = const BoxDecoration(
  color: Colors.white,
  borderRadius: const BorderRadius.all(
    const Radius.circular(20.0),
  ),
);

const BoxDecoration boxDecorationBackButtonBorder = const BoxDecoration(
  borderRadius: const BorderRadius.all(
    const Radius.circular(10.0),
  ),
  border: const Border.fromBorderSide(
    const BorderSide(color: colorTextSecondary),
  ),
);

// Shape
const RoundedRectangleBorder shapeButtonRectangle =
    const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(
    const Radius.circular(10.0),
  ),
);

const RoundedRectangleBorder shapeCardItemRectangle =
    const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(
    const Radius.circular(16.0),
  ),
);

// Service
const SystemUiOverlayStyle systemUiOverlayStyleGlobal =
    const SystemUiOverlayStyle(
  systemNavigationBarColor: colorPrimary,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
);

// App essentials
const String responseOfJsonType = "application/json";
const int minimumPasswordLength = 8;
const int minimumVerificationCodeLength = 4;
const String prefixAuthToken = "Bearer ";

// Backend
const String baseDevelopmentUrl = "";
const String baseLiveUrl = "";
const String baseUrl = baseDevelopmentUrl;

// const String _baseAppDevelopmentUrlLiveTv = "http://103.137.75.74:2300";
// const String _baseAppDevelopmentUrlLiveTv = "http://103.137.75.66:2300";
const String _baseAppDevelopmentUrlLiveTv = "http://tvapp.ctgtv.live/";
const String _baseAppLiveUrl = "http://tvapp.ctgtv.live:82";
const String baseAppUrlLiveTv = _baseAppDevelopmentUrlLiveTv;
final String baseMediaUrlLiveTv = join(baseAppUrlLiveTv, "media");
final String baseApiUrlLiveTv = join(baseAppUrlLiveTv, "android_apps");

const String _baseAppDevelopmentUrlVideos = "http://103.137.75.73:5051";
// const String _baseAppDevelopmentUrlVideos = "";
const String baseAppUrlVideos = _baseAppDevelopmentUrlVideos;
final String baseMediaUrlVideos = baseAppUrlVideos;
final String baseApiUrlVideos = join(baseAppUrlVideos, "api");

final String bannerUrl = join(baseApiUrlLiveTv, "cover");
final String movieCategoriesUrl = join(baseApiUrlLiveTv, "movie_catlist");
final String moviesUrl = join(baseApiUrlLiveTv, "cat");
final String tvChannelCategoriesUrl = join(baseApiUrlLiveTv, "list_tv");
final String tvChannelsUrl = join(baseApiUrlLiveTv, "list_tv");
final String featuredTvChannelsUrl = join(baseApiUrlLiveTv, "featured");
final String billingMessageUrl = join(baseApiUrlLiveTv, "alert_text");
final String adUrl = join(baseApiUrlLiveTv, "alert_img");
final String updateAppUrl = join(baseApiUrlLiveTv, "up");
final String mixedChannelUrl = join(baseApiUrlLiveTv, "mix");
final String videosPageBannerUrl = join(baseApiUrlVideos, "slider");
final String videosPageMovieCategoriesUrl =
    join(baseApiUrlVideos, "movie-category-list");
final String videosPageMoviesByCategoryUrl =
    join(baseApiUrlVideos, "movieByCategory");
final String videosPageMoreMoviesByCategoryUrl =
    join(baseApiUrlVideos, "moreMovieByCategory");
final String latestTenMoviesUrl = join(baseApiUrlVideos, "latestTenMovies");
final String mostPopularMoviesUrl = join(baseApiUrlVideos, "mostPopularMovies");
final String mostPopularTvSeriesUrl = join(
  baseApiUrlVideos,
  "mostPopularTvSeries",
);
final String videosPageTvSeriesCategoriesUrl = join(
  baseApiUrlVideos,
  "tvSeries-category-list",
);
final String videosPageTvSeriesByCategoryUrl = join(
  baseApiUrlVideos,
  "tvSeriesByCategory",
);
final String videosPageMoreTvSeriesByCategoryUrl = join(
  baseApiUrlVideos,
  "moreTvSeriesByCategory",
);
final String latestTenTvSeriesUrl = join(
  baseApiUrlVideos,
  "latestTenTvSeries",
);
final String movieDetailsUrl = join(
  baseApiUrlVideos,
  "singleMovieDetails",
);
final String tvSeriesDetailsUrl = join(
  baseApiUrlVideos,
  "singleTvSeriesDetails",
);

// Key
const String keySuccess = "success";
const String keyData = "data";
const String keyMessage = "message";
const String keyEmail = "email";
const String keyPassword = "password";
const String keyToken = "token";
const String keyAuthToken = "auth_token";
const String keyTrainingCategories = "training_categories";
const String keyTimeLengths = "time_lengths";
const String keyProfessions = "professions";
const String keyCategoryIconUrl = "cat_icon_url";
const String keySubmittedPreferences = "submitted_preferences";
const String keyTrainingCategory = "training_category";
const String keyTimeLength = "time_length";
const String keyProfession = "profession";
const String keyVerificationCode = "verification_code";
const String keyUserType = "user_type";
const String keyUserPreferences = "user_preferences";
const String keyExam = "exam";
const String keyPage = "page";

// Regular Expression
const String regularExpressionEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String regularExpressionPhone =
    "(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?" +
        "([0-9][0-9\\- \\.]+[0-9])";
