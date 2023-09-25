import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/data/model/pinn_routing_model.dart';
import 'package:xoecollect/profile/data/logic/profile/profile_cubit.dart';
import 'package:xoecollect/profile/screens/widgets/profile_tile.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/avatar_circle.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/helpers/image_helpers.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? user;
  int souls_count = 0;
  String user_points = "0";
  bool loading = false;
  String? current_pin;

  @override
  void initState() {
    context.read<ProfileCubit>().fetchUserData(context);
    super.initState();
  }

  Future<void> pickImage() async {
    File? file = await ImageHelper.takeImage();
    if (file != null) {
      context.read<ProfileCubit>().updateProfilePicture(context, file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Account",
        context: context,
        bgColor: kWhite,
        style: Theme.of(context).textTheme.displayLarge,
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFetchDataInit) loading = true;
              if (state is ProfileFetchDataError) loading = true;
              if (state is ProfileFetchDataSuccess) {
                setState(() {
                  user = state.res;
                  loading = false;
                });
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is AuthCreateNewPinInit) {
                AppLoaders.showLoader(context: context);
              }
              if (state is AuthCreateNewPinError) {
                AppLoaders.dismissEasyLoader();
                AppModal.showErrorAlert(context: context, title: "Reset New Pin", desc: state.res.message);
              }
              if (state is AuthCreateNewPinSuccess) {
                context.pop();
                AppLoaders.dismissEasyLoader();
                AppLoaders.easySuccess(context, "Pin reset successfully!");
              }
              if (state is AuthVerifyPinSuccess) {
                if (state.res) {
                  await Future.delayed(100.ms);
                  logI(state);
                  context.push(
                    AppRoutes.auth_pin_screen,
                    extra: PinRoutingModel(
                      title: "Create new pin",
                      onComplete: (pin, _) {
                        BlocProvider.of<AuthCubit>(context).createNewPin(context, pin, user!.uid);
                      },
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: Container(
          height: kHeight(context),
          child: Column(
            children: [
              kh10Spacer(),
              Padding(
                padding: kAppPadding(),
                child: Row(
                  children: [
                    avatarNameCircle(
                      context: context,
                      radius: 30.r,
                      name: user?.username ?? "A",
                    ),
                    kwSpacer(10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.username ?? "---", style: Theme.of(context).textTheme.displayMedium),
                          SizedBox(child: Text(user?.uid ?? "----", style: Theme.of(context).textTheme.bodySmall)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              kh20Spacer(),
              Container(
                padding: kPadding(0.w, 10.h),
                margin: kAppPadding(),
                child: Column(
                  children: [
                    profileInfo(
                      context: context,
                      title: "Change Pin",
                      value: "",
                      icon: AppIcons.lock,
                      scale: 0.8,
                      onTap: () {
                        context.push(
                          AppRoutes.auth_pin_screen,
                          extra: PinRoutingModel(
                            onComplete: (pin, _) {
                              setState(() {
                                current_pin = pin;
                              });
                              BlocProvider.of<AuthCubit>(context).verifyPin(context, pin);
                            },
                            title: "Enter old pin",
                          ),
                        );
                      },
                    ),
                    profileInfo(
                      context: context,
                      title: "Phone",
                      value: user?.phoneNumber ?? "----",
                      icon: AppIcons.phone,
                      scale: 0.8,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: kAppPadding(),
                child: profileInfo(
                  context: context,
                  title: "Log out",
                  value: "",
                  icon: AppIcons.lock,
                  danger: true,
                  scale: 0.8,
                  onTap: () => logOutModal(),
                  showDivider: false,
                ),
              ),
              kh20Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  logOutModal() {
    AppSheet.simpleModal(
      context: context,
      height: 300.h,
      alignment: Alignment.center,
      padding: kAppPadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logout", style: Theme.of(context).textTheme.displayMedium),
          kh10Spacer(),
          Text(
            "Are you sure you want to logout of your account?",
            textAlign: TextAlign.center,
          ),
          kh20Spacer(),
          submitButton(
            context: context,
            onPressed: () async {
              bool loggedOut = await LocalPreferences.logOutUser();
              if (loggedOut) context.go(AppRoutes.login);
            },
            text: "Yes Proceed",
          ),
          kh10Spacer(),
          submitButton(
            color: Theme.of(context).cardColor,
            textColor: Theme.of(context).primaryColor,
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            context: context,
            onPressed: () => context.pop(),
            text: "No, I am enjoying the app!",
          ),
        ],
      ),
    );
  }
}
