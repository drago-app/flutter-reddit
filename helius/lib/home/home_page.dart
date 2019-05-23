import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helius/app_provider.dart';
import 'package:helius/home/subreddit_tile_model.dart';
import 'product_row_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'subreddit_list_item.dart';


class HomePage extends StatelessWidget {
  List subredditTiles = [
    SubredditTile(
        icon: CupertinoIcons.home,
        iconColor: CupertinoColors.destructiveRed,
        subreddit: 'home',
        subtitle: 'Posts from subscriptions',
        title: 'Home'),
    SubredditTile(
        icon: CupertinoIcons.add,
        iconColor: CupertinoColors.activeBlue,
        subreddit: 'home',
        subtitle: 'Most popular posts across Reddit',
        title: 'Popular Posts'),
    SubredditTile(
        icon: CupertinoIcons.collections_solid,
        iconColor: CupertinoColors.activeGreen,
        subreddit: 'home',
        subtitle: 'Posts across all subreddits',
        title: 'All Posts'),
    SubredditTile(
        icon: CupertinoIcons.add,
        iconColor: CupertinoColors.lightBackgroundGray,
        subreddit: 'home',
        subtitle: 'Posts from moderated subreddits',
        title: 'Moderator Posts')
  ];

  HomePage(context);

  @override
  Widget build(BuildContext context) {
    final bloc = AppProvider.of(context);

    return _homePageTab(context, bloc);
  }

  Widget _moderationList(BuildContext context, bloc) {
    return StreamBuilder(
        stream: bloc.myModerations,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverList(
              delegate: SliverChildListDelegate([]),
            );
          } else if (snapshot.hasError) {
            return SliverList(
              delegate: SliverChildListDelegate([]),
            );
          } else {
            return new SliverStickyHeaderBuilder(
              builder: (context, state) =>
                  _header(context, state, 'moderator'),
              sliver: new SliverList(
                delegate: new SliverChildBuilderDelegate(
                  (context, i) => SubredditListItem(
                    index: i,
                    lastItem: i == snapshot.data.length -1,
                    title: snapshot.data[i].displayName
                   ),
                  childCount: snapshot.data.length,
                ),
              ),
            );
          }
        });
  }



  Widget _header(
      BuildContext context, SliverStickyHeaderState state, String title) {
    return Container(
      height: 20.0,
      color: (state.isPinned)
          ? CupertinoColors.activeBlue
          : CupertinoColors.darkBackgroundGray,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        '${title.toUpperCase()}',
        style: const TextStyle(color: CupertinoColors.lightBackgroundGray),
      ),
    );
  }


  Widget _textInput() {
    return CupertinoTextField(
      autofocus: false,
      placeholder: "Search",
      prefix: Icon(CupertinoIcons.search),
      suffix: AnimatedContainer(
        duration: Duration(milliseconds: 5000),
        child: CupertinoButton(
          child: Text('Cancel'),
          onPressed: () {}, //TODO
        ),
      ),
      suffixMode: OverlayVisibilityMode.editing,
    );
  }

  Widget _homePageNavigationBar(BuildContext context) {
    return CupertinoSliverNavigationBar(
      automaticallyImplyLeading: false,
      automaticallyImplyTitle: false,
      largeTitle: _textInput(),
      leading: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Icon(CupertinoIcons.add),
        onPressed: () {}, //TODO
      ),
      middle: Text('Home'),
      trailing: CupertinoButton(
        padding: EdgeInsets.all(0),
        child: Text("Edit"),
        onPressed: () {}, //TODO
      ),
    );
  }

  Widget _topListView(BuildContext context) {
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.only(top: 0, bottom: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < subredditTiles.length) {
              return Material(
                  child: InkWell(
                onTap: () {
                  print('$index');
                },
                child: SubredditTileItem(
                  index: index,
                  subredditTile: subredditTiles[index],
                  lastItem: index == subredditTiles.length - 1,
                ),
              ));
            }
            return null;
          },
        ),
      ),
    );
  }

  _subscriptionList(context, bloc) {
    const alphabet = [
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z"
    ];
    List<Widget> answer = [];

    alphabet.forEach((letter) {
      var sliver = StreamBuilder(
          stream: bloc.mySubscriptions,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SliverList(
                delegate: SliverChildListDelegate([]),
              );
            } else if (snapshot.hasError) {
              return SliverList(
                delegate: SliverChildListDelegate([]),
              );
            } else {
              int first = snapshot.data.indexWhere((sub)=> sub.displayName[0].toLowerCase()== letter.toLowerCase());
              int last = snapshot.data.lastIndexWhere((sub)=> sub.displayName[0].toLowerCase()== letter.toLowerCase());
              // print('${first.toString()} --- ${last.toString()}');

              if(first == -1 || last == -1) {
                return SliverList(
                delegate: SliverChildListDelegate([]),
              );
              } else {
                var sublist = snapshot.data.sublist(first, last);

              // print('$letter --- ${first.toString()} --- ${last.toString()} --- ${sublist.length} --- ${snapshot.data.length}');
              // if(letter == 'y') {
              //   sublist.forEach((a) => print(a.displayName));
              // }
              

              return SliverStickyHeaderBuilder(
                builder: (context, state) => _header(context, state, letter),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: CupertinoColors.destructiveRed, 
                        child: Text('Unsubscribe', style: TextStyle(color: CupertinoColors.white),)) ,
                      key: Key(sublist[i].displayName),
                      child: SubredditListItem(
                        index: i,
                        lastItem: i == sublist.length -1,
                        title: sublist[i].displayName
                      )
                    ), 
                    childCount: sublist.length
                   ),
              ));
              }
            }
          });
          answer.add(sliver);
    });

    return answer;
  }

  /* ======= PAGES ======= */

  Widget _homePageTab(BuildContext context, bloc) {
    List<Widget> _slivers = [];

    _slivers.add(_homePageNavigationBar(context));
    _slivers.add(MediaQuery.removePadding(
      context: context,
      child: _topListView(context),
      removeBottom: true,
    ));
    _slivers.add(_moderationList(context, bloc));
    _slivers.addAll(_subscriptionList(context, bloc));
    return CustomScrollView(slivers: _slivers);
  }
}
