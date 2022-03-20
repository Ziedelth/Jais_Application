import 'package:flutter/material.dart';
import 'package:jais/models/anime_details.dart';
import 'package:jais/utils/main_color.dart';
import 'package:jais/utils/user.dart';

class AnimeDetailsHeader extends StatefulWidget {
  const AnimeDetailsHeader(this._callback, this._animeDetails, {Key? key})
      : super(key: key);

  final VoidCallback _callback;
  final AnimeDetails _animeDetails;

  @override
  _AnimeDetailsHeaderState createState() => _AnimeDetailsHeaderState();
}

class _AnimeDetailsHeaderState extends State<AnimeDetailsHeader> {
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  icon: Icon(Icons.help),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: MainColor.mainColorO),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (widget._animeDetails.genres != null)
                                Column(
                                  children: [
                                    Text(
                                      widget._animeDetails.genres!,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Padding(
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
                              Text(widget._animeDetails.description ??
                                  'No description'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (User.isConnected)
          Expanded(
            child: IconButton(
              icon: Icon(
                _notifications
                    ? Icons.notifications_on
                    : Icons.notifications_off,
                color: _notifications ? Colors.green : Colors.red,
              ),
              onPressed: () => setState(() => _notifications = !_notifications),
            ),
          ),
      ],
    );
  }
}
