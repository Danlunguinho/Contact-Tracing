public with sharing class CTLocationTracingController {
   
    //Listar osos visitantes de um local
    public static List<Location_Tracing__c> getVistors(String locationId) {
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c FROM Location_Tracing__c WHERE Location__c = :locationId ORDER BY Visit_Date__c DESC];
    }

    //Listar os id dos visitantes em um local 
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds) {
        return [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
    }

    //Listar os id dos locais
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        return [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__r.Health_Status__c = 'Green' AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {
        //armazenar ids unicos
        Set<Id> locationIds = new Set<Id>();
        //armazenar ids de pessoas (unicos)
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c trace : newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }

        //mapa de location id e set de person id
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
        //location1, [person1, person2]
        //Listar registros existentes do location tracing
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__c IN :personIds];

        //Lista de registros duplicados
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

        if (existingRecords != null && existingRecords.size() > 0) {
            for (Location_Tracing__c trace : existingRecords) {
                if (!mapOfExistingRecords.containsKey(trace.Location__c)) {
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                //Adicionar personid para o mapa 
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }

            //Loop dos novos registro de location tracing 
            for (Location_Tracing__c trace : newLocationTraces) {
                //Checar pelo location id
                //Se for encontrado no para, checar pelo person no set 
                if (mapOfExistingRecords.containsKey(trace.Location__c) && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)) {
                    duplicates.add(trace);
                }
            }
        }

        return duplicates;
    }
}
