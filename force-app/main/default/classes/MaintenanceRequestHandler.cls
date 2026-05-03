public class MaintenanceRequestHandler {

    public static void assignVendor(List<Maintenance_Requests__c> newRequests) {

       
        List<Vendor_Management__c> vendorList = [
            SELECT Id FROM Vendor_Management__c
        ];

        if (vendorList.isEmpty()) return;

       
        Map<Id, Integer> loadMap = new Map<Id, Integer>();

        for (AggregateResult ar : [
            SELECT Vendor_Management__c vId, COUNT(Id) cnt
            FROM Maintenance_Requests__c
            WHERE Vendor_Management__c != NULL
            GROUP BY Vendor_Management__c
        ]) {
            loadMap.put(
                (Id) ar.get('vId'),
                (Integer) ar.get('cnt')
            );
        }

       
        for (Maintenance_Requests__c req : newRequests) {

            Id selectedVendor;
            Integer minLoad =999999999;

            for (Vendor_Management__c v : vendorList) {

                Integer load = loadMap.containsKey(v.Id)
                    ? loadMap.get(v.Id)
                    : 0;

                if (load < minLoad) {
                    minLoad = load;
                    selectedVendor = v.Id;
                }
            }

            
            req.Vendor_Management__c = selectedVendor;

           
            loadMap.put(selectedVendor, minLoad + 1);
        }
    }
}