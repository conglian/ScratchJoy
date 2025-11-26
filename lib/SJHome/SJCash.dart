import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJDilaog/SJDialog.dart';
import 'package:scratchjoy/SJTool/SJAdManager.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';
import '../SJTool/SJTBAInfoTool.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_img.dart';
import '../SJTool/sj_number_helper.dart';
import 'SJScratchA.dart';

class SJCash extends StatefulWidget {
  const SJCash({super.key});

  @override
  State<SJCash> createState() => _SJCashState();
}

class _SJCashState extends State<SJCash> {

  final ScrollController _scrollController = ScrollController();

  int seletcd_index = 0;

  List<int> tx_list = [1000, 1500, 3000];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sj_event_fire('cash_page', {});
    // 在第一帧渲染完成后执行滚动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(SJLocalProvider.instance.sj_current_ranking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(image: SJDImg('sj_cash_bg')),
        child: Column(
          children: [
            // 固定头部栏
            SJDetailsBarWidget(),
            // 滑动内容部分
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  children: [
                    SizedBox(height: 18.h),
                    Container(
                      width: 343.w,
                      height: 151.h,
                      decoration: BoxDecoration(image: SJDImg('sj_mybanner_bg')),
                      child: Column(
                        children: [
                          SizedBox(height: 7.h),
                          SJText(
                            text: 'My Balance',
                            size: 14,
                            color: '#F7E8B8'.color(),
                            weight: FontWeight.w400,
                          ),
                          SizedBox(height: 7.h),
                          Consumer<SJLocalProvider>(
                            builder: (context, provider, child) {
                              return SJGradientNumberRoller(
                                value: provider.sj_dolas_number,
                                duration: 800,
                                fontSize: 48.0,
                                gradientColors: [
                                  '#4C3117'.color(),
                                  '#4C3117'.color(),
                                ],
                                borderColor: '#FFFFFF'.color(),
                                borderWidth: 0.0,
                                decimalPlaces: 0,
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              _submitCashTask(1000, 0);
                            },
                            child: SJImg(
                              name: 'sj_wtd_btn',
                              width: 204,
                              height: 54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                    SJText(
                      text: 'Select Withdrawal Method',
                      size: 14.sp,
                      color: '#FDEC9A'.color(),
                      weight: FontWeight.w400,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              seletcd_index = 0;
                            });
                          },
                          child: SJImg(
                            name: seletcd_index == 0 ? 'sj_account_0_s' : 'sj_account_0_n',
                            width: 176.w,
                            height: 61.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              seletcd_index = 1;
                            });
                          },
                          child: SJImg(
                            name: seletcd_index == 1 ? 'sj_account_1_s' : 'sj_account_1_n',
                            width: 176.w,
                            height: 61.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Visibility(
                      visible: SJLocalProvider.instance.sj_tx_last_status,
                      child: SizedBox(
                        width: 0.width(context),
                        height: 406.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: (0.width(context) - 343.w) * 0.5,
                              child: Column(
                                children: [
                                  Container(
                                    width: 343.w,
                                    height: 127.h,
                                    decoration: BoxDecoration(
                                      image: SJDImg('sj_rank_bgs')
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 9.h,),
                                        Row(
                                          children: [
                                            SizedBox(width: 3.w,),
                                            Container(
                                              width: 128.w,
                                              height: 46.h,
                                              decoration: BoxDecoration(
                                                image: SJDImg('sj_rank_left_bg')
                                              ),
                                              child: Center(
                                                child: SJText(text: '\$1000', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: (){
                                                sj_event_fire('skip_wait_c', {});
                                                SJAdManager().sj_showAd(false, 'scxji_queue_rv', context, (hasCache){}, (finished){
                                                  var row = sj_generateRandomNumber();
                                                  setState(() async {
                                                    if (SJLocalProvider.instance.sj_current_ranking - row <= 1) {
                                                      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_current_rankingName, 1);
                                                      await SJLocalProvider.instance.updateTXInStatus(2);
                                                      if (!mounted) return;
                                                      context.tipShow(SJPopTXSulsDialog());
                                                    } else {
                                                      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_all_rankingName, SJLocalProvider.instance.sj_all_ranking - sj_generateRandomNumber());
                                                      await SJLocalProvider.instance.updateint(SJLocalProvider.instance.sj_current_rankingName, SJLocalProvider.instance.sj_current_ranking - row);
                                                      Future.delayed(Duration(milliseconds: 200),(){
                                                        if (!mounted) return;
                                                        setState(() {
                                                          _scrollToIndex(SJLocalProvider.instance.sj_current_ranking);
                                                          SJDialogTool.toastRanking(context, SJLocalProvider.instance.sj_current_ranking);
                                                        });
                                                      });
                                                    }
                                                  });
                                                });
                                              },
                                              child: SJImg(name: 'sj_skip_btn',width: 156.w, height: 42.h,),
                                            ),
                                            SizedBox(width: 8.w,)
                                          ],
                                        ),
                                        SizedBox(height: 4.h,),
                                        SizedBox(
                                          width: 295.w,
                                          height: 54.h,
                                          child:RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: '#4C3117'.color(),
                                                  fontFamily: 'Barlow_Black'
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Congratulations! You’ve entered the withdrawal review queue. You can tap',
                                                ),
                                                TextSpan(
                                                  text: '“Skip Wait”',
                                                  style: TextStyle(color: '#127E1B'.color()),
                                                ),
                                                TextSpan(
                                                  text: 'to speed up the review process.',
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(right: 2,child: SJImg(name: 'sj_rv_icon', width: 55, height: 55,)),
                            Positioned(left: 38.w,top: 126.h,child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: '#FDEC9A'.color(),
                                    fontFamily: 'Barlow_Black'
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${SJLocalProvider.instance.sj_all_ranking} ',
                                    style: TextStyle(color: '#E37037'.color(), fontSize: 20.sp),
                                  ),
                                  TextSpan(
                                    text: 'In Queue',
                                  ),
                                ],
                              ),
                            ),),
                            Positioned(right: 38.w,top: 126.h,child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: '#FDEC9A'.color(),
                                    fontFamily: 'Barlow_Black'
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Your Current Rank: ',
                                  ),
                                  TextSpan(
                                    text: '${SJLocalProvider.instance.sj_current_ranking}',
                                    style: TextStyle(color: '#62C42E'.color(), fontSize: 20.sp),
                                  ),
                                ],
                              ),
                            ),),
                            Positioned(
                                left: (0.width(context) - 343.w) * 0.5,
                                top: 160.h,
                                child: Container(
                              width: 343.w,
                              height: 250.h,
                              decoration: BoxDecoration(
                                color: '#341917'.color(),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 343.w,
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      image: SJDImg('sj_rank_top_bg')
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        SJText(text: 'Queue', size: 18.sp, color: '#B2885C'.color(), weight: FontWeight.w400),
                                        SJText(text: 'Account', size: 18.sp, color: '#B2885C'.color(), weight: FontWeight.w400),
                                        SJText(text: 'Amount', size: 18.sp, color: '#B2885C'.color(), weight: FontWeight.w400),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 343.w,
                                    height: (250 - 44).h,
                                    child:  ListView.separated(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      padding: const EdgeInsets.symmetric(vertical: 0),
                                      itemCount: SJLocalProvider.instance.sj_all_ranking,
                                      separatorBuilder: (context, index) => const SizedBox(width: 0),
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 243.w,
                                          height: 41.h,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Center(child: SJText(text: '${index + 1}', size: 18.spMax, color: SJLocalProvider.instance.sj_current_ranking == index+1 ? '#71FF2F'.color() : '#FFF1E1'.color(), weight: FontWeight.w400),),
                                              Center(child: SJText(text: '${_sj_generateToList()[index]}', size: 18.spMax, color: SJLocalProvider.instance.sj_current_ranking == index+1 ? '#71FF2F'.color() : '#FFF1E1'.color(), weight: FontWeight.w400),),
                                              Center(child: SJText(text: '${_generateToDolasList()[index]}', size: 18.spMax, color: SJLocalProvider.instance.sj_current_ranking == index+1 ? '#71FF2F'.color() : '#FFF1E1'.color(), weight: FontWeight.w400),),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        )
                      ),
                    ),
                    // 106, 164
                    Consumer<SJLocalProvider>(
                      builder: (context, provider, child) {
                        return SJScrollListView(
                          itemHeights: [_getItemheight(0), _getItemheight(1), _getItemheight(2)],
                          items: [
                            _getItemtype(0, 1000),
                            _getItemtype(1, 1500),
                            _getItemtype(2, 3000),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int sj_generateRandomNumber() {
    return Random().nextInt(6 - 3 + 1) + 3;
  }

  double _getItemheight(int index){
    double h = 106.h;
    if (SJLocalProvider.instance.txEntity.tx_info[seletcd_index].tx_list[index].status == 1){
      h = 164.h;
    }
    return h;
  }

  Widget _getItemtype(int index, int dolasnumber){
    if (SJLocalProvider.instance.txEntity.tx_info[seletcd_index].tx_list[index].status == 1){
       return _bulidTxTwoWidget(index, dolasnumber);
    } else if (SJLocalProvider.instance.txEntity.tx_info[seletcd_index].tx_list[index].status == 2){
      return _bulidTxThreeWidget(index, dolasnumber);
    }
    return _bulidTxOneWidget(index, dolasnumber);
  }

  void _scrollToIndex(int index) {
    if (SJLocalProvider.instance.sj_tx_last_status == false) return;
    // 每个 item 的高度固定为 38（根据你的例子）
    double itemHeight = 41.0.h;

    // 计算目标位置
    final double offset = (index - 1) * itemHeight;

    // 平滑滚动动画
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  List<String> _sj_generateToList() {
    final random = Random(); // 创建一个随机数生成器
    List<String> list = List.generate(SJLocalProvider.instance.sj_all_ranking, (index) {
      if (index == SJLocalProvider.instance.sj_current_ranking - 1) { // 第90个位置（索引为89）
        return SJLocalProvider.instance.sj_account_id;
      } else {
        // 生成随机的三位数字
        String randomPart = random.nextInt(1000).toString().padLeft(4, '0');
        return "1****$randomPart";
      }
    });
    return list;
  }
  // 生成列表
  var num_list = [1000, 1500, 3000];
  List<String> _generateToDolasList() {
    List<String> list = List.filled(SJLocalProvider.instance.sj_all_ranking, ""); // 初始化一个长度为200的空字符串列表
    final random = Random(); // 创建一个随机数生成器
    for (int i = 0; i < list.length; i++) {
      if (i == SJLocalProvider.instance.sj_current_ranking - 1) { // 第90个位置（索引为89）
        list[i] = "\$${num_list[SJLocalProvider.instance.sj_tx_ing_number]}";
      } else {
        // 随机选择一个可能的金额值
        list[i] = '${num_list[random.nextInt(num_list.length)]}';
      }
    }
    return list;
  }
  
  Widget _bulidTxOneWidget(int index, int value){
    return Center(
      child: Container(
        width: 0.width(context) - 32.w,
        height: 106.h,
        decoration: BoxDecoration(
          image: SJDImg('sj_cash_bg_0')
        ),
        child: Stack(
          children: [
            Positioned(left: 13.w, top:14.h, child: SJText(text: '\$$value', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400)),
            Positioned(right: 12.w, top:12.h, child: InkWell(
              onTap: (){
                _submitCashTask(value, index);
              },
              child: SJImg(name: 'sj_cash_out_btn', width: 143.5.w, height: 41.h,),
            )),
            Positioned(left: 13.w, bottom:17.h, child: Container(
              width: 280.w,
              height: 17.h,
              decoration: BoxDecoration(
                image: SJDImg('sj_cash_pro_bg')
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(14.h)),
                    value: SJLocalProvider.instance.sj_dolas_number / value,
                    minHeight: 14.h,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>('#FFF954'.color()),
                  )
                ],
              ),
            )),
            Positioned(right: 15.w, bottom:4.h, child: SJImg(name: 'sj_cash_dolas', width: 48.w, height: 48.w,)),
          ],
        ),
      ),
    );
  }

  Widget _bulidTxThreeWidget(int index, int value){
    return Center(
      child: Container(
        width: 0.width(context) - 32.w,
        height: 106.h,
        decoration: BoxDecoration(
            image: SJDImg('sj_cash_bg_0')
        ),
        child: Stack(
          children: [
            Positioned(left: 13.w, top:14.h, child: SJText(text: '\$$value', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400)),
            Positioned(right: 12.w, top:12.h, child: InkWell(
              onTap: (){
                context.tipShow(SJPopTXSulsDialog());
              },
              child: SJImg(name: 'sj_success_btn', width: 143.5.w, height: 41.h,),
            )),
            Positioned(left: 13.w, bottom:17.h, child: Container(
              width: 280.w,
              height: 17.h,
              decoration: BoxDecoration(
                  image: SJDImg('sj_cash_pro_bg')
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(14.h)),
                    value: 1.0,
                    minHeight: 14.h,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>('#FFF954'.color()),
                  )
                ],
              ),
            )),
            Positioned(right: 15.w, bottom:4.h, child: SJImg(name: 'sj_cash_dolas', width: 48.w, height: 48.w,)),
          ],
        ),
      ),
    );
  }
  // 发起提现
  void _submitCashTask(int value, int index){
    if (SJLocalProvider.instance.sj_dolas_number < value){
      context.tipShow(SJPopTXNotDialog());
    } else {
      if (SJLocalProvider.instance.sj_account_id.isEmpty){
        context.tipShow(SJPopSubmitOneDialog(number_index: index));
      } else {
        SJDialogTool.toast(context, 'There are currently withdrawal tasks in progress. You can withdraw again after completion.');
      }
    }
  }

  Widget _bulidTxTwoWidget(int index, int value){
    return Center(
      child: Container(
        width: 0.width(context) - 32.w,
        height: 164.h,
        decoration: BoxDecoration(
            image: SJDImg('sj_account_bgs')
        ),
        child: Stack(
          children: [
            Positioned(left: 13.w, top:14.h, child: SJText(text: '\$$value', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400)),
            Positioned(right: 12.w, top:12.h, child: InkWell(
              onTap: (){
                if (SJLocalProvider.instance.sj_tx_first_status == true && SJLocalProvider.instance.sj_tx_last_status == true) {
                  SJDialogTool.toast(context, 'The withdrawal task has been completed. Once you complete the leaderboard task, you can successfully withdraw your earnings.');
                } else {
                  if (SJLocalProvider.instance.sj_tx_first_status == false){
                    context.tipShow(SJPopTXTaskDialog());
                  } else {
                    context.tipShow(SJPopTask3Dialog());
                  }
                }
              },
              child: SJImg(name: 'sj_inpro_btn', width: 142.5.w, height: 42.h,),
            )),
            Positioned(left: 15.w,top: 55.h,child: Container(
              width: 313.w,
              height: 43.h,
              decoration: BoxDecoration(
                  image: SJDImg('sj_account_center_bg')
              ),
              child: Row(
                children: [
                  SizedBox(width: 13.w,),
                  SJText(text: _getTaskTotalString().first, size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                  Spacer(),
                  SJImg(name: _getTxTaskTotalStatus().first ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                  SizedBox(width: 9.w,),
                ],
              ),
            ),),
            Positioned(left: 15.w,top: 106.h,child: Container(
              width: 313.w,
              height: 43.h,
              decoration: BoxDecoration(
                  image: SJDImg('sj_account_center_bg')
              ),
              child: Row(
                children: [
                  SizedBox(width: 13.w,),
                  SJText(text: _getTaskTotalString().last, size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                  Spacer(),
                  SJImg(name: _getTxTaskTotalStatus().last ? 'sj_seletecd_s' : 'sj_seletecd_n', width: 29.w, height: 29.w,),
                  SizedBox(width: 9.w,),
                ],
              ),
            ),),
          ],
        ),
      ),
    );
  }

  List<String> _getTaskTotalString(){
    if (SJLocalProvider.instance.sj_tx_first_status == false){
      return _getTxTaskString();
    }
    return _getTxTaskString2();
  }

  List<String> _getTxTaskString(){
    String text1 = '';
    String text2 = '';
    if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      text1 =
      'Scratch ${SJLocalProvider.instance.sj_tx_card_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.first.num} Card';
      text2 =
      'Play ${SJLocalProvider.instance.sj_tx_dice_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.last.num} Dice';
    } else if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      text1 =
      'Log in ${SJLocalProvider.instance.sj_login_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.first.num} days in a row';
      text2 =
      'Play ${SJLocalProvider.instance.sj_tx_probability_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.last.num} Dice';
    }
    return [text1, text2];
  }

  List<bool> _getTxTaskTotalStatus(){
    if (SJLocalProvider.instance.sj_tx_first_status == false){
      return _getTxTaskStatus();
    }
    return _getTxTaskStatus2();
  }

  List<bool> _getTxTaskStatus(){
    bool text1 = false;
    bool text2 = false;
    if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num) {
      text1 = false;
    } else {
      text1 = true;
    }
    if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      text2 = false;
    } else {
      text2 = true;
    }
    if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.first.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    } else if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      if (SJLocalProvider.instance.sj_login_index < SJNumberHelpers().taskModel!.task.last.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    }
    return [text1, text2];
  }

  List<String> _getTxTaskString2(){
    String text1 = '';
    String text2 = '';
    if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      text2 =
      'Scratch ${SJLocalProvider.instance.sj_tx_card_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.last.num} treasure chests';
      text1 =
      'Open ${SJLocalProvider.instance.sj_tx_box_index}/${SJNumberHelpers()
          .taskModel!
          .task.first.first.num} Dice';
    } else if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      text2 =
      'Draw ${SJLocalProvider.instance.sj_tx_probability_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.last.num} probability cards';
      text1 =
      'Play ${SJLocalProvider.instance.sj_tx_dice_index}/${SJNumberHelpers()
          .taskModel!
          .task.last.first.num} Dice';
    }
    return [text1, text2];
  }

  List<bool> _getTxTaskStatus2(){
    bool text1 = false;
    bool text2 = false;
    if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num || SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
      if (SJLocalProvider.instance.sj_tx_box_index < SJNumberHelpers().taskModel!.task.first.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_card_index < SJNumberHelpers().taskModel!.task.first.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    } else if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num || SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
      if (SJLocalProvider.instance.sj_tx_dice_index < SJNumberHelpers().taskModel!.task.last.first.num) {
        text1 = false;
      } else {
        text1 = true;
      }
      if (SJLocalProvider.instance.sj_tx_probability_index < SJNumberHelpers().taskModel!.task.last.last.num) {
        text2 = false;
      } else {
        text2 = true;
      }
    }
    return [text1, text2];
  }
}

class SJScrollListView extends StatelessWidget {
  final List<Widget> items;
  final List<double> itemHeights;
  final double spacing;

  const SJScrollListView({
    super.key,
    required this.items,
    required this.itemHeights,
    this.spacing = 2.0,
  }) : assert(items.length == itemHeights.length,
  'items.length 和 itemHeights.length 必须一致');

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // ⚠️ 加上这两行非常关键！
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing.h),
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          height: itemHeights[index].h,
          child: items[index],
        );
      },
    );
  }
}
