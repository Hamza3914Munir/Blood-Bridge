import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blood_bridge/screens/history_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../common/app_config.dart';
import '../common/assets.dart';
import '../common/colors.dart';
import '../common/hive_boxes.dart';
import '../screens/add_blood_request_screen.dart';
import '../screens/add_news_item.dart';
import '../screens/login_screen.dart';
import '../screens/history_screen.dart';
import '../screens/news_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/who_can_donate_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showAdmin = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'Blood Donation'),
              accountEmail: Text(user?.email ?? AppConfig.email),
              otherAccountsPictures: [
                if (Hive.box(ConfigBox.key)
                    .get(ConfigBox.isAdmin, defaultValue: false) as bool)
                  InkWell(
                    onTap: () {
                      setState(() => _showAdmin = !_showAdmin);
                    },
                    child: const Tooltip(
                      message: 'Admin Screens',
                      child: CircleAvatar(child: Icon(Icons.security_rounded,)),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewsItem()));
                  },
                  child: Tooltip(
                    message: 'Add News',
                    child: CircleAvatar(child: Icon(Icons.tips_and_updates)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: false,
                      dialogType: DialogType.warning,
                      title: 'Logout',
                      desc: 'Are you sure you want to logout?',
                      btnCancelText: 'NO',
                      btnCancelOnPress: () {},
                      btnOkText: 'YES',
                      btnOkOnPress: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.route,
                              (route) => false,
                        );
                      },
                    ).show();
                  },
                  child: const Tooltip(
                    message: 'Logout',
                    child: CircleAvatar(child: Icon(Icons.lock_open)),
                  ),
                ),
              ],
              currentAccountPicture: Hero(
                tag: 'profilePicHero',
                child: Container(
                  decoration: const BoxDecoration(
                    color: MainColors.accent,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: user?.photoURL != null
                      ? CachedNetworkImage(
                    imageUrl: user!.photoURL!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white70,
                        ),
                      ),
                    ),
                  )
                      : SvgPicture.asset(IconAssets.donor),
                ),
              ),
              margin: EdgeInsets.zero,
            ),
            Expanded(child: Column(children: _screens)),
          ],
        ),
      ),
    );
  }

  List<Widget> get _screens => [
    const _DrawerTile(
      title: 'Profile',
      icon: Icons.person,
      destination: ProfileScreen.route,
    ),
    const _DrawerTile(
      title: 'Request Blood',
      icon: Icons.bloodtype,
      destination: AddBloodRequestScreen.route,
    ),
    const _DrawerTile(
      title: 'History',
      icon: Icons.history_sharp,
      destination: HistoryScreen.route,
    ),
    if (_showAdmin)
      const _DrawerTile(
        title: 'Add News',
        icon: Icons.add,
        destination: AddNewsItem.route,
      ),
    const _DrawerTile(
      title: 'News and Tips',
      icon: Icons.notifications,
      destination: NewsScreen.route,
    ),
    const _DrawerTile(
      title: 'Can I donate blood?',
      icon: Icons.question_mark,
      destination: WhoCanDonateScreen.route,
    ),
  ];
}

class _DrawerTile extends StatelessWidget {
  final String title, destination;
  final IconData icon;

  const _DrawerTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(destination);
      },
    );
  }
}