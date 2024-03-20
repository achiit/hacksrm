import 'package:smart_home/english/common/app_assets.dart';
import 'package:smart_home/english/common/app_strings_en.dart';
import 'package:smart_home/english/common/app_strings_tn.dart';
import 'package:smart_home/tamil/features/oboarding/onboarding_model.dart';

final List<OnboardingModel> onboardingData = [
  const OnboardingModel(
    assetPathLight: AppAssets.onboardOneLight,
    assetPathDark: AppAssets.onboardOneDark,
    title: AppStringsTa.onboardingOneTitle,
    subTitle: AppStringsTa.onboardingOneSubtitle,
  ),
  const OnboardingModel(
    assetPathLight: AppAssets.onboardTwoLight,
    assetPathDark: AppAssets.onboardTwoDark,
    title: AppStringsTa.onboardingTwoTitle,
    subTitle: AppStringsTa.onboardingTwoSubtitle,
  ),
  const OnboardingModel(
    assetPathLight: AppAssets.onboardThreeLight,
    assetPathDark: AppAssets.onboardThreeDark,
    title: AppStringsTa.onboardingThreeTitle,
    subTitle: AppStringsTa.onboardingThreeSubtitle,
  ),
];
