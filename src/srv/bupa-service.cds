using {s4_bp as external} from './external/metadata-bp';

service API_BUSINESS_PARTNER {
    entity BusinessPartners as projection on external.A_BusinessPartner excluding {
        to_BuPaIdentification,
        to_BuPaIndustry,
        to_BusinessPartnerAddress,
        to_BusinessPartnerBank,
        to_BusinessPartnerContact,
        to_BusinessPartnerRole,
        to_BusinessPartnerTax,
        to_BusPartAddrDepdntTaxNmbr,
        to_Customer,
        to_Supplier
    }
}
