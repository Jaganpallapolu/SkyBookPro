public with sharing class DuffelTokenRefreshJob
    implements Queueable {

        public void execute(QueueableContext context){
            
            try{
                
                String apiKey = DuffelAuthService.getApiKey();
                
                System.debug('Duffel API Key Retrieved Successfully');
                
            }
            catch(Exception e){
                
                System.debug('Error: ' + e.getMessage());
                
            }
            
        }

}