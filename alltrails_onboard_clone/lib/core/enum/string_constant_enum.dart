enum StringConstantEnum {
  errorEmailFieldEmpty("Email field can not be empty"),
  errorPasswordFieldEmpty("Password field can not be empty"),
  errorEmailFieldInvalid("Email field is invalid"),
  welcomeGoogleButtonText("Continue with Google"),
  welcomeFacebookButtonText("Continue with Facebook"),
  welcomeAppleButtonText("Continue with Apple"),
  welcomeDividerOrText("OR"),
  welcomeCreateAccountButtonText("Create a free account"),
  welcomeAlreadyHaveAnAccountText("Already have an account?"),
  welcomeLogInText("Log in"),
  welcomeTitleDiscover("Discover"),
  welcomeTitleSave("Save"),
  welcomeTitleNavigate("Navigate"),
  welcomeTitleBottomText("trails you love"),
  welcomePrivacyPolicyText(
      "By continuing to use AllTrails you agree to our <b>Terms of Service</b> and <b>Privacy Policy</b>. Personal data added to AllTrails is public by default - refer to our <b>Privacy FAQs</b> to make changes."),
  signUpPagesAppBarText("Step * of 3"),
  signUpPagesButtonText("Next"),
  signUpPagesEmailHint("Email"),
  signUpPagesPasswordHint("Password"),
  signUpPagesShowPassword("Show password"),
  signUpPagesEmailTitle("What's your email?"),
  signUpPagesPasswordTitle("Create a password"),
  signUpPagesNameTitle("What's your name?"),
  signUpPagesFirstNameHint("First name"),
  signUpPagesLastNameHint("Last name"),
  paywallTitle("Your first week is on us"),
  paywallPromotion("Get 7 days free, then only <b>\$35.99</b>/year."),
  paywallFeature1("<b>Today:</b> Unlock all features"),
  paywallFeature2("<b>Day 5:</b> Get a trial reminder"),
  paywallButtonText("Start your free trial"),
  paywallFeature3("<b>Day 7:</b> You'll be charged <b>\$35.99</b>/year"),
  paywallWhatsIncluded("What's included"),
  paywallIncluded1("Navigate on the trail"),
  paywallIncluded2("Favourite trails & create lists"),
  paywallIncluded3("Download offline maps"),
  paywallIncludedFree("Free");

  final String name;
  const StringConstantEnum(this.name);
}