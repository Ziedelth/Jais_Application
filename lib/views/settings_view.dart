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

    final bool hasTopic = JNotifications.hasTopic("animes");

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
                  onPressed: () => JDialog.show(
                    context,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://ziedelth.fr/${UserMapper.user?.image ?? 'images/default_member.jpg'}',
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
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '${UserMapper.user?.pseudo}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Inscription il y a ${Utils.printTimeSince(DateTime.tryParse(UserMapper.user?.timestamp ?? '0'))}',
                        ),
                      ),
                      Text(
                        '${UserMapper.user?.about ?? ''}',
                      ),
                    ],
                  ),
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
        if (UserMapper.isConnected())
          SectionWidget(
            icon: Icon(Icons.notifications),
            title: 'Notifications',
            widgets: [
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Par défaut'),
                  onPressed: hasTopic
                      ? null
                      : () {
                          JNotifications.removeAllTopics();
                          JNotifications.addTopic("animes");
                          setState(() {});
                        },
                  onLongPress: hasTopic
                      ? null
                      : () => JDialog.show(
                            context,
                            children: [
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
                                  "Ce mode vous avertit de toutes les mises à jour récentes, qu'il s'agisse d'épisodes ou de scans."),
                            ],
                          ),
                ),
              ),
              FullWidget(
                widget: ElevatedButton(
                  child: Text('Personnalisé'),
                  onPressed: hasTopic
                      ? () {
                          JNotifications.removeAllTopics();
                          setState(() {});
                        }
                      : null,
                  onLongPress: hasTopic
                      ? () => JDialog.show(
                            context,
                            children: [
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
                                  "Choissisez les animes dont vous souhaitez être informé à chaque mise à jour récentes."),
                            ],
                          )
                      : null,
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
                onPressed: JaisAd.showVideo,
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
