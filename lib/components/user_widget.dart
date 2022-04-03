import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/user.dart';
import 'package:jais/utils/utils.dart';

class UserWidget extends StatefulWidget {
  final User user;

  const UserWidget(this.user, {Key? key}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl:
              'https://ziedelth.fr/${widget.user.image ?? 'images/default_member.jpg'}',
          imageBuilder: (context, imageProvider) => RoundBorderWidget(
            widget: Image(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
          placeholder: (context, url) => const Skeleton(height: 200),
          errorWidget: (context, url, error) => const Skeleton(height: 200),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.user.role == 100)
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.red,
                  ),
                ),
              Text(
                widget.user.pseudo,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Inscription il y a ${printTimeSince(DateTime.tryParse(widget.user.timestamp))}',
          ),
        ),
        Text(
          widget.user.about ?? '',
        ),
      ],
    );
  }
}
