import 'package:Logistic/addeditemployee.dart';
import 'package:Logistic/constant/app_assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:galo_energy/constant/app_assets.dart';
// import 'package:galo_energy/SplashDashbaordScreen.dart';
// import 'package:galo_energy/SplashScreen.dart';
// import 'package:galo_energy/constant/app_assets.dart';
// import 'package:galo_energy/constant/app_color.dart';

// import '../add_edit/EditProfile.dart';
// import '../home_page.dart';

class GautamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final isBackRequired;
  final void Function()? onTap;
  final memberPic;
  final logo;
  final memberId;
  final imgPath;
  final organization;

  const GautamAppBar({
    Key? key,
    this.isBackRequired = false,
    this.onTap,
    this.organization,
    this.memberPic,
    this.logo,
    this.memberId,
    this.imgPath,
  }) : super(key: key);

  isDarkMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  isLightMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: isDarkMode(context) == Brightness.light
              ? Brightness.dark
              : isLightMode(context) == Brightness.light
                  ? Brightness.dark
                  : Brightness.light),
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      // AppColors.white,
      leadingWidth: double.infinity,
      leading: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            if (isBackRequired)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Material(
                  child: InkWell(
                    onTap: onTap,
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.icRoundBlack,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddEditProfile(id: memberId)),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  width: 35,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: (memberPic ?? ''),
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.asset(
                              AppAssets.profilePlaceholder,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          radius: 20,
                          child: ClipOval(
                            child: Image.asset(
                              AppAssets.profilePlaceholder,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: CachedNetworkImage(
            imageUrl: (imgPath + (logo ?? '')),
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.14,
            errorWidget: (context, url, error) {
              return Image.asset(
                AppAssets.icAppLogoHorizontal,
                // AppAssets.getAppLogo;
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width * 0.38,
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
// imageUrl: (imgPath + (memberPic ?? ''))