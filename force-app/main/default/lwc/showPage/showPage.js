import { LightningElement } from 'lwc';
import fetchProperty from '@salesforce/apex/PaginationProperty.fetchRecords';

export default class ShowPage extends LightningElement {

    property = [];
    pageNumber = 1;
    pageSize = 5;
    totalPages = 0;
    totalRecords = 0;
    loading = false;

    minPrice;
    maxPrice;
    status;
    furnishing;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'City', fieldName: 'City__c' },
        { label: 'State', fieldName: 'State__c' },
        { label: 'Rent', fieldName: 'Rent__c', type: 'currency' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Furnishing', fieldName: 'Furnishing_Status__c' }
    ];

    statusOptions = [
        { label: 'Available', value: 'Available' },
        { label: 'Occupied', value: 'Occupied' }
    ];

    furnishingOptions = [
        { label: 'Furnished', value: 'Furnished' },
        { label: 'Semi-Furnished', value: 'Semi-Furnished' },
        { label: 'Unfurnished', value: 'Unfurnished' }
    ];

    connectedCallback() {
        this.loadProperty();
    }

    loadProperty() {
        this.loading = true;

        fetchProperty({
            pageSize: this.pageSize,
            pageNumber: this.pageNumber,
            minPrice: this.minPrice,
            maxPrice: this.maxPrice,
            status: this.status,
            furnishing: this.furnishing
        })
        .then(res => {
            this.property = res.property;
            this.totalRecords = res.totalRecords;
            this.totalPages = res.totalPages;
            this.loading = false;
        })
        .catch(error => {
            console.error(error);
            this.loading = false;
        });
    }

    // 🔹 Filter Handlers
    handleMinPrice(event) {
        this.minPrice = event.target.value;
    }

    handleMaxPrice(event) {
        this.maxPrice = event.target.value;
    }

    handleStatus(event) {
        this.status = event.detail.value;
    }

    handleFurnishing(event) {
        this.furnishing = event.detail.value;
    }

    // 🔹 Buttons
    handleSearch() {
        this.pageNumber = 1;
        this.loadProperty();
    }

    handleReset() {
    this.minPrice = null;
    this.maxPrice = null;
    this.status = null;
    this.furnishing = null;

    this.template.querySelectorAll('lightning-input').forEach(input => {
        input.value = null;
    });

    this.template.querySelectorAll('lightning-combobox').forEach(box => {
        box.value = null;
    });

    this.pageNumber = 1;
    this.loadProperty();
}
    nextHandler() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.loadProperty();
        }
    }

    previousHandler() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.loadProperty();
        }
    }

    // 🔹 Helpers
    get startRecord() {
        return (this.pageNumber - 1) * this.pageSize + 1;
    }

    get endRecord() {
        let end = this.pageNumber * this.pageSize;
        return end > this.totalRecords ? this.totalRecords : end;
    }

    get disableNext() {
        return this.pageNumber >= this.totalPages;
    }

    get disablePrev() {
        return this.pageNumber <= 1;
    }
}