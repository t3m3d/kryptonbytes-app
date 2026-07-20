import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: <Color>[AppTheme.mint, AppTheme.cyan]),
            borderRadius: BorderRadius.circular(compact ? 10 : 13),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppTheme.mint.withValues(alpha: 0.2),
                blurRadius: 18,
              ),
            ],
          ),
          child: Text(
            'K',
            style: TextStyle(
              color: AppTheme.ink,
              fontSize: compact ? 18 : 23,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'KryptonBytes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}
