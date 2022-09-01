import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Widget ListBuilderCallBack(BuildContext context, int index);

class PullToRefreshListView extends StatefulWidget {
  final int itemCount;
  final bool? shrinkWrap;
  final VoidCallback onRefresh;
  final ListBuilderCallBack builder;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Axis? scrollDirection;

  PullToRefreshListView({
    required this.itemCount,
    this.shrinkWrap = false,
    required this.builder,
    required this.onRefresh,
    this.padding = const EdgeInsets.only(bottom: 5.0),
    this.controller,
    this.physics,
    this.scrollDirection,
  });

  @override
  _PullToRefreshListViewState createState() => _PullToRefreshListViewState();
}

class _PullToRefreshListViewState extends State<PullToRefreshListView> {

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CustomScrollView(
        controller: widget.controller,
        physics: widget.physics,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              widget.onRefresh();
            },
            refreshIndicatorExtent: 50.0,
            refreshTriggerPullDistance: 100.0,
          ),
          SliverPadding(
            padding: widget.padding,
            sliver: SliverSafeArea(
              bottom: true,
              top:false,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  widget.builder,
                  childCount: widget.itemCount,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        child: RefreshIndicator(
          child: ListView.builder(
            shrinkWrap: widget.shrinkWrap!,
            physics: widget.physics,
            padding: widget.padding,
            scrollDirection: widget.scrollDirection ?? Axis.vertical,
            itemCount: widget.itemCount,
            itemBuilder: widget.builder,
            controller: widget.controller,
          ),
          onRefresh: () async {
            widget.onRefresh();
          },
        ),
        alignment: Alignment.center,
      );
    }
  }
}
