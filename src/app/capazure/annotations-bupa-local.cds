using API_BUSINESS_PARTNER as service from '../../srv/bupa-service';

annotate service.BusinessPartnersLocal with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'BusinessPartner',
            Value : BusinessPartner,
        },
        {
            $Type : 'UI.DataField',
            Value : FirstName,
            Label : 'FirstName',
        },
        {
            $Type : 'UI.DataField',
            Value : LastName,
            Label : 'LastName',
        },
        {
            $Type : 'UI.DataField',
            Value : BirthDate,
            Label : 'BirthDate',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerIsBlocked,
            Label : 'BusinessPartnerIsBlocked',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerUUID,
            Label : 'BusinessPartnerUUID',
        },
        {
            $Type : 'UI.DataField',
            Value : IsFemale,
            Label : 'IsFemale',
        },
        {
            $Type : 'UI.DataField',
            Value : IsMale,
            Label : 'IsMale',
        },
        {
            $Type : 'UI.DataField',
            Value : Language,
            Label : 'Language',
        },
        {
            $Type : 'UI.DataField',
            Value : LastChangeDate,
            Label : 'LastChangeDate',
        },
        {
            $Type : 'UI.DataField',
            Value : LastChangedByUser,
            Label : 'LastChangedByUser',
        },
        {
            $Type : 'UI.DataField',
            Value : LastChangeTime,
            Label : 'LastChangeTime',
        },
        {
            $Type : 'UI.DataField',
            Value : MiddleName,
            Label : 'MiddleName',
        },
        {
            $Type : 'UI.DataField',
            Value : AcademicTitle,
            Label : 'AcademicTitle',
        },
        {
            $Type : 'UI.DataField',
            Value : AdditionalLastName,
            Label : 'AdditionalLastName',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerBirthName,
            Label : 'BusinessPartnerBirthName',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerBirthplaceName,
            Label : 'BusinessPartnerBirthplaceName',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerCategory,
            Label : 'BusinessPartnerCategory',
        },
        {
            $Type : 'UI.DataField',
            Value : BusinessPartnerType,
            Label : 'BusinessPartnerType',
        },
        {
            $Type : 'UI.DataField',
            Value : BusPartNationality,
            Label : 'BusPartNationality',
        },
    ]
);
annotate service.BusinessPartnersLocal with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartner',
                Value : BusinessPartner,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Customer',
                Value : Customer,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Supplier',
                Value : Supplier,
            },
            {
                $Type : 'UI.DataField',
                Label : 'AcademicTitle',
                Value : AcademicTitle,
            },
            {
                $Type : 'UI.DataField',
                Label : 'AuthorizationGroup',
                Value : AuthorizationGroup,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerCategory',
                Value : BusinessPartnerCategory,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerFullName',
                Value : BusinessPartnerFullName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerGrouping',
                Value : BusinessPartnerGrouping,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerName',
                Value : BusinessPartnerName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CorrespondenceLanguage',
                Value : CorrespondenceLanguage,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CreatedByUser',
                Value : CreatedByUser,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CreationDate',
                Value : CreationDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CreationTime',
                Value : CreationTime,
            },
            {
                $Type : 'UI.DataField',
                Label : 'FirstName',
                Value : FirstName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'FormOfAddress',
                Value : FormOfAddress,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Industry',
                Value : Industry,
            },
            {
                $Type : 'UI.DataField',
                Label : 'InternationalLocationNumber1',
                Value : InternationalLocationNumber1,
            },
            {
                $Type : 'UI.DataField',
                Label : 'InternationalLocationNumber2',
                Value : InternationalLocationNumber2,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IsFemale',
                Value : IsFemale,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IsMale',
                Value : IsMale,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IsNaturalPerson',
                Value : IsNaturalPerson,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IsSexUnknown',
                Value : IsSexUnknown,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GenderCodeName',
                Value : GenderCodeName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Language',
                Value : Language,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastChangeDate',
                Value : LastChangeDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastChangeTime',
                Value : LastChangeTime,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastChangedByUser',
                Value : LastChangedByUser,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastName',
                Value : LastName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LegalForm',
                Value : LegalForm,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationBPName1',
                Value : OrganizationBPName1,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationBPName2',
                Value : OrganizationBPName2,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationBPName3',
                Value : OrganizationBPName3,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationBPName4',
                Value : OrganizationBPName4,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationFoundationDate',
                Value : OrganizationFoundationDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OrganizationLiquidationDate',
                Value : OrganizationLiquidationDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'SearchTerm1',
                Value : SearchTerm1,
            },
            {
                $Type : 'UI.DataField',
                Label : 'SearchTerm2',
                Value : SearchTerm2,
            },
            {
                $Type : 'UI.DataField',
                Label : 'AdditionalLastName',
                Value : AdditionalLastName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BirthDate',
                Value : BirthDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerBirthDateStatus',
                Value : BusinessPartnerBirthDateStatus,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerBirthplaceName',
                Value : BusinessPartnerBirthplaceName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerDeathDate',
                Value : BusinessPartnerDeathDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerIsBlocked',
                Value : BusinessPartnerIsBlocked,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerType',
                Value : BusinessPartnerType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'ETag',
                Value : ETag,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GroupBusinessPartnerName1',
                Value : GroupBusinessPartnerName1,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GroupBusinessPartnerName2',
                Value : GroupBusinessPartnerName2,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IndependentAddressID',
                Value : IndependentAddressID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'InternationalLocationNumber3',
                Value : InternationalLocationNumber3,
            },
            {
                $Type : 'UI.DataField',
                Label : 'MiddleName',
                Value : MiddleName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NameCountry',
                Value : NameCountry,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NameFormat',
                Value : NameFormat,
            },
            {
                $Type : 'UI.DataField',
                Label : 'PersonFullName',
                Value : PersonFullName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'PersonNumber',
                Value : PersonNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'IsMarkedForArchiving',
                Value : IsMarkedForArchiving,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerIDByExtSystem',
                Value : BusinessPartnerIDByExtSystem,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerPrintFormat',
                Value : BusinessPartnerPrintFormat,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerOccupation',
                Value : BusinessPartnerOccupation,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusPartMaritalStatus',
                Value : BusPartMaritalStatus,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusPartNationality',
                Value : BusPartNationality,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerBirthName',
                Value : BusinessPartnerBirthName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'BusinessPartnerSupplementName',
                Value : BusinessPartnerSupplementName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NaturalPersonEmployerName',
                Value : NaturalPersonEmployerName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastNamePrefix',
                Value : LastNamePrefix,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LastNameSecondPrefix',
                Value : LastNameSecondPrefix,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Initials',
                Value : Initials,
            },
            {
                $Type : 'UI.DataField',
                Label : 'TradingPartner',
                Value : TradingPartner,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
