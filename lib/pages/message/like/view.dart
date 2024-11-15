import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/msg/like.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class MessageLikePage extends StatefulWidget {
  const MessageLikePage({super.key});

  @override
  State<MessageLikePage> createState() => _MessageLikePageState();
}

class _MessageLikePageState extends State<MessageLikePage> {
  final MessageLikeController _messageLikeCtr =
      Get.put(MessageLikeController());
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageLikeCtr.queryMessageLike();
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
            _messageLikeCtr.queryMessageLike(type: 'onLoad');
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收到的赞'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _messageLikeCtr.queryMessageLike(type: 'init');
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const SizedBox();
              }
              if (snapshot.data['status']) {
                final likeItems = _messageLikeCtr.likeItems;
                return Obx(
                  () => ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) => LikeItem(
                      item: likeItems[index],
                      index: index,
                      messageLikeCtr: _messageLikeCtr,
                    ),
                    itemCount: likeItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 66,
                        endIndent: 14,
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                );
              } else {
                // 请求错误
                return CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: snapshot.data['msg'],
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _messageLikeCtr.queryMessageLike();
                        });
                      },
                    )
                  ],
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class LikeItem extends StatelessWidget {
  final MessageLikeItem item;
  final int index;
  final MessageLikeController messageLikeCtr;

  const LikeItem(
      {super.key,
      required this.item,
      required this.index,
      required this.messageLikeCtr});

  @override
  Widget build(BuildContext context) {
    Color outline = Theme.of(context).colorScheme.outline;
    final nickNameList = item.users!.map((e) => e.nickname).take(2).toList();
    int usersLen = item.users!.length > 3 ? 3 : item.users!.length;
    final String bvid = item.item!.uri!.split('/').last;
    // 页码
    final String page =
        item.item!.nativeUri!.split('page=').last.split('&').first;
    // 根评论id
    final String commentRootId =
        item.item!.nativeUri!.split('comment_root_id=').last.split('&').first;
    // 二级评论id
    final String commentSecondaryId =
        item.item!.nativeUri!.split('comment_secondary_id=').last;

    return InkWell(
      onTap: () async {
        try {
          final int cid = await SearchHttp.ab2c(bvid: bvid);
          final String heroTag = Utils.makeHeroTag(bvid);
          Get.toNamed<dynamic>(
            '/video?bvid=$bvid&cid=$cid',
            arguments: <String, String?>{
              'pic': '',
              'heroTag': heroTag,
            },
          );
        } catch (_) {
          SmartDialog.showToast('视频可能失效了');
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (usersLen == 1) {
                      final String heroTag =
                          Utils.makeHeroTag(item.users!.first.mid);
                      Get.toNamed('/member?mid=${item.users!.first.mid}',
                          arguments: {
                            'face': item.users!.first.avatar,
                            'heroTag': heroTag
                          });
                    } else {
                      messageLikeCtr.expandedUsersAvatar(index);
                    }
                  },
                  // 多个头像层叠
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        for (var i = 0; i < usersLen; i++)
                          Positioned(
                            top: i % 2 * (50 / (usersLen >= 2 ? 2 : 1)),
                            left: i / 2 * (50 / (usersLen >= 2 ? 2 : 1)),
                            child: NetworkImgLayer(
                              width: 50 / (usersLen >= 2 ? 2 : 1),
                              height: 50 / (usersLen >= 2 ? 2 : 1),
                              type: 'avatar',
                              src: item.users![i].avatar,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(text: nickNameList.join('、')),
                        const TextSpan(text: ' '),
                        if (item.users!.length > 1)
                          TextSpan(
                            text: '等总计${item.users!.length}人',
                            style: TextStyle(color: outline),
                          ),
                        TextSpan(
                          text: '赞了我的评论',
                          style: TextStyle(color: outline),
                        ),
                      ])),
                      const SizedBox(height: 4),
                      Text(
                        Utils.dateFormat(item.likeTime!, formatType: 'detail'),
                        style: TextStyle(color: outline),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 25),
                if (item.item!.type! == 'reply')
                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      item.item!.title!,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 12, letterSpacing: 0.3),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item.item!.type! == 'video')
                  NetworkImgLayer(
                    width: 60,
                    height: 60,
                    src: item.item!.image,
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: item.isExpand ? Get.size.width - 74 : 0,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: ListView.builder(
                itemCount: item.users!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(i == 0 ? 12 : 4, 8, 4, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final String heroTag =
                                Utils.makeHeroTag(item.users![i].mid);
                            Get.toNamed(
                              '/member?mid=${item.users![i].mid}',
                              arguments: {
                                'face': item.users![i].avatar,
                                'heroTag': heroTag
                              },
                            );
                          },
                          child: NetworkImgLayer(
                            width: 42,
                            height: 42,
                            type: 'avatar',
                            src: item.users![i].avatar,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 68,
                          child: Text(
                            textAlign: TextAlign.center,
                            item.users![i].nickname!,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: outline),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                messageLikeCtr.expandedUsersAvatar(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: item.isExpand ? 74 : 0,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
