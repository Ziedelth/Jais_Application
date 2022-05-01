import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/member.dart';

class MemberView extends StatelessWidget {
  final Member member;

  const MemberView({required this.member, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              member.pseudo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              member_mapper.roleToString(member.role),
            ),
            const SizedBox(height: 5),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(height: 5),
            const Text(
              'Watchlist :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AnimeList(
                children: buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildList() {
    return member.watchlist.map<Widget>(
      (e) {
        // Copy e
        final anime = e.copyWith(
          name: utf8.decode(e.name.codeUnits),
          description:
              (e.description != null && e.description?.isNotEmpty == true)
                  ? utf8.decode(e.description!.codeUnits)
                  : null,
        );

        return AnimeWidget(
          anime: anime,
        );
      },
    ).toList();
  }
}
