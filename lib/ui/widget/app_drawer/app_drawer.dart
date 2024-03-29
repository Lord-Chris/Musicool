import 'package:flutter_svg/svg.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/albums/albums.dart';
import 'package:musicool/ui/views/artists/artists.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/favourites/favourites.dart';
import 'package:musicool/ui/views/home/home.dart';
import 'package:musicool/ui/views/songs/songs.dart';

import '../_widgets.dart';

class AppDrawer<T extends Widget> extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppDrawerModel>(
      builder: (context, model, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(70)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Drawer(
            backgroundColor: AppColors.darkMain,
            child: Column(
              children: [
                const Spacer(flex: 2),
                const AppIcon(size: 12),
                const YMargin(10),
                Center(
                  child: Text(
                    'Musicool',
                    style: TextStyle(
                      fontFamily: "House Music",
                      fontSize: 20.sm,
                      height: 1.15,
                      color: AppColors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerHome,
                    color: T == HomeView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Home',
                    style: kBodyStyle.copyWith(
                      color: T == HomeView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: T == HomeView ? AppColors.white : AppColors.grey,
                  ),
                  onTap: () {
                    if (T == HomeView) model.navigateBack();
                    if (T != HomeView) {
                      model.navigateBack();
                      model.navigateBack();
                    }
                  },
                ),
                const YMargin(15),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerSongs,
                    color: T == SongsView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Songs',
                    style: kBodyStyle.copyWith(
                      color: T == SongsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: T == SongsView ? AppColors.white : AppColors.grey,
                  ),
                  onTap: () {
                    if (T == SongsView) {
                      model.navigateBack();
                    } else if (T == HomeView) {
                      model.navigateTo(Routes.songsRoute);
                    } else if (T != SongsView) {
                      model.navigateOff(Routes.songsRoute);
                    }
                  },
                ),
                const YMargin(15),
                ListTile(
                  leading: CircleAvatar(
                    radius: 13,
                    backgroundColor:
                        T == AlbumsView ? AppColors.white : AppColors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: AppColors.darkMain,
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color:
                            T == AlbumsView ? AppColors.white : AppColors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    'Albums',
                    style: kBodyStyle.copyWith(
                      color: T == AlbumsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: T == AlbumsView ? AppColors.white : AppColors.grey,
                  ),
                  onTap: () {
                    if (T == AlbumsView) {
                      model.navigateBack();
                    } else if (T == HomeView) {
                      model.navigateTo(Routes.albumsRoute);
                    } else if (T != AlbumsView) {
                      model.navigateOff(Routes.albumsRoute);
                    }
                  },
                ),
                const YMargin(15),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerArtist,
                    color: T == ArtistsView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Artists',
                    style: kBodyStyle.copyWith(
                      color:
                          T == ArtistsView ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: T == ArtistsView ? AppColors.white : AppColors.grey,
                  ),
                  onTap: () {
                    if (T == ArtistsView) {
                      model.navigateBack();
                    } else if (T == HomeView) {
                      model.navigateTo(Routes.artistsRoute);
                    } else if (T != ArtistsView) {
                      model.navigateOff(Routes.artistsRoute);
                    }
                  },
                ),
                const YMargin(15),
                ListTile(
                  leading: SvgPicture.asset(
                    AppAssets.drawerFavourites,
                    color:
                        T == FavouritesView ? AppColors.white : AppColors.grey,
                  ),
                  title: Text(
                    'Favourites',
                    style: kBodyStyle.copyWith(
                      color: T == FavouritesView
                          ? AppColors.white
                          : AppColors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color:
                        T == FavouritesView ? AppColors.white : AppColors.grey,
                  ),
                  onTap: () {
                    if (T == FavouritesView) {
                      model.navigateBack();
                    } else if (T == HomeView) {
                      model.navigateTo(Routes.favouritesRoute);
                    } else if (T != FavouritesView) {
                      model.navigateOff(Routes.favouritesRoute);
                    }
                  },
                ),
                const Spacer(flex: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
