import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';

class DateRangeEntry extends StatelessWidget {
  final BuildContext context;
  final bool isStart;
  final DateTime dateTime;
  final DateTimeFormat dateFormat;
  final Function(DateTime) onSelected;

  const DateRangeEntry({
    super.key,
    required this.context,
    required this.isStart,
    required this.dateTime,
    required this.dateFormat,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Material(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () async {
              final selected = await DialogHelper.showDatePickerDialog(
                  context, dateTime, isStart);
              if (selected != null) {
                onSelected(selected);
              }
            },
            splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isStart ? "Start Date" : "End Date",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).indicatorColor,
                            fontSize: SizeHelper.getFontSize(
                              context,
                              size: FontSize.regularLarge,
                            )),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      DateFormat(DateTimeFormat.standard.format)
                          .format(dateTime),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).indicatorColor,
                          fontSize: SizeHelper.getFontSize(
                            context,
                            size: FontSize.regular,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
