import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/mappers/episode_type_mapper.dart';
import 'package:jais/mappers/lang_type_mapper.dart';
import 'package:jais/mappers/platform_mapper.dart';
import 'package:jais/models/member.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class ScanUpdateView extends StatefulWidget {
  final Member member;
  final Scan scan;

  const ScanUpdateView({
    required this.member,
    required this.scan,
    Key? key,
  }) : super(key: key);

  @override
  _ScanUpdateViewState createState() => _ScanUpdateViewState();
}

class _ScanUpdateViewState extends State<ScanUpdateView> {
  final PlatformMapper platformMapper = PlatformMapper();
  final EpisodeTypeMapper episodeTypeMapper = EpisodeTypeMapper();
  final LangTypeMapper langTypeMapper = LangTypeMapper();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        platformMapper.update(),
        episodeTypeMapper.update(),
        langTypeMapper.update(),
      ]);

      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Mise à jour du scan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (widget.member.role != MemberRole.admin) {
                return;
              }

              logger.debug("Sending update");
              final response = await URL().put(
                'https://api.ziedelth.fr/v1/scans/update',
                headers: {
                  'Authorization': widget.member.token!,
                },
                body: jsonEncode(widget.scan.toJson()),
              );

              if (!mounted) return;

              if (response == null || response.statusCode != 200) {
                logger.warning(
                  "Failed to send update (${response?.statusCode}) : ${response?.body}",
                );

                showSnackBar(context, 'Erreur lors de la mise à jour');
                return;
              }

              logger.debug("Update sent");
              showSnackBar(context, 'Mise à jour effectuée');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Plateforme',
                ),
                value: widget.scan.platform.id,
                items: platformMapper.list
                    .map<DropdownMenuItem<int>>(
                      (platform) => DropdownMenuItem<int>(
                        value: platform.id,
                        child: Text(platform.name),
                      ),
                    )
                    .toList(),
                onChanged: (platform) {
                  if (platform == null) return;
                  widget.scan.platform = platformMapper.list.firstWhere(
                    (p) => p.id == platform,
                  );
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
                value: widget.scan.episodeType.id,
                items: episodeTypeMapper.list
                    .map<DropdownMenuItem<int>>(
                      (episodeType) => DropdownMenuItem<int>(
                        value: episodeType.id,
                        child: Text(episodeType.fr),
                      ),
                    )
                    .toList(),
                onChanged: (episodeType) {
                  if (episodeType == null) return;
                  widget.scan.episodeType = episodeTypeMapper.list.firstWhere(
                        (p) => p.id == episodeType,
                  );
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Langue',
                ),
                value: widget.scan.langType.id,
                items: langTypeMapper.list
                    .map<DropdownMenuItem<int>>(
                      (langType) => DropdownMenuItem<int>(
                        value: langType.id,
                        child: Text(langType.fr),
                      ),
                    )
                    .toList(),
                onChanged: (langType) {
                  if (langType == null) return;
                  widget.scan.langType = langTypeMapper.list.firstWhere(
                        (p) => p.id == langType,
                  );
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.scan.releaseDate,
                decoration: const InputDecoration(
                  labelText: 'Date de sortie',
                ),
                onChanged: (value) => widget.scan.releaseDate = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '${widget.scan.number}',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Numéro',
                ),
                onChanged: (value) =>
                    widget.scan.number = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.scan.url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                ),
                onChanged: (value) => widget.scan.url = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
