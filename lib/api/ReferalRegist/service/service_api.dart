import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rsnaturopaty/api/ReferalRegist/auth/sign_up.dart';
import 'package:rsnaturopaty/api/ReferalRegist/route/route_generator.dart';

class DynamicLinksApi {
  final dynamicLink = FirebaseDynamicLinks.instance;

  handleDynamicLink() async {
    await dynamicLink.getInitialLink();
    dynamicLink.onLink;
  }

  Future<String> createReferralLink(String referralCode) async {
    return 'https://m.rsnaturopaty.com/register/$referralCode';
  }

  void handleSuccessLinking(Uri deepLink) {
    var isRefer = deepLink.pathSegments.contains('refer');

    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      print(code.toString());
      if (code != null) {
        GeneratedRoute.navigateTo(
          SignUpView.routeName,
          args: code,
        );
      }
    }
  }
}
