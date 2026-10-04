public class DuffelAuthService {
    public static String getApiKey(){
        Duffel_config__mdt  config = Duffel_config__mdt.getInstance('Default');
        if(config == null){
            throw new AuraHandledException(
                'Duffel configuration not found'
            );
        }
        return config.API_Key__c;
    }
}