trigger WorkloadTrigger on Maintenance_Requests__c (before insert) {
    
if (Trigger.isBefore && Trigger.isInsert) {
        MaintenanceRequestHandler.assignVendor(Trigger.new);
    }
}