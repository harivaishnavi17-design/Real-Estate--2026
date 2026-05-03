@isTest
public class MaintenanceRequestHandlerTest {

    @isTest
    static void testAssignVendor() {

        // Step 1: Create Vendors
        List<Vendor_Management__c> vendors = new List<Vendor_Management__c>();

        for (Integer i = 0; i < 3; i++) {
            vendors.add(new Vendor_Management__c(
                Name = 'Vendor ' + i
            ));
        }

        insert vendors;

        // Step 2: Create existing Maintenance Requests (to simulate workload)
        List<Maintenance_Requests__c> existingReqs = new List<Maintenance_Requests__c>();

        existingReqs.add(new Maintenance_Requests__c(
            Name = 'Existing Req 1',
            Vendor_Management__c = vendors[0].Id
        ));

        existingReqs.add(new Maintenance_Requests__c(
            Name = 'Existing Req 2',
            Vendor_Management__c = vendors[0].Id
        ));

        insert existingReqs;

        // Step 3: Create new Maintenance Requests (without vendor)
        List<Maintenance_Requests__c> newRequests = new List<Maintenance_Requests__c>();

        for (Integer i = 0; i < 3; i++) {
            newRequests.add(new Maintenance_Requests__c(
                Name = 'New Req ' + i
            ));
        }

        // Step 4: Call Handler
        Test.startTest();
        MaintenanceRequestHandler.assignVendor(newRequests);
        Test.stopTest();

        // Step 5: Verify vendors are assigned
        for (Maintenance_Requests__c req : newRequests) {
            System.assertNotEquals(null, req.Vendor_Management__c,
                'Vendor should be assigned');
        }

        // Step 6: Optional - Check load balancing logic
        Map<Id, Integer> countMap = new Map<Id, Integer>();

        for (Maintenance_Requests__c req : newRequests) {
            countMap.put(
                req.Vendor_Management__c,
                countMap.containsKey(req.Vendor_Management__c)
                    ? countMap.get(req.Vendor_Management__c) + 1
                    : 1
            );
        }

        System.assert(countMap.size() > 0, 'Vendors should receive requests');
    }
}