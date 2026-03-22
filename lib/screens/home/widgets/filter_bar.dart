import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'filter_chips.dart';

class FilterBar extends StatelessWidget {
  final List<String> channelFilters;
  final List<String> campaignFilters;
  final String activeChannel;
  final String activeCampaign;
  final ValueChanged<String> onChannelChanged;
  final ValueChanged<String> onCampaignChanged;

  const FilterBar({
    super.key,
    required this.channelFilters,
    required this.campaignFilters,
    required this.activeChannel,
    required this.activeCampaign,
    required this.onChannelChanged,
    required this.onCampaignChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12.0,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Channel:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryText,
                ),
              ),
              FilterChips(
                filters: channelFilters,
                active: activeChannel,
                onSelected: onChannelChanged,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Campaign:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryText,
                ),
              ),
              FilterChips(
                filters: campaignFilters,
                active: activeCampaign,
                onSelected: onCampaignChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
