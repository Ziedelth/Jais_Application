import 'package:flutter/material.dart';
import 'package:jais/components/full_button.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/views/login_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _hasLoginTap = false;

  @override
  Widget build(BuildContext context) {
    if (_hasLoginTap) {
      return LoginView(
        () => setState(() => _hasLoginTap = false),
      );
    }

    return Column(
      children: [
        if (!UserMapper.isConnected())
          SectionWidget(
            icon: Icon(Icons.person),
            title: 'Identification',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Inscription'),
                  onPressed: null,
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Connexion'),
                  onPressed: () => setState(() => _hasLoginTap = true),
                ),
              ),
            ],
          ),
        if (UserMapper.isConnected())
          SectionWidget(
            icon: Icon(Icons.person),
            title: 'Profil',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Mon profil'),
                  onPressed: null,
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Déconnexion'),
                  onPressed: () {
                    UserMapper.logout();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        SectionWidget(
          icon: Icon(Icons.thumb_up_alt),
          title: 'Soutien',
          widgets: [
            FullWidget(
              widget: ElevatedButton(
                child: Text('Soutenir'),
                onPressed: () => JaisAd.showVideo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SectionWidget extends StatelessWidget {
  final Icon icon;
  final String title;
  final List<Widget>? widgets;

  SectionWidget({required this.icon, required this.title, this.widgets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: FullWidget(
            icon: icon,
            widget: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.5),
          child: Divider(
            height: 1,
          ),
        ),
        ...?widgets
      ],
    );
  }
}
