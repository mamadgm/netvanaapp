import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTab extends StatelessWidget {
  const NewTab({super.key, required this.appbartext, required this.childrens});

  final List<Widget> childrens;
  final String appbartext;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: FIGMA.Orn,
            ),
          ),
          leadingWidth: 50,
          centerTitle: true,
          backgroundColor: FIGMA.Gray,
          title: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              appbartext,
              style: TextStyle(
                fontFamily: FIGMA.abrlb,
                fontSize: 16.sp,
                color: FIGMA.Orn,
              ),
            ),
          ),
        ),
        body: EasyContainer(
          borderWidth: 0,
          elevation: 0,
          margin: 1,
          padding: 0,
          borderRadius: 15,
          color: FIGMA.Back,
          child: ListView(scrollDirection: Axis.vertical, children: childrens),
        ),
      ),
    );
  }
}
