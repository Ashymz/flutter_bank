import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bank/screens/history_page.dart';
import 'package:flutter_bank/screens/transfer.dart';
import 'package:flutter_bank/screens/vtu.dart';
import 'package:flutter_bank/utils/functions.dart';
import 'package:flutter_bank/widgets/transaction_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/models.dart';
import '../utils/my_colors.dart';
import '../utils/my_theme.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = formatDate(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: isDarkModeEnabled(context)
                  ? MyColors.darkBlue
                  : MyColors.lightPurple),
          height: 290.h,
          width: double.infinity,
          child: Stack(children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                    top: isIOS
                        ? 35.h
                        : isAndroid
                            ? 25.h
                            : 0,
                    left: 0),
                child: Image.asset(
                  "assets/images/background_pic.png",
                  height: 290.h,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.h, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/profile.jpeg",
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment(0, -1.5),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi Temmie",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ThemeSwitcher(
                        clipper: const ThemeSwitcherCircleClipper(),
                        builder: (context) {
                          return GestureDetector(
                            onTapDown: (details) =>
                                ThemeSwitcher.of(context).changeTheme(
                              theme: ThemeModelInheritedNotifier.of(context)
                                          .theme
                                          .brightness ==
                                      Brightness.light
                                  ? darkTheme
                                  : lightTheme,
                              offset: details.localPosition,
                            ),
                            child: Icon(
                              isDarkModeEnabled(context)
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode,
                              color: isDarkModeEnabled(context)
                                  ? Colors.white
                                  : Colors.black,
                              size: 22,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20.h),
                            child: const Text(
                              "Balance",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 23),
                            child: Text(
                              _isBalanceVisible ? "\₦30,434.34" : "******",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 24, top: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                          child: Icon(
                            _isBalanceVisible
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            size: 30,
                            // color: isDarkModeEnabled(context)
                            //     ? Colors.white
                            //     : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getMenuList().length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final menuItem = getMenuList()[index];

                        return GestureDetector(
                          onTap: () {
                            if (menuItem.title == 'Transfer') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MoneyTransferScreen()),
                              );
                            } else if (menuItem.title == 'Top Up') {
                              _showAccountModal(context);
                            } else if (menuItem.title == 'Recharge') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VtuScreen()),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                              right: 24.w,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 48.h,
                                  width: 48.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        menuItem.icon,
                                        size: 26,
                                        color: isDarkModeEnabled(context)
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    menuItem.title,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 37.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(),
                    ),
                  );
                },
                child: Text(
                  "View More",
                  style: TextStyle(
                      fontSize: 18,
                      color: MyColors.darkPurple,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListView.separated(
              itemCount: 7,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final TransactionModel transactionItem =
                    getTransactionList()[index];
                return buildTransactionItemWidget(transactionItem);
              },
              separatorBuilder: (context, index) => Container(
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void _showAccountModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Account Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Name:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Number:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '1234567890',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bank Name:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Bank',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      });
}
