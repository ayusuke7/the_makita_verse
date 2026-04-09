import 'package:flutter/material.dart';

enum BalonSide { left, right }

class BalonComment extends StatelessWidget {
  final String comment;
  final BalonSide side;

  final Widget? avatar;
  final EdgeInsets? margin;

  const BalonComment({
    super.key,
    this.avatar,
    this.margin,
    this.side = BalonSide.left,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = side == BalonSide.left;

    return Container(
      margin: margin,
      child: Row(
        spacing: 10.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLeft && avatar != null) avatar!,
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLeft ? Color(0xFF162e1e) : Color(0xFF2e2040),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.only(
                  topLeft: isLeft ? Radius.circular(0) : Radius.circular(10),
                  topRight: isLeft ? Radius.circular(10) : Radius.circular(0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(comment),
            ),
          ),
          if (!isLeft && avatar != null) avatar!,
        ],
      ),
    );
  }
}
