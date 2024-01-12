// copied from external service definition
using { cuid } from '@sap/cds/common';


entity BusinessPartnerLocal: cuid {
        @sap.display.format: 'UpperCase'
        @sap.label         : 'Business Partner'
        @sap.quickinfo     : 'Business Partner Number'
        BusinessPartner                : String(10) not null;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Customer'
        @sap.quickinfo     : 'Customer Number'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        Customer                       : String(10);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Supplier'
        @sap.quickinfo     : 'Account Number of Supplier'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        Supplier                       : String(10);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Academic Title 1'
        @sap.quickinfo     : 'Academic Title: Key'
        AcademicTitle                  : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Authorization Group'
        AuthorizationGroup             : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'BP Category'
        @sap.quickinfo     : 'Business Partner Category'
        BusinessPartnerCategory        : String(1);

        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        BusinessPartnerFullName        : String(81);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Grouping'
        @sap.quickinfo     : 'Business Partner Grouping'
        BusinessPartnerGrouping        : String(4);

        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        BusinessPartnerName            : String(81);

        @sap.label         : 'BP GUID'
        @sap.quickinfo     : 'Business Partner GUID'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        BusinessPartnerUUID            : UUID;

        @sap.label         : 'Correspondence lang.'
        @sap.quickinfo     : 'Business Partner: Correspondence Language'
        CorrespondenceLanguage         : String(2);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Created by'
        @sap.quickinfo     : 'User who created the object'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        CreatedByUser                  : String(12);

        @sap.display.format: 'Date'
        @sap.label         : 'Created On'
        @sap.quickinfo     : 'Date on which the object was created'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        CreationDate                   : Date;

        @sap.label         : 'Created at'
        @sap.quickinfo     : 'Time at which the object was created'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        CreationTime                   : Time;

        @sap.label         : 'First Name'
        @sap.quickinfo     : 'First name of business partner (person)'
        FirstName                      : String(40);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Title'
        @sap.quickinfo     : 'Form-of-Address Key'
        FormOfAddress                  : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Industry sector'
        Industry                       : String(10);

        @sap.display.format: 'NonNegative'
        @sap.label         : 'Int. location no. 1'
        @sap.quickinfo     : 'International location number (part 1)'
        InternationalLocationNumber1   : String(7);

        @sap.display.format: 'NonNegative'
        @sap.label         : 'Int. location no. 2'
        @sap.quickinfo     : 'International location number (Part 2)'
        InternationalLocationNumber2   : String(5);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Female'
        @sap.quickinfo     : 'Selection: Business partner is female'
        IsFemale                       : Boolean;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Male'
        @sap.quickinfo     : 'Selection: Business partner is male'
        IsMale                         : Boolean;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Natural Person'
        @sap.quickinfo     : 'Business Partner Is a Natural Person Under the Tax Laws'
        IsNaturalPerson                : String(1);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Unknown'
        @sap.quickinfo     : 'Selection: Sex of business partner is not known'
        IsSexUnknown                   : Boolean;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Sex'
        @sap.quickinfo     : 'Sex of business partner (person)'
        GenderCodeName                 : String(1);

        @sap.label         : 'Language'
        @sap.quickinfo     : 'Business partner: Language'
        Language                       : String(2);

        @sap.display.format: 'Date'
        @sap.label         : 'Changed on'
        @sap.quickinfo     : 'Date when object was last changed'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        LastChangeDate                 : Date;

        @sap.label         : 'Changed at'
        @sap.quickinfo     : 'Time at which object was last changed'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        LastChangeTime                 : Time;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Changed by'
        @sap.quickinfo     : 'Last user to change object'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        LastChangedByUser              : String(12);

        @sap.label         : 'Last Name'
        @sap.quickinfo     : 'Last name of business partner (person)'
        LastName                       : String(40);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Legal form'
        @sap.quickinfo     : 'BP: Legal form of organization'
        LegalForm                      : String(2);

        @sap.label         : 'Name 1'
        @sap.quickinfo     : 'Name 1 of organization'
        OrganizationBPName1            : String(40);

        @sap.label         : 'Name 2'
        @sap.quickinfo     : 'Name 2 of organization'
        OrganizationBPName2            : String(40);

        @sap.label         : 'Name 3'
        @sap.quickinfo     : 'Name 3 of organization'
        OrganizationBPName3            : String(40);

        @sap.label         : 'Name 4'
        @sap.quickinfo     : 'Name 4 of organization'
        OrganizationBPName4            : String(40);

        @sap.display.format: 'Date'
        @sap.label         : 'Date founded'
        @sap.quickinfo     : 'Date organization founded'
        OrganizationFoundationDate     : Date;

        @sap.display.format: 'Date'
        @sap.label         : 'Liquidation date'
        @sap.quickinfo     : 'Liquidation date of organization'
        OrganizationLiquidationDate    : Date;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Search Term 1'
        @sap.quickinfo     : 'Search Term 1 for Business Partner'
        SearchTerm1                    : String(20);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Search Term 2'
        @sap.quickinfo     : 'Search Term 2 for Business Partner'
        SearchTerm2                    : String(20);

        @sap.label         : 'Other Last Name'
        @sap.quickinfo     : 'Other Last Name of a Person'
        AdditionalLastName             : String(40);

        @sap.display.format: 'Date'
        @sap.label         : 'Date of Birth'
        @sap.quickinfo     : 'Date of Birth of Business Partner'
        BirthDate                      : Date;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Birth Date Status'
        @sap.quickinfo     : 'Date of Birth: Status'
        BusinessPartnerBirthDateStatus : String(1);

        @sap.label         : 'Birthplace'
        @sap.quickinfo     : 'Birthplace of business partner'
        BusinessPartnerBirthplaceName  : String(40);

        @sap.display.format: 'Date'
        @sap.label         : 'Death date'
        @sap.quickinfo     : 'Date of death of business partner'
        BusinessPartnerDeathDate       : Date;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Central Block'
        @sap.quickinfo     : 'Central Block for Business Partner'
        BusinessPartnerIsBlocked       : Boolean;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'BP Type'
        @sap.quickinfo     : 'Business Partner Type'
        BusinessPartnerType            : String(4);

        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        ETag                           : String(26);

        @sap.label         : 'Name 1'
        @sap.quickinfo     : 'Name 1 (group)'
        GroupBusinessPartnerName1      : String(40);

        @sap.label         : 'Name 2'
        @sap.quickinfo     : 'Name 2 (group)'
        GroupBusinessPartnerName2      : String(40);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Address Number'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        IndependentAddressID           : String(10);

        @sap.display.format: 'NonNegative'
        @sap.label         : 'Check digit'
        @sap.quickinfo     : 'Check digit for the international location number'
        InternationalLocationNumber3   : String(1);

        @sap.label         : 'Middle Name'
        @sap.quickinfo     : 'Middle name or second forename of a person'
        MiddleName                     : String(40);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Ctry/Reg. for Format'
        @sap.quickinfo     : 'Country/Region for Name Format Rule'
        NameCountry                    : String(3);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Name Format'
        @sap.quickinfo     : 'Name format'
        NameFormat                     : String(2);

        @sap.label         : 'Full Name'
        PersonFullName                 : String(80);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Person Number'
        @sap.creatable     : 'false'
        @sap.updatable     : 'false'
        PersonNumber                   : String(10);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Archiving Flag'
        @sap.quickinfo     : 'Central Archiving Flag'
        IsMarkedForArchiving           : Boolean;

        @sap.display.format: 'UpperCase'
        @sap.label         : 'External BP Number'
        @sap.quickinfo     : 'Business Partner Number in External System'
        BusinessPartnerIDByExtSystem   : String(20);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Print Format'
        @sap.quickinfo     : 'Business Partner Print Format'
        BusinessPartnerPrintFormat     : String(1);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Occupation'
        @sap.quickinfo     : 'Occupation/group'
        BusinessPartnerOccupation      : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Marital Status'
        @sap.quickinfo     : 'Marital Status of Business Partner'
        BusPartMaritalStatus           : String(1);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Nationality'
        BusPartNationality             : String(3);

        @sap.label         : 'Name at Birth'
        @sap.quickinfo     : 'Name at birth of business partner'
        BusinessPartnerBirthName       : String(40);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Name Supplement'
        @sap.quickinfo     : 'Name supplement, e.g. noble title (key)'
        BusinessPartnerSupplementName  : String(4);

        @sap.label         : 'Employer'
        @sap.quickinfo     : 'Name of Employer of a Natural Person'
        NaturalPersonEmployerName      : String(35);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Prefix Key'
        @sap.quickinfo     : 'Name Prefix (Key)'
        LastNamePrefix                 : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : '2nd prefix'
        @sap.quickinfo     : '2nd name prefix (key)'
        LastNameSecondPrefix           : String(4);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Initials'
        @sap.quickinfo     : '&quot;Middle Initial&quot; or personal initials'
        Initials                       : String(10);

        @sap.display.format: 'UpperCase'
        @sap.label         : 'Trading Partner No.'
        @sap.quickinfo     : 'Company ID of Trading Partner'
        TradingPartner                 : String(6);
};

extend BusinessPartnerLocal with {
    cachedOn : DateTime default $now;
}
