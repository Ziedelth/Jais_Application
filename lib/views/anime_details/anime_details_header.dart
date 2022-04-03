import 'package:flutter/material.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/utils/notifications.dart';

class AnimeDetailsHeader extends StatefulWidget {
  const AnimeDetailsHeader(this._callback, this._animeDetails, {Key? key})
      : super(key: key);

  final VoidCallback _callback;
  final AnimeDetails _animeDetails;

  @override
  _AnimeDetailsHeaderState createState() => _AnimeDetailsHeaderState();
}

class _AnimeDetailsHeaderState extends State<AnimeDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    final bool _hasTopic = hasTopic(widget._animeDetails.code);

    return Row(
      children: [
        BackButton(
          onPressed: widget._callback,
        ),
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget._animeDetails.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  icon: const Icon(Icons.help),
                  onPressed: () => show(
                    context,
                    widget: Column(
                      children: [
                        if (widget._animeDetails.genres != null)
                          Column(
                            children: [
                              Text(
                                widget._animeDetails.genres!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Divider(
                                  height: 5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        Text(
                          widget._animeDetails.description ?? 'No description',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isConnected())
          Expanded(
            child: IconButton(
              icon: Icon(
                _hasTopic ? Icons.notifications_on : Icons.notifications_off,
                color: _hasTopic ? Colors.green : Colors.red,
              ),
              onPressed: () {
                if (_hasTopic) {
                  removeTopic(widget._animeDetails.code);
                  setState(() {});
                  return;
                }

                if (!_hasTopic) {
                  addTopic(widget._animeDetails.code);
                  setState(() {});
                  return;
                }
              },
            ),
          ),
      ],
    );
  }
}
