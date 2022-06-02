import 'package:flutter/material.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/member_role.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/updates/scan_update_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanWidget extends StatelessWidget {
  final Scan scan;

  const ScanWidget({required this.scan, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(scan.url)),
      onLongPress: () {
        if (!member_mapper.isConnected()) {
          return;
        }

        final member = member_mapper.getMember()!;

        if (member.role != MemberRole.admin) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScanUpdateView(
              scan: scan,
              member: member,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PlatformWidget(scan.platform),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    scan.anime.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${scan.episodeType.fr} ${scan.number} ${scan.langType.fr} ',
            ),
            const SizedBox(height: 5),
            Text(
              'Il y a ${printTimeSince(DateTime.parse(scan.releaseDate))}',
            ),
          ],
        ),
      ),
    );
  }
}
