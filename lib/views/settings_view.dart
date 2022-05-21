import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/components/section_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/views/members/login_view.dart';
import 'package:jais/views/members/member_view.dart';
import 'package:jais/views/members/register_view.dart';
import 'package:notifications/notifications.dart' as notifications;

class SettingsView extends StatefulWidget {
  final Function()? onLogin;
  final Function()? onLogout;

  const SettingsView({this.onLogin, this.onLogout, Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final isDefaultMode = member_mapper.notificationsMode() == "default";
    final isWatchlistModeOrNeedUpdate =
        member_mapper.notificationsMode() == "watchlist" && !_same();

    return SingleChildScrollView(
      child: Column(
        children: [
          SectionWidget(
            icon: const Icon(Icons.person),
            title: member_mapper.isConnected()
                ? '${member_mapper.getMember()?.pseudo}'
                : 'Utilisateur',
            widgets: [
              if (!member_mapper.isConnected()) ...[
                FullWidget(
                  widget: ElevatedButton(
                    child: const Text('Inscription'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterView(
                            onLogin: widget.onLogin,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FullWidget(
                  widget: ElevatedButton(
                    child: const Text('Connexion'),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginView(
                            onLogin: widget.onLogin,
                          ),
                        ),
                      );

                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                )
              ],
              if (member_mapper.isConnected()) ...[
                FullWidget(
                  widget: ElevatedButton(
                    child: const Text('Mon profil'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MemberView(
                            member: member_mapper.getMember()!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FullWidget(
                  widget: ElevatedButton(
                    child: const Text('Déconnexion'),
                    onPressed: () {
                      member_mapper.setDefaultNotifications();
                      member_mapper.setMember(null);
                      widget.onLogout?.call();
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
                    onPressed: isDefaultMode
                        ? null
                        : () {
                            member_mapper.setDefaultNotifications();
                            if (!mounted) return;
                            setState(() {});
                          },
                    child: const Text('Par défaut'),
                  ),
                ),
                const SizedBox(height: 16),
                FullWidget(
                  widget: ElevatedButton(
                    onPressed: (isDefaultMode || isWatchlistModeOrNeedUpdate)
                        ? () {
                            member_mapper.setWatchlistNotifications();
                            if (!mounted) return;
                            setState(() {});
                          }
                        : null,
                    child: Text(
                      'Watchlist${isWatchlistModeOrNeedUpdate ? ' (Mettre à jour)' : ''}',
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _same() {
    if (!member_mapper.isConnected()) {
      return true;
    }

    final topics = notifications.getTopics();
    final watchlist = member_mapper.getMember()!.watchlist;

    if (watchlist.length == topics.length) {
      for (final element in watchlist) {
        if (!topics.contains(element.id.toString())) {
          return false;
        }
      }

      return true;
    }

    return false;
  }
}
