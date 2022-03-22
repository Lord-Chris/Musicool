import 'package:flutter/material.dart';

import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/constants/textstyles.dart';
import 'package:musicool/ui/shared/_shared.dart';
import 'package:musicool/ui/views/base_view/base_view.dart';
import 'package:musicool/ui/views/search/search_model.dart';
import 'package:musicool/ui/widget/_widgets.dart';

class SearchView<T extends Object> extends StatelessWidget {
  final Object? type;
  SearchView({Key? key, this.type}) : super(key: key);
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    return BaseView<SearchModel>(
      builder: (context, model, child) {
        return AppBaseView(
          child: Column(
            children: [
              const YMargin(10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: IconButton(
                      onPressed: () => model.navigateBack(),
                      icon: const Icon(Icons.chevron_left),
                      iconSize: 35,
                      color: AppColors.grey,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      searchLabel: "Enter Keyword",
                      controller: _textController,
                      onChanged: (val) => model.onChanged(val, type),
                      enabled: true,
                      suffixIcon: InkWell(
                        onTap: () => _textController.clear(),
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  const XMargin(20),
                ],
              ),
              const YMargin(10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      "Search History",
                      style: kBodyStyle,
                    ),
                    const XMargin(7),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                      child:
                          const Icon(Icons.more_horiz, color: AppColors.black),
                    ),
                    const Spacer(),
                    Text(
                      "CLEAR",
                      style: kSubBodyStyle.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: type == null
                        // ? HomeSearch(model: model):
                        ||
                        type == Track
                    ? ListView.builder(
                        itemCount: model.songs.length,
                        itemBuilder: (__, index) {
                          return MyMusicCard(
                            music: model.songs[index],
                          );
                        },
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: _deviceWidth / _deviceHeight * 1.65,
                          crossAxisSpacing: (_deviceWidth * 0.03),
                          mainAxisSpacing: 25,
                        ),
                        itemCount: type == Album
                            ? model.albums.length
                            : model.artists.length,
                        itemBuilder: (__, index) {
                          dynamic data = type == Album
                              ? model.albums[index]
                              : model.artists[index];
                          return MediaInfoCard(
                            onTap: () => type == Album
                                ? model.onAlbumTap(data)
                                : model.onArtistTap(data),
                            title: type == Album ? data.title! : data.name!,
                            subTitle: "${data.numberOfSongs} song" +
                                (data.numberOfSongs! > 1 ? "s" : ""),
                            art: data.artwork,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeSearch extends StatefulWidget {
  final SearchModel model;
  const HomeSearch({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final list = List.generate(3, (index) => false);
  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          // ExpansionTile(
          //     backgroundColor: AppColors.white,
          //     // : true,
          //     initiallyExpanded: false,
          //     title: const Text(
          //       "Songs",
          //       style: kBodyStyle,
          //     ),
          //     children: widget.model.songs
          //         .map((e) => MyMusicCard(music: e))
          //         .toList()),
          ExpansionPanelList(
            dividerColor: Colors.white,
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (index, val) =>
                setState(() => list[index] = !list[index]),
            children: [
              ExpansionPanel(
                backgroundColor: AppColors.white,
                canTapOnHeader: true,
                isExpanded: list[0],
                headerBuilder: (_, val) => const Text(
                  "Songs",
                  style: kBodyStyle,
                ),
                body: ListView.builder(
                  itemCount: widget.model.songs.length,
                  shrinkWrap: true,
                  itemBuilder: (__, index) {
                    return MyMusicCard(
                      music: widget.model.songs[index],
                    );
                  },
                ),
              ),
              ExpansionPanel(
                backgroundColor: AppColors.white,
                isExpanded: list[1],
                canTapOnHeader: true,
                headerBuilder: (_, val) => const Text(
                  "Artist",
                  style: kBodyStyle,
                ),
                body: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: _deviceWidth / _deviceHeight * 1.65,
                    crossAxisSpacing: (_deviceWidth * 0.03),
                    mainAxisSpacing: 25,
                  ),
                  itemCount: widget.model.artists.length,
                  itemBuilder: (__, index) {
                    Artist data = widget.model.artists[index];
                    return MediaInfoCard(
                      onTap: () => widget.model.onArtistTap(data),
                      title: data.name!,
                      subTitle: "${data.numberOfSongs} song" +
                          (data.numberOfSongs! > 1 ? "s" : ""),
                      art: data.artwork,
                    );
                  },
                ),
              ),
              ExpansionPanel(
                backgroundColor: AppColors.white,
                canTapOnHeader: true,
                isExpanded: list[2],
                headerBuilder: (_, val) => Row(
                  children: [
                    const Text(
                      "Albums",
                      style: kBodyStyle,
                    ),
                    const Spacer(),
                    Icon(
                      list[2]
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: AppColors.darkMain,
                    ),
                  ],
                ),
                body: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: _deviceWidth / _deviceHeight * 1.65,
                    crossAxisSpacing: (_deviceWidth * 0.03),
                    mainAxisSpacing: 25,
                  ),
                  itemCount: widget.model.albums.length,
                  itemBuilder: (__, index) {
                    Album data = widget.model.albums[index];
                    return MediaInfoCard(
                      onTap: () => widget.model.onAlbumTap(data),
                      title: data.title!,
                      subTitle: "${data.numberOfSongs} song" +
                          (data.numberOfSongs! > 1 ? "s" : ""),
                      art: data.artwork,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
