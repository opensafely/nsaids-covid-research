from cohortextractor import (
    codelist_from_csv,
    codelist,
)


# drug placeholder
ics_codes = codelist_from_csv(
    "codelists/opensafely-high-dose-ics-inhalers.csv",
    system="snomed",
    column="id",
    )

# OUTCOME CODELISTS
covid_identification = codelist_from_csv(
    "codelists/opensafely-covid-identification.csv",
    system="icd10",
    column="icd10_code",
)

# DEMOGRAPHIC CODELIST
ethnicity_codes = codelist_from_csv(
    "codelists/opensafely-ethnicity.csv",
    system="ctv3",
    column="Code",
    category_column="Grouping_6",
)

# SMOKING CODELIST
clear_smoking_codes = codelist_from_csv(
    "codelists/opensafely-smoking-clear.csv",
    system="ctv3",
    column="CTV3Code",
    category_column="Category",
)

unclear_smoking_codes = codelist_from_csv(
    "codelists/opensafely-smoking-unclear.csv",
    system="ctv3",
    column="CTV3Code",
    category_column="Category",
)

# CLINICAL CONDITIONS CODELISTS
heart_failure_codes = codelist_from_csv(
    "codelists/opensafely-heart-failure.csv", system="ctv3", column="CTV3ID",
)

hypertension_codes = codelist_from_csv(
    "codelists/opensafely-hypertension.csv", system="ctv3", column="CTV3ID",
)

other_heart_disease_codes = codelist_from_csv(
    "codelists/opensafely-other-heart-disease.csv", system="ctv3", column="CTV3ID",
)

diabetes_codes = codelist_from_csv(
    "codelists/opensafely-diabetes.csv", system="ctv3", column="CTV3ID",
)

hba1c_new_codes = codelist(["XaPbt", "Xaeze", "Xaezd"], system="ctv3")
hba1c_old_codes = codelist(["X772q", "XaERo", "XaERp"], system="ctv3")

lung_cancer_codes = codelist_from_csv(
    "codelists/opensafely-lung-cancer.csv", system="ctv3", column="CTV3ID",
)

haem_cancer_codes = codelist_from_csv(
    "codelists/opensafely-haematological-cancer.csv", system="ctv3", column="CTV3ID",
)

other_cancer_codes = codelist_from_csv(
    "codelists/opensafely-cancer-excluding-lung-and-haematological.csv",
    system="ctv3",
    column="CTV3ID",
)

aplastic_codes = codelist_from_csv(
    "codelists/opensafely-aplastic-anaemia.csv", system="ctv3", column="CTV3ID",
)

hiv_codes = codelist_from_csv(
    "codelists/opensafely-hiv.csv", system="ctv3", column="CTV3ID",
)

permanent_immune_codes = codelist_from_csv(
    "codelists/opensafely-permanent-immunosuppression.csv",
    system="ctv3",
    column="CTV3ID",
)

organ_transplant_codes = codelist_from_csv(
    "codelists/opensafely-solid-organ-transplantation.csv",
    system="ctv3",
    column="CTV3ID",
)

spleen_codes = codelist_from_csv(
    "codelists/opensafely-asplenia.csv", system="ctv3", column="CTV3ID",
)

sickle_cell_codes = codelist_from_csv(
    "codelists/opensafely-sickle-cell-disease.csv", system="ctv3", column="CTV3ID",
)

temp_immune_codes = codelist_from_csv(
    "codelists/opensafely-temporary-immunosuppression.csv",
    system="ctv3",
    column="CTV3ID",
)

stroke_codes  = codelist_from_csv(
    "codelists/opensafely-stroke-updated.csv",
    system="ctv3",
    column="CTV3ID",
)



gi_bleed_ulcer_codes  = codelist_from_csv(
    "codelists/opensafely-gi-bleed-or-ulcer.csv",
    system="ctv3",
    column="CTV3ID",
)


creatinine_codes = codelist(["XE2q5"], system="ctv3")

#The following is an imperfect description but left as is for consistency until resolution of https://github.com/ebmdatalab/opencodelists/issues/39
ckd_codes = codelist_from_csv(
    "codelists/opensafely-chronic-kidney-disease.csv", system="ctv3", column="CTV3ID",
)

copd_codes = codelist_from_csv(
    "codelists/opensafely-current-copd.csv", system="ctv3", column="CTV3ID",
)

other_respiratory_codes = codelist_from_csv(
    "codelists/opensafely-other-respiratory-conditions.csv",
    system="ctv3",
    column="CTV3ID",
)

current_asthma_codes = codelist_from_csv(
    "codelists/opensafely-current-asthma.csv",
    system="ctv3",
    column="CTV3ID",
)

mi_codes = codelist_from_csv(
    "codelists/opensafely-myocardial-infarction.csv",
    system="ctv3",
    column="CTV3ID",
)

rheumatoid_codes = codelist_from_csv(
    "codelists/opensafely-rheumatoid-arthritis.csv", system="ctv3", column="CTV3ID",
)

osteoarthritis_codes = codelist_from_csv(
    "codelists/opensafely-osteoarthritis.csv", system="ctv3", column="CTV3ID",
)

# VACCINATION
flu_med_codes = codelist_from_csv(
    "codelists/opensafely-influenza-vaccination.csv",
    system="snomed",
    column="snomed_id",
)

pneumococcal_med_codes = codelist_from_csv(
    "codelists/opensafely-pneumococcal-vaccination.csv",
    system="snomed",
    column="snomed_id",
)

flu_clinical_given_codes = codelist_from_csv(
    "codelists/opensafely-influenza-vaccination-clinical-codes-given.csv",
    system="ctv3",
    column="CTV3ID",
)

flu_clinical_not_given_codes = codelist_from_csv(
    "codelists/opensafely-influenza-vaccination-clinical-codes-not-given.csv",
    system="ctv3",
    column="CTV3ID",
)

pneumococcal_clinical_given_codes = codelist_from_csv(
    "codelists/opensafely-pneumococcal-vaccination-clinical-codes-indicative-of-being-administered.csv",
    system="ctv3",
    column="CTV3ID",
)
pneumococcal_clinical_not_given_codes = codelist_from_csv(
    "codelists/opensafely-pneumococcal-vaccination-clinical-codes-indicative-of-not-being-administered.csv",
    system="ctv3",
    column="CTV3ID",
)

# MEDICATIONS
nsaid_codes = codelist_from_csv(
    "codelists/opensafely-nsaids-oral.csv",
    system="snomed",
    column="snomed_id",
    )

naproxen_high_codes = codelist_from_csv(
    "codelists/opensafely-naproxen-high-dose.csv",
    system="snomed",
    column="id",
    )

naproxen_low_codes = codelist_from_csv(
    "codelists/opensafely-naproxen-low-dose.csv",
    system="snomed",
    column="id",
    )

naproxen_other_codes = codelist_from_csv(
    "codelists/opensafely-naproxen-other-doses.csv",
    system="snomed",
    column="id",
    )

cox_medication = codelist_from_csv(
    "codelists/opensafely-cox-2-specific-nsaids.csv",
    system="snomed",
    column="snomed_id",
    )

aspirin_med_codes = codelist_from_csv(
    "codelists/opensafely-aspirin.csv",
    system="snomed",
    column="id",
    )

ibuprofen_med_codes = codelist_from_csv(
    "codelists/opensafely-ibuprofen-oral.csv",
    system="snomed",
    column="snomed_id",
    )

statin_med_codes = codelist_from_csv(
    "codelists/opensafely-statin-medication.csv", system="snomed", column="id",
)

ppi_med_codes = codelist_from_csv(
    "codelists/opensafely-proton-pump-inhibitors-ppi-oral.csv",
    system="snomed",
    column="id",
)

indometacin_codes = codelist_from_csv(
    "codelists/opensafely-indometacin.csv",
    system="snomed",
    column="snomed_id",
)

prednisolone_med_codes = codelist_from_csv(
    "codelists/opensafely-asthma-oral-prednisolone-medication.csv",
    system="snomed",
    column="snomed_id",
)

hcq_med_code = codelist_from_csv(
    "codelists/opensafely-hydroxychloroquine.csv",
    system="snomed",
    column="snomed_id",
)

dmards_med_code = codelist_from_csv(
    "codelists/opensafely-dmards.csv",
    system="snomed",
    column="snomed_id",
)

saba_med_codes = codelist_from_csv(
    "codelists/opensafely-saba-inhaler-medications.csv",
    system="snomed",
    column="id",
)
