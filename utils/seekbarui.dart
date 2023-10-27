import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'colors.dart';

class Seekbar extends StatefulWidget {
  double? valueHolder;
  Seekbar({
    Key? key,
    this.valueHolder,
  }) : super(key: key);

  @override
  State<Seekbar> createState() => _SeekbarState();
}

class _SeekbarState extends State<Seekbar> {
  double? Startvalue;
  @override
  void initState() {
    // TODO: implement initState
    print("object see paf=ge");
    print(widget.valueHolder);
    Startvalue = widget.valueHolder!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // RangeSlider(
        //   min: 0.0,
        //   max: 100.0,
        //   divisions: 10,
        //   activeColor: colorSecondry,
        //   //  inactiveColor: color,
        //   labels: RangeLabels(
        //     _startValue.round().toString(),
        //     _endValue.round().toString(),
        //   ),
        //   values: RangeValues(_startValue, _endValue),
        //   onChanged: (values) {
        //     setState(() {
        //       _startValue = values.start;
        //       _endValue = values.end;
        //     });
        //   },
        // ),

        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${Startvalue!.toDouble().round().toString()} gram',
                  style: Style_File.subtitle.copyWith(
                    color: colorBlack,
                    fontSize: 15.sp,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
