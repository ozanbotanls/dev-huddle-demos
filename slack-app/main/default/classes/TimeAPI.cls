public with sharing class TimeAPI {
    public List<String> retrieveAllTimeZones() {
        List<String> timeZones = new List<String>();
        try {
            ExternalService.TimeAPI timeAPI = new ExternalService.TimeAPI();
            ExternalService.TimeAPI.getApiTimeZoneAvailableTimeZones_Response resp = timeAPI.getApiTimeZoneAvailableTimeZones();
            System.debug('response => ' + resp);
            timeZones = resp.Code200;
        } catch (ExternalService.TimeAPI.getApiTimeZoneAvailableTimeZones_ResponseException exc) {
            System.debug('400 response: error message --> ' + exc);
        }
        return timeZones;
    }

    public void getApiTimeZoneCoordinate() {
        ExternalService.TimeAPI timeAPI = new ExternalService.TimeAPI();
        ExternalService.TimeAPI.getApiTimeZoneCoordinate_Request req = new ExternalService.TimeAPI.getApiTimeZoneCoordinate_Request();
        req.latitude = 38.9;
        req.longitude = -77.03;
        try {
            ExternalService.TimeAPI.getApiTimeZoneCoordinate_Response resp = timeAPI.getApiTimeZoneCoordinate(req);
            System.debug('response => ' + resp.Code200);
        } catch (ExternalService.TimeAPI.getApiTimeZoneCoordinate_ResponseException exc) {
            System.debug('400 response: error message --> ' + exc.Code400);
        }
    }
}
