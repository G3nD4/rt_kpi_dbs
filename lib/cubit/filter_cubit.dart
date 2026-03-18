import 'package:bloc/bloc.dart';

class FilterState {
  final String activeChannel;
  final String activeCampaign;

  const FilterState({this.activeChannel = 'All', this.activeCampaign = 'All'});

  FilterState copyWith({String? activeChannel, String? activeCampaign}) {
    return FilterState(
      activeChannel: activeChannel ?? this.activeChannel,
      activeCampaign: activeCampaign ?? this.activeCampaign,
    );
  }
}

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void setChannel(String channel) => emit(state.copyWith(activeChannel: channel));
  void setCampaign(String campaign) => emit(state.copyWith(activeCampaign: campaign));
}
