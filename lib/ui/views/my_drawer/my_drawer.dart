import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:music_player/ui/views/base_view/base_view.dart';
import 'package:music_player/ui/views/my_drawer/my_drawer_model.dart';
import 'package:music_player/ui/favorites.dart';
import 'package:music_player/ui/views/playing/playing.dart';
import 'package:music_player/ui/views/search/search.dart';
import 'package:music_player/ui/widget/icon.dart';

import '../../constants/unique_keys.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MyDrawerModel>(builder: (context, model, child) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: MyIcon(isInverted: true,)
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
            ),
            model.nowPlaying != null
                ? ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('Now Playing'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (__) => Playing(
                            songId: model.nowPlaying.id,
                            play: false,
                          )));
                    },
                  )
                : Container(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (__) => Search()));
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.heart),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (__) => FavoritesScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shuffle),
              title: Text('Shuffle'),
              trailing: Switch(
                value: model.shuffle,
                onChanged: (val) => model.toggleShuffle(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Dark Mode'),
              trailing: Switch(
                key: UniqueKeys.DARKMODE,
                value: model.isDarkMode,
                onChanged: (val) => model.toggleDarkMode(),
              ),
            ),
            Divider(),
          ],
        ),
      );
    });
  }
}