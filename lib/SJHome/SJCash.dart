import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scratchjoy/SJTool/sj_extension_help.dart';
import 'package:scratchjoy/SJTool/sj_text.dart';
import '../SJTool/sj_GradientNumber.dart';
import '../SJTool/sj_LocalProvider.dart';
import '../SJTool/sj_img.dart';
import 'SJScratchA.dart';

class SJCash extends StatefulWidget {
  const SJCash({super.key});

  @override
  State<SJCash> createState() => _SJCashState();
}

class _SJCashState extends State<SJCash> {
  final ScrollController _scrollController = ScrollController();
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
                                value: provider.sj_domand_number,
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
                            onTap: () {},
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
                          onTap: () {
                            setState(() {});
                          },
                          child: SJImg(
                            name: 'sj_account_0_s',
                            width: 176.w,
                            height: 61.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: SJImg(
                            name: 'sj_account_1_n',
                            width: 176.w,
                            height: 61.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Visibility(
                      visible: true,
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
                                    text: '228 ',
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
                                    text: '22',
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
                    SJScrollListView(
                      itemHeights: [106.h, 164.h, 106.h, 164.h],
                      items: [
                        _bulidTxOneWidget(),
                        _bulidTxTwoWidget(),
                        _bulidTxOneWidget(),
                        _bulidTxTwoWidget(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToIndex(int index) {
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
  // var num_list = SPNumberhelper().numberEntity.card_range;
  var num_list = [1000, 1500, 2000, 3000];
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
  
  Widget _bulidTxOneWidget(){
    return Center(
      child: Container(
        width: 0.width(context) - 32.w,
        height: 106.h,
        decoration: BoxDecoration(
          image: SJDImg('sj_cash_bg_0')
        ),
        child: Stack(
          children: [
            Positioned(left: 13.w, top:14.h, child: SJText(text: '\$1000', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400)),
            Positioned(right: 12.w, top:12.h, child: InkWell(
              onTap: (){
                
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
                    value: 2.0 / 5.0,
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

  Widget _bulidTxTwoWidget(){
    return Center(
      child: Container(
        width: 0.width(context) - 32.w,
        height: 164.h,
        decoration: BoxDecoration(
            image: SJDImg('sj_account_bgs')
        ),
        child: Stack(
          children: [
            Positioned(left: 13.w, top:14.h, child: SJText(text: '\$1000', size: 32.sp, color: '#FFFCEB'.color(), weight: FontWeight.w400)),
            Positioned(right: 12.w, top:12.h, child: InkWell(
              onTap: (){

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
                  SJText(text: 'XXXXXXXXXXXXX', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                  Spacer(),
                  SJImg(name: 'sj_seletecd_s', width: 29.w, height: 29.w,),
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
                  SJText(text: 'XXXXXXXXXXXXX', size: 20.sp, color: '#FFFFFF'.color(), weight: FontWeight.w400),
                  Spacer(),
                  SJImg(name: 'sj_seletecd_s', width: 29.w, height: 29.w,),
                  SizedBox(width: 9.w,),
                ],
              ),
            ),),
          ],
        ),
      ),
    );
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
