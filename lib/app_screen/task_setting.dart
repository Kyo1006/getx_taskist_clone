import 'package:flutter/material.dart';
import 'package:taskist/controller/getx_controller.dart';
import '../components/header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../web_view/web_view.dart';
import 'package:get/get.dart';
import '../theme_management/theme.dart';

class TaskSetting extends StatelessWidget {
  const TaskSetting({Key? key}) : super(key: key);
  
  static final ThemeGetx cTheme = Get.put(ThemeGetx());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
          children: <Widget>[
            const Header(title: 'Setting'),
            buildContainer(context),
          ],
        )),
      );
  }

  Widget buildContainer(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
      width: MediaQuery.of(context).size.width * 0.98,
      alignment: Alignment.center,

      child: Card(
        // height: 280,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     // color: Colors.white,
        //     boxShadow: const [
        //       BoxShadow(
        //         // color: Colors.grey,
        //         spreadRadius: 1,
        //         blurRadius: 2,
        //         offset: Offset(0.0, 0.05),
        //       )
        //     ]),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark mode',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal)),
              trailing: Obx(() => Switch(
                  onChanged: (value) {
                    print(value);
                    cTheme.changeTheme(value);
                    print(cTheme.themeObx.value.backgroundColor);
                    },
                  value: cTheme.themeObx.value == TaskistTheme.darkTheme)),
              onTap: () {},
            ),
            buildItem(context, const FaIcon(FontAwesomeIcons.gears), 'Version',
                const Text('1.1.0')),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.twitter, color: Color(0xFF74b9ff)),
                'Twitter',
                const FaIcon(FontAwesomeIcons.angleRight)),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.star, color: Color(0xFF74b9ff)),
                'Rate Takist',
                const FaIcon(FontAwesomeIcons.angleRight)),
            buildItem(
                context,
                const FaIcon(FontAwesomeIcons.share, color: Color(0xFF74b9ff)),
                'Share Taskist',
                const FaIcon(FontAwesomeIcons.angleRight))
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context, FaIcon leading, String title, Widget trailing) {
    return ListTile(
      leading: leading,
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
      trailing: trailing,
      onTap: () {
        if (leading.icon == FontAwesomeIcons.twitter) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WebView()));
        }
      },
    );
  }
}
