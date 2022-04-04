import 'package:flutter/material.dart';
import 'package:jais/components/full_button.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/user_widget.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/notifications.dart';
import 'package:jais/views/login_view.dart';
import 'package:jais/views/register_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _hasRegisterTap = false;
  bool _hasLoginTap = false;

  @override
  Widget build(BuildContext context) {
    if (_hasRegisterTap) {
      return RegisterView(
        () => setState(() => _hasRegisterTap = false),
      );
    }

    if (_hasLoginTap) {
      return LoginView(
        () => setState(() => _hasLoginTap = false),
      );
    }

    final bool _hasTopic = hasTopic("animes");

    return Column(
      children: [
        if (!isConnected())
          SectionWidget(
            icon: const Icon(Icons.person),
            title: 'Identification',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Inscription'),
                  onPressed: () => setState(() => _hasRegisterTap = true),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Connexion'),
                  onPressed: () => setState(() => _hasLoginTap = true),
                ),
              ),
            ],
          ),
        if (isConnected())
          SectionWidget(
            icon: const Icon(Icons.person),
            title: 'Profil',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Mon profil'),
                  onPressed: () => show(
                    context,
                    widget: UserWidget(user!),
                  ),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Déconnexion'),
                  onPressed: () {
                    logout();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        if (isConnected())
          SectionWidget(
            icon: const Icon(Icons.notifications),
            title: 'Notifications',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  onPressed: _hasTopic
                      ? null
                      : () {
                          removeAllTopics();
                          addTopic("animes");
                          setState(() {});
                        },
                  onLongPress: _hasTopic
                      ? null
                      : () => show(
                            context,
                            widget: Column(
                              children: const [
                                Text(
                                  'Mode par défaut des notifications',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Text(
                                  "Ce mode vous avertit de toutes les mises à jour récentes, qu'il s'agisse d'épisodes ou de scans.",
                                ),
                              ],
                            ),
                          ),
                  child: const Text('Par défaut'),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  onPressed: _hasTopic
                      ? () {
                          removeAllTopics();
                          setState(() {});
                        }
                      : null,
                  onLongPress: _hasTopic
                      ? () => show(
                            context,
                            widget: Column(
                              children: const [
                                Text(
                                  'Personnalisation des notifications',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Text(
                                  "Choissisez les animes dont vous souhaitez être informé à chaque mise à jour récentes.",
                                ),
                              ],
                            ),
                          )
                      : null,
                  child: const Text('Personnalisé'),
                ),
              ),
            ],
          ),
        const SectionWidget(
          icon: Icon(Icons.thumb_up_alt),
          title: 'Soutien',
          widgets: [
            FullWidget(
              widget: ElevatedButton(
                onPressed: showVideo,
                child: Text('Soutenir'),
              ),
            ),
          ],
        ),
        SectionWidget(
          icon: const Icon(Icons.bug_report),
          title: 'Mode développeur',
          widgets: [
            FullWidget(
              widget: ElevatedButton(
                child: const Text('Test'),
                onPressed: () {},
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

  const SectionWidget({required this.icon, required this.title, this.widgets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: FullWidget(
            icon: icon,
            widget: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        const Padding(
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
