import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/full_button.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/utils/jais_ad.dart';
import 'package:jais/utils/notifications.dart';
import 'package:jais/utils/utils.dart';
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

    final bool _hasTopic = hasTopic("animes");

    return Column(
      children: [
        if (!isConnected())
          SectionWidget(
            icon: const Icon(Icons.person),
            title: 'Identification',
            widgets: [
              const FullWidget(
                widget: ElevatedButton(
                  onPressed: null,
                  child: Text('Inscription'),
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
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://ziedelth.fr/${user?.image ?? 'images/default_member.jpg'}',
                        imageBuilder: (context, imageProvider) =>
                            RoundBorderWidget(
                          widget: Image(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                        placeholder: (context, url) =>
                            const Skeleton(height: 200),
                        errorWidget: (context, url, error) =>
                            const Skeleton(height: 200),
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '${user?.pseudo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Inscription il y a ${printTimeSince(DateTime.tryParse(user?.timestamp ?? '0'))}',
                        ),
                      ),
                      Text(
                        user?.about ?? '',
                      ),
                    ],
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
                            children: [
                              const Text(
                                'Mode par défaut des notifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              const Text(
                                "Ce mode vous avertit de toutes les mises à jour récentes, qu'il s'agisse d'épisodes ou de scans.",
                              ),
                            ],
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
                            children: [
                              const Text(
                                'Personnalisation des notifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              const Text(
                                "Choissisez les animes dont vous souhaitez être informé à chaque mise à jour récentes.",
                              ),
                            ],
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
