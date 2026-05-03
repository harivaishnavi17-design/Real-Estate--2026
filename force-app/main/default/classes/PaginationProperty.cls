public with sharing class PaginationProperty {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> fetchRecords(
        Integer pageSize,
        Integer pageNumber,
        Decimal minPrice,
        Decimal maxPrice,
        String status,
        String furnishing
    ) {
        Integer offsetValue = (pageNumber - 1) * pageSize;

        String baseQuery = 'FROM Property__c WHERE Id != null';

        
        if (minPrice != null) {
            baseQuery += ' AND Rent__c >= :minPrice';
        }
        if (maxPrice != null) {
            baseQuery += ' AND Rent__c <= :maxPrice';
        }
        if (String.isNotBlank(status)) {
            baseQuery += ' AND Status__c = :status';
        }
        if (String.isNotBlank(furnishing)) {
            baseQuery += ' AND Furnishing_Status__c = :furnishing';
        }
        String dataQuery = 'SELECT Id, Name, City__c, State__c, Rent__c, Status__c, Furnishing_Status__c '
                         + baseQuery +
                         ' LIMIT :pageSize OFFSET :offsetValue';

        List<Property__c> propertyList = Database.query(dataQuery);
     
        String countQuery = 'SELECT COUNT() ' + baseQuery;
        Integer totalRecords = Database.countQuery(countQuery);

        Integer totalPages = (Integer)Math.ceil((Decimal)totalRecords / pageSize);

        return new Map<String, Object>{
            'property' => propertyList,
            'totalRecords' => totalRecords,
            'totalPages' => totalPages
        };
    }
}