import 'package:cvs_ec_app/domain/domain.dart';

class ActivitiesPageModel {
  ActivitiesResponseModel activities;
  DatumCrmLead lead;

  ActivitiesPageModel(
    {
      required this.activities,
      required this.lead,
    }
  );

}