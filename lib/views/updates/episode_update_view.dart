import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/mappers/episode_type_mapper.dart';
import 'package:jais/mappers/lang_type_mapper.dart';
import 'package:jais/mappers/platform_mapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/member.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class EpisodeUpdateView extends StatefulWidget {
  final Member member;
  final Episode episode;

  const EpisodeUpdateView({
    required this.member,
    required this.episode,
    super.key,
  });

  @override
  _EpisodeUpdateViewState createState() => _EpisodeUpdateViewState();
}

class _EpisodeUpdateViewState extends State<EpisodeUpdateView> {
  final PlatformMapper platformMapper = PlatformMapper();
  final EpisodeTypeMapper episodeTypeMapper = EpisodeTypeMapper();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        platformMapper.update(),
        episodeTypeMapper.update(),
        LangTypeMapper.instance.update(),
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
        title: const Text("Mise à jour de l'épisode"),
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
                getEpisodesUpdateUrl(),
                headers: {
                  'Authorization': widget.member.token ?? '',
                },
                body: jsonEncode(widget.episode.toJson()),
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
                value: widget.episode.platform.id,
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
                  widget.episode.platform = platformMapper.list.firstWhere(
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
                value: widget.episode.episodeType.id,
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
                  widget.episode.episodeType =
                      episodeTypeMapper.list.firstWhere(
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
                value: widget.episode.langType.id,
                items: LangTypeMapper.instance.list
                    .map<DropdownMenuItem<int>>(
                      (langType) => DropdownMenuItem<int>(
                        value: langType.id,
                        child: Text(langType.fr),
                      ),
                    )
                    .toList(),
                onChanged: (langType) {
                  if (langType == null) return;
                  widget.episode.langType =
                      LangTypeMapper.instance.list.firstWhere(
                    (p) => p.id == langType,
                  );
                  if (!mounted) return;
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.episode.releaseDate,
                decoration: const InputDecoration(
                  labelText: 'Date de sortie',
                ),
                onChanged: (value) => widget.episode.releaseDate = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '${widget.episode.season}',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Saison',
                ),
                onChanged: (value) =>
                    widget.episode.season = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '${widget.episode.number}',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Numéro',
                ),
                onChanged: (value) =>
                    widget.episode.number = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.episode.episodeId,
                decoration: const InputDecoration(
                  labelText: 'ID',
                ),
                onChanged: (value) => widget.episode.episodeId = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.episode.title,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                ),
                onChanged: (value) => widget.episode.title = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.episode.url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                ),
                onChanged: (value) => widget.episode.url = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.episode.image,
                decoration: const InputDecoration(
                  labelText: 'Image',
                ),
                onChanged: (value) => widget.episode.image = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '${widget.episode.duration}',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Durée',
                ),
                onChanged: (value) =>
                    widget.episode.duration = int.tryParse(value) ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
