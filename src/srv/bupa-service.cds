using {BusinessPartnerLocal} from '../db/bupa-local';

service API_BUSINESS_PARTNER {
    entity BusinessPartnersLocal  as projection on BusinessPartnerLocal;
}

annotate API_BUSINESS_PARTNER.BusinessPartnersLocal with @odata.draft.enabled;
