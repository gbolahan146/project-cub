import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/emptystate/empty_widget.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cubex/src/core/utils/extensions.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isNotificationEmpty = false;

  List dummyNotification = [
    {
      "title": "Successful Withdrawal",
      "sub":
          "You just made a successful withdrawal of ₦50,000 to your Access Bank account.",
      "time": "03:14 AM"
    },
    {
      "title": "Failed Transfer",
      "sub":
          "You just made a successful withdrawal of ₦50,000 to your Access Bank account.",
      "time": "03:14 AM"
    },
    {
      "title": "Successful Withdrawal",
      "sub":
          "You just made a successful withdrawal of ₦50,000 to your Access Bank account.",
      "time": "03:14 AM"
    },
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    return CbScaffold(
      backgroundColor: CbColors.cBase,
      appBar: CbAppBar(
        title: 'Notifications',
        isTransparent: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: !isNotificationEmpty
              ? EmptyStateWidget(
                  title: 'You have no notifications at the moment.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YMargin(30),
                    Row(
                      children: [
                        Text(
                          "Today.",
                          style: CbTextStyle.medium
                              .copyWith(color: CbColors.cAccentLighten3),
                        ),
                        Spacer(),
                        Text(
                          "Clear all",
                          style: CbTextStyle.medium
                              .copyWith(color: CbColors.cAccentLighten3),
                        ),
                        XMargin(8),
                        SvgPicture.asset('clear'.svg)
                      ],
                    ),
                    YMargin(16),
                    Container(
                      height: config.sh(232),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => YMargin(16),
                        itemCount: 3,
                        itemBuilder: (context, index) => NotificationCard(
                            title: dummyNotification[index]['title'],
                            subtitle: dummyNotification[index]['sub'],
                            time: dummyNotification[index]['time']),
                      ),
                    ),
                    YMargin(24),
                    Row(
                      children: [
                        Text(
                          "Yesterday.",
                          style: CbTextStyle.medium
                              .copyWith(color: CbColors.cAccentLighten3),
                        ),
                      ],
                    ),
                    YMargin(16),
                    Container(
                      height: config.sh(232),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => YMargin(16),
                        itemCount: 3,
                        itemBuilder: (context, index) => NotificationCard(
                            title: dummyNotification[index]['title'],
                            subtitle: dummyNotification[index]['sub'],
                            time: dummyNotification[index]['time']),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? time;
  const NotificationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CbColors.white, borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$title',
                  style: CbTextStyle.bold16.copyWith(
                      fontFamily: 'Roboto',
                      color: title!.contains('Success')
                          ? CbColors.cSuccessBase
                          : CbColors.cAccentBase)),
              Text('$time', style: CbTextStyle.book12)
            ],
          ),
          YMargin(16),
          Text(
            "$subtitle",
            style: CbTextStyle.book14,
          )
        ],
      ),
    );
  }
}
