import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/components/section_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/views/users/login_view.dart';
import 'package:jais/views/users/register_view.dart';
import 'package:notifications/notifications.dart' as notifications;

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          icon: const Icon(Icons.person),
          title: member_mapper.isConnected()
              ? member_mapper.getPseudo()!
              : 'Utilisateur',
          widgets: [
            if (!member_mapper.isConnected()) ...[
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Inscription'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                    );
                  },
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Connexion'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );

                    if (!mounted) return;
                    setState(() {});
                  },
                ),
              )
            ],
            if (member_mapper.isConnected()) ...[
              const FullWidget(
                widget: ElevatedButton(
                  onPressed: null,
                  child: Text('Mon profil'),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: const Text('Déconnexion'),
                  onPressed: () {
                    notifications.removeAllTopics();
                    notifications.addTopic("animes");
                    member_mapper.logout();
                    if (!mounted) return;
                    setState(() {});
                  },
                ),
              ),
            ],
          ],
        ),
        if (member_mapper.isConnected())
           SectionWidget(
            icon: const Icon(Icons.notifications),
            title: 'Notifications',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  onPressed: notifications.hasTopic("animes") ? null : () {
                    notifications.removeAllTopics();
                    notifications.addTopic("animes");
                    if (!mounted) return;
                    setState(() {});
                  },
                  child: const Text('Par défaut'),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  onPressed: _canBeUsed() ? () {
                    notifications.removeAllTopics();

                    for (final animeId in member_mapper.getWatchlist()) {
                      notifications.addTopic(animeId.toString());
                    }

                    if (!mounted) return;
                    setState(() {});
                  } : null,
                  child: Text('Watchlist${(_canBeUsed() && !notifications.hasTopic("animes") && !_same()) ? ' (Mettre à jour)' : '' }'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  bool _canBeUsed() {
    if (notifications.hasTopic("animes")) {
      return !_same();
    }

    return false;
  }

  bool _same() {
    final topics = notifications.getTopics();
    final watchlist = member_mapper.getWatchlist();

    if (watchlist.length == topics.length) {
      for (final element in watchlist) {
        if (!topics.contains(element.toString())) {
          return false;
        }
      }

      return true;
    }

    return false;
  }
}
