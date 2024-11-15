import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/member_dynamics/index.dart';
import 'package:pilipala/utils/utils.dart';

import '../../common/widgets/http_error.dart';
import '../../models/dynamics/result.dart';
import '../dynamics/widgets/dynamic_panel.dart';

class MemberDynamicsPage extends StatefulWidget {
  const MemberDynamicsPage({super.key});

  @override
  State<MemberDynamicsPage> createState() => _MemberDynamicsPageState();
}

class _MemberDynamicsPageState extends State<MemberDynamicsPage> {
  late MemberDynamicsController _memberDynamicController;
  late Future _futureBuilderFuture;
  late ScrollController scrollController;
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.parameters['mid']!);
    final String heroTag = Utils.makeHeroTag(mid);
    _memberDynamicController =
        Get.put(MemberDynamicsController(), tag: heroTag);
    _futureBuilderFuture =
        _memberDynamicController.getMemberDynamic('onRefresh');
    scrollController = _memberDynamicController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'member_dynamics', const Duration(milliseconds: 1000), () {
            _memberDynamicController.onLoad();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _memberDynamicController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('他的动态', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: CustomScrollView(
        controller: _memberDynamicController.scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  Map data = snapshot.data as Map;
                  RxList<DynamicItemModel> list =
                      _memberDynamicController.dynamicsList;
                  if (data['status']) {
                    return Obx(
                      () => list.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return DynamicPanel(item: list[index]);
                                },
                                childCount: list.length,
                              ),
                            )
                          : const SliverToBoxAdapter(),
                    );
                  } else {
                    return HttpError(
                      errMsg: snapshot.data['msg'],
                      fn: () {},
                    );
                  }
                } else {
                  return HttpError(
                    errMsg: snapshot.data['msg'],
                    fn: () {},
                  );
                }
              } else {
                return const SliverToBoxAdapter();
              }
            },
          ),
        ],
      ),
    );
  }
}
