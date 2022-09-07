import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';
import 'package:jais/components/section_widget.dart';
import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/views/members/login_view.dart';
import 'package:jais/views/members/register_view.dart';
import 'package:notifications/notifications.dart';

class SettingsView extends StatefulWidget {
  final Function()? onLogin;
  final Function()? onLogout;

  const SettingsView({this.onLogin, this.onLogout, super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final notificationsType = Notifications.instance.getType();
    final isDefaultMode = notificationsType == "default";
    final isWatchlistModeOrNeedUpdate =
        notificationsType == "watchlist" && !_same();
    final isDisabledMode = notificationsType == "disable";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SectionWidget(
            icon: const Icon(Icons.flag),
            title: 'Pays',
            widgets: [
              for (final country in CountryMapper.instance.list)
                FullWidget(
                  widget: ElevatedButton(
                    onPressed: null,
                    child: Text('${country.flag}  ${country.name}'),
                  ),
                )
            ],
          ),
          SectionWidget(
            icon: const Icon(Icons.person),
            title: MemberMapper.instance.isConnected()
                ? '${MemberMapper.instance.getMember()?.pseudo}'
                : 'Utilisateur',
            widgets: [
              if (!MemberMapper.instance.isConnected()) ...[
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
              ] else ...[
                FullWidget(
                  widget: ElevatedButton(
                    child: const Text('Déconnexion'),
                    onPressed: () {
                      MemberMapper.instance.setDefaultNotifications();
                      MemberMapper.instance.setMember(null);
                      widget.onLogout?.call();
                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ],
          ),
          if (MemberMapper.instance.isConnected())
            SectionWidget(
              icon: const Icon(Icons.notifications),
              title: 'Notifications',
              widgets: [
                FullWidget(
                  widget: ElevatedButton(
                    onPressed: isDefaultMode
                        ? null
                        : () {
                            MemberMapper.instance.setDefaultNotifications();
                            if (!mounted) return;
                            setState(() {});
                          },
                    child: const Text('Par défaut'),
                  ),
                ),
                FullWidget(
                  widget: ElevatedButton(
                    onPressed: (isDefaultMode ||
                            isWatchlistModeOrNeedUpdate ||
                            isDisabledMode)
                        ? () {
                            MemberMapper.instance.setWatchlistNotifications();
                            if (!mounted) return;
                            setState(() {});
                          }
                        : null,
                    child: Text(
                      'Watchlist${isWatchlistModeOrNeedUpdate ? ' (Mettre à jour)' : ''}',
                    ),
                  ),
                ),
                FullWidget(
                  widget: ElevatedButton(
                    onPressed: isDisabledMode
                        ? null
                        : () {
                            MemberMapper.instance.setDisabledNotifications();
                            if (!mounted) return;
                            setState(() {});
                          },
                    child: const Text('Désactiver'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _same() {
    final topics = Notifications.instance.getTopics();
    final watchlist = MemberMapper.instance.getMember()!.watchlist;
    return MemberMapper.instance.isConnected() &&
        watchlist.length == topics.length &&
        watchlist.every((element) => topics.contains(element.id.toString()));
  }
}
