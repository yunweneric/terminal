import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/profile/data/logic/profile/profile_cubit.dart';
import 'package:xoecollect/profile/screens/widgets/profile_shimmer.dart';
import 'package:xoecollect/profile/screens/widgets/profile_tile.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/avatar_circle.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/shadows.dart';
import 'package:xoecollect/shared/helpers/image_helpers.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

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
      appBar: appBar(title: "Profile", context: context, canPop: true),
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
          // if (state is UserUpdateProfilePictureInit) loading = true;
          // if (state is UserUpdateProfilePictureError) loading = true;
          // if (state is UserUpdateProfilePictureError) loading = false;

          return SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: loading
                  ? Column(children: profileScreenShimmer(context))
                  : Column(
                      children: AnimateList(
                        interval: 100.ms,
                        effects: [ScaleEffect(), FadeEffect()],
                        delay: 400.ms,
                        children: [
                          kh10Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: avatarCircle(context: context, radius: 60.r, image: user?.photoUrl),
                          ),
                          kh20Spacer(),
                          // Column(
                          //   children: [
                          //     Container(
                          //       padding: kph(20.w),
                          //       decoration: BoxDecoration(borderRadius: radiusL()),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           profileCounter(context: context, count: Formaters.formatNumber(souls_count), title: "Souls"),
                          //           profileCounter(context: context, count: user_points, title: "Points"),
                          //           profileCounter(context: context, count: "0", title: "Follows"),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // kh20Spacer(),
                          // Container(
                          //   padding: kPadding(10.w, 5.h),
                          //   margin: kAppPadding(),
                          //   decoration: BoxDecoration(
                          //     boxShadow: appShadow(context),
                          //     color: Theme.of(context).cardColor,
                          //     borderRadius: radiusSm(),
                          //   ),
                          //   child: profileInfo(
                          //     context: context,
                          //     title: "Change Profile Photo",
                          //     value: user?.username ?? "",
                          //     icon: AppIcons.camera,
                          //     scale: 0.7,
                          //     showDivider: false,
                          //     onTap: () => pickImage(),
                          //   ),
                          // ),
                          kh20Spacer(),
                          Container(
                            padding: kPadding(10.w, 10.h),
                            margin: kAppPadding(),
                            decoration: BoxDecoration(
                              boxShadow: appShadow(context),
                              color: Theme.of(context).cardColor,
                              borderRadius: radiusSm(),
                            ),
                            child: Column(
                              children: [
                                profileInfo(context: context, title: "Name", value: user?.username ?? "----", icon: AppIcons.user, scale: 0.8),
                                profileInfo(context: context, title: "Email", value: user?.email ?? "----", icon: AppIcons.envelop, scale: 0.8),
                                profileInfo(
                                  context: context,
                                  title: "Phone",
                                  value: user?.phoneNumber ?? "----",
                                  icon: AppIcons.phone,
                                  scale: 0.8,
                                  showDivider: false,
                                ),
                                // profileInfo(context: context, title: "Role", value: user?.role.role ?? "----", icon: AppIcons.user, scale: 0.8),
                              ],
                            ),
                          ),
                          kh20Spacer(),
                          Container(
                            padding: kPadding(10.w, 10.h),
                            margin: kAppPadding(),
                            decoration: BoxDecoration(
                              boxShadow: appShadow(context),
                              color: Theme.of(context).cardColor,
                              borderRadius: radiusSm(),
                            ),
                            child: Column(
                              children: [
                                profileInfo(
                                    context: context,
                                    title: "Log out",
                                    value: "----",
                                    icon: AppIcons.lock,
                                    scale: 0.8,
                                    showDivider: false,
                                    onTap: () {
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
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
