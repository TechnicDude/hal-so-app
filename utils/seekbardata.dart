// ignore_for_file: must_be_immutable

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SeekBarUIScreen extends StatefulWidget {
  double valueHolder;
  SeekBarUIScreen({
    super.key,
    required this.valueHolder,
  });

  @override
  State<SeekBarUIScreen> createState() => _SeekBarUIScreenState();
}

class _SeekBarUIScreenState extends State<SeekBarUIScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.valueHolder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
