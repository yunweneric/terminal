import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/profile/data/logic/profile/profile_cubit.dart';
import 'package:xoecollect/profile/screens/widgets/profile_tile.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/avatar_circle.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/helpers/image_helpers.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
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
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // if (state is UserFetchDataSuccess) Future.delayed(1200.ms, () => setState(() => loading = false));

          // //Todo:: When alert are all up implement this.
          // if (state is UserFetchDataError) {}
          // if (state is UserUpdateProfilePictureSuccess) {
          //   context.read<ProfileCubit>().fetchUserData(context);
          // }
        },
        builder: (context, state) {
          if (state is ProfileFetchDataInit) loading = true;
          if (state is ProfileFetchDataError) loading = true;
          if (state is ProfileFetchDataSuccess) {
            user = state.res;
            loading = false;
          }
          return Container(
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
                        name: "A",
                      ),
                      kwSpacer(10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Andrew Ainsley", style: Theme.of(context).textTheme.displayMedium),
                          Text("ID 2512541"),
                        ],
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
                      profileInfo(context: context, title: "Change Pin", value: "", icon: AppIcons.lock, scale: 0.8),
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
          );
        },
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
