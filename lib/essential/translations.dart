import 'package:get/get.dart';

import '../constants.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          "no_internet_connection": "Please check your Internet connection",
          "name": "Name",
          "email_address": "Email address",
          "email_phone": "Email/Phone",
          "phone_number": "Phone number",
          "password": "Password",
          "confirm_password": "Confirm password",
          "old_password": "Old password",
          "new_password": "New password",
          "confirm_new_password": "Confirm new password",
          "sign_in": "Sign in",
          "sign_up": "Sign up",
          "terms_and_conditions": "Terms & Conditions",
          "forgot_password": "Forgot password?",
          "done": "Done",
          "skip": "Skip",
          "see_all": "See All",
          "handle_not_found": "Handle not found",
          "invalid_email": "Invalid email address found",
          "invalid_phone": "Invalid phone number found",
          "fill_up_all_fields": "Please fill up all the fields",
          "fill_up_the_field": "Please fill up the field",
          "valid_email_required": "Please enter a valid email address",
          "valid_email_phone_required": "Please enter a valid email/phone",
          "passwords_do_not_match": "Passwords do not match",
          "code_length_required":
              "Verification code should contain $minimumVerificationCodeLength characters",
          "minimum_password_length_required":
              "Password should contain at least $minimumPasswordLength characters",
          "weak_password": "The password provided is too weak.",
          "duplicate_email": "The account already exists for that email.",
          "splash_title": "Nbox",
          "home": "Home",
          "leader_board": "LeaderBoard",
          "shop": "Shop",
          "profile": "Profile",
          "profile_your_rank": "Your Rank",
          "profile_your_statistics": "Your Statistics",
          "profile_earned_coins": "Earned Coins",
          "profile_correct": "Correct",
          "profile_wrong": "Wrong",
          "profile_gems": "Gems",
          "profile_coins": "Coins",
        },
      };
}
