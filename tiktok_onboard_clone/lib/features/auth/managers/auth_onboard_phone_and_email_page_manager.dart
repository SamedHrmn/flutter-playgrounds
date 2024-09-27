import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_phone_and_email_page.dart';

mixin AuthOnboardPhoneAndEmailPageManager on State<AuthOnboardPhoneOrEmailPage>, TickerProvider {
  late TabController tabController;
  bool activeTabFirst = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      updateActiveTabFirstOrNot(tabController.index == 0);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void updateActiveTabFirstOrNot(bool v) {
    setState(() {
      activeTabFirst = v;
    });
  }
}
