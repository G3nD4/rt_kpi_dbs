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
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Text(
            'Channel:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.secondaryText),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilterChips(filters: channelFilters, active: activeChannel, onSelected: onChannelChanged),
          ),
        ),
        const SizedBox(width: 12),
        const Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Text(
            'Campaign:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.secondaryText),
          ),
        ),
        SizedBox(
          width: 180,
          height: 48,
          child: FilterChips(filters: campaignFilters, active: activeCampaign, onSelected: onCampaignChanged),
        ),
      ],
    );
  }
}
