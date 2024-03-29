import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/mappers/genre_mapper.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class AnimeUpdateView extends StatefulWidget {
  final Anime anime;

  const AnimeUpdateView({required this.anime, super.key});

  @override
  State<AnimeUpdateView> createState() => _AnimeUpdateViewState();
}

class _AnimeUpdateViewState extends State<AnimeUpdateView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Mise à jour de l'anime"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final member = MemberMapper.instance.getMember();

              if (member?.role != MemberRole.admin) {
                return;
              }

              final response = await URL().put(
                getAnimesUpdateUrl(),
                headers: {
                  'Authorization': member?.token ?? '',
                },
                body: jsonEncode(widget.anime.toJson()),
              );

              if (!mounted) return;

              if (!response.isOk) {
                showSnackBar(context, 'Erreur lors de la mise à jour');
                return;
              }

              showSnackBar(context, 'Mise à jour effectuée');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  text: "Informations",
                ),
                Tab(
                  text: "Genres",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.anime.releaseDate,
                          decoration: const InputDecoration(
                            labelText: 'Date de sortie',
                          ),
                          onChanged: (value) =>
                              widget.anime.releaseDate = value,
                        ),
                        TextFormField(
                          initialValue: widget.anime.name,
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                          ),
                          onChanged: (value) => widget.anime.name = value,
                        ),
                        TextFormField(
                          initialValue: widget.anime.url,
                          decoration: const InputDecoration(
                            labelText: 'URL',
                          ),
                          onChanged: (value) => widget.anime.url = value,
                        ),
                        TextFormField(
                          initialValue: widget.anime.image,
                          decoration: const InputDecoration(
                            labelText: 'Image',
                          ),
                          onChanged: (value) => widget.anime.image = value,
                        ),
                        TextFormField(
                          initialValue: widget.anime.description,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          minLines: 3,
                          maxLines: 10,
                          onChanged: (value) =>
                              widget.anime.description = value,
                        ),
                      ].superJoin(const SizedBox(height: 16)).toList(),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Rechercher',
                          ),
                          onChanged: (value) => setState(() {
                            _searchText = value;
                          }),
                        ),
                        ...GenreMapper.instance.list
                            .map(
                              (genre) => CheckboxListTile(
                                title: Text(genre.fr),
                                activeColor: Theme.of(context).primaryColor,
                                value: widget.anime.genres
                                    .map<int>((e) => e.id)
                                    .toList()
                                    .contains(genre.id),
                                onChanged: (value) {
                                  if (value == true) {
                                    widget.anime.genres.add(genre);
                                  } else {
                                    widget.anime.genres.removeWhere(
                                      (e) => e.id == genre.id,
                                    );
                                  }

                                  setState(() {});
                                },
                              ),
                            )
                            .where(
                              (CheckboxListTile element) =>
                                  (_searchText.isNotEmpty &&
                                      _searchText.toLowerCase().startsWith(
                                            (element.title as Text?)
                                                    ?.data
                                                    ?.toLowerCase() ??
                                                '',
                                          )) ||
                                  _searchText.isEmpty,
                            ),
                      ].superJoin(const SizedBox(height: 16)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
