from cohortextractor import (
    StudyDefinition,
    patients,
    filter_codes_by_category,
    combine_codelists,
)

from codelists import *

study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.5,
    },
    # STUDY POPULATION
    population=patients.satisfying(
        """
            has_follow_up AND
            (age >=18 AND age <= 110) AND
            (rheumatoid OR osteoarthritis) AND
            imd >0 AND NOT (
            (has_asthma AND saba_single) OR
            aspirin_ten_years OR
            stroke OR
            mi OR
            gi_bleed_ulcer
            )
            """,
        has_follow_up=patients.registered_with_one_practice_between(
            "2019-02-28", "2020-02-29"
        ),
        has_asthma=patients.with_these_clinical_events(
            current_asthma_codes, between=["2017-02-28", "2020-02-29"],
        ),
    ),
    # The rest of the lines define the covariates with from the protocol with associated GitHub issues
    # OUTCOMES
    died_ons_covid_flag_any=patients.with_these_codes_on_death_certificate(
        covid_identification,
        on_or_after="2020-03-01",
        match_only_underlying_cause=False,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    died_ons_covid_flag_underlying=patients.with_these_codes_on_death_certificate(
        covid_identification,
        on_or_after="2020-03-01",
        match_only_underlying_cause=True,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    died_date_ons=patients.died_from_any_cause(
        on_or_after="2020-03-01",
        returning="date_of_death",
        include_month=True,
        include_day=True,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    # PLACEHOLDER - SECONDARY OUTCOME:PRESENTING AT ED - this is a wip placeholder
    aande_attendance_with_covid=patients.attended_emergency_care(
        on_or_after="2020-03-01",
        returning="date_arrived",
        date_format="YYYY-MM-DD",
        with_these_diagnoses=ics_codes,  # placeholder https://github.com/opensafely/cohort-extractor/issues/182#issuecomment-651782064
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    # MEDICATIONS
    # NSAID
    nsaid_last_three_years=patients.with_these_medications(
        nsaid_codes,
        between=["2017-02-28", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    nsaid_after_march=patients.with_these_medications(
        nsaid_codes,
        on_or_after="2020-03-01",
        returning="date",
        find_first_match_in_period=True,
        include_month=True,
        include_day=True,
        return_expectations={
            "date": {"earliest": "2020-03-01", "latest": "2020-05-29"}
        },
    ),
    nsaid_last_four_months=patients.with_these_medications(
        nsaid_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    nsaid_last_two_months=patients.with_these_medications(
        nsaid_codes,
        between=["2020-01-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2020-01-01", "latest": "2020-02-29"}
        },
    ),
    # naproxen - high dose
    naproxen_high=patients.with_these_medications(
        naproxen_high_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # naproxen low dose
    naproxen_low=patients.with_these_medications(
        naproxen_low_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # naproxen - other
    naproxen_other=patients.with_these_medications(
        naproxen_other_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # COX2 SPECIFIC
    cox_medication=patients.with_these_medications(
        cox_medication,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # ASPIRIN
    aspirin_ten_years=patients.with_these_medications(
        aspirin_med_codes,
        between=["2010-02-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2010-11-01", "latest": "2020-02-29"}
        },
    ),
    aspirin_ever=patients.with_these_medications(
        aspirin_med_codes,
        on_or_before="2020-02-29",
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2010-11-01", "latest": "2020-02-29"}
        },
    ),
    # IBUPROFEN
    ibuprofen=patients.with_these_medications(
        ibuprofen_med_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # indometacin
    indometacin=patients.with_these_medications(
        indometacin_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    # Oral steroid - prednisolone
    steroid_prednisolone=patients.with_these_medications(
        prednisolone_med_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    # hydroxychloqoquine
    hydroxychloroquine=patients.with_these_medications(
        hcq_med_code,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    # dmards
    dmards_primary_care=patients.with_these_medications(
        dmards_med_code,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2017-02-28", "latest": "2020-02-29"}
        },
    ),
    # The rest of the lines define the covariates with from the protocol with associated GitHub issues
    # https://github.com/opensafely/nsaids-research/issues/1
    # PATIENT DEMOGRAPHICS
    age=patients.age_as_of(
        "2020-03-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),
    stp=patients.registered_practice_as_of(
        "2020-02-29",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "STP1": 0.1,
                    "STP2": 0.1,
                    "STP3": 0.1,
                    "STP4": 0.1,
                    "STP5": 0.1,
                    "STP6": 0.1,
                    "STP7": 0.1,
                    "STP8": 0.1,
                    "STP9": 0.1,
                    "STP10": 0.1,
                }
            },
        },
    ),
    imd=patients.address_as_of(
        "2020-02-29",
        returning="index_of_multiple_deprivation",
        round_to_nearest=100,
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"100": 0.1, "200": 0.2, "300": 0.7}},
        },
    ),
    msoa=patients.registered_practice_as_of(
        "2020-02-01",
        returning="msoa_code",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"MSOA1": 0.5, "MSOA2": 0.5}},
        },
    ),
    rural_urban=patients.address_as_of(
        "2020-02-01",
        returning="rural_urban_classification",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"rural": 0.1, "urban": 0.9}},
        },
    ),
    ethnicity=patients.with_these_clinical_events(
        ethnicity_codes,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=True,
        return_expectations={
            "category": {"ratios": {"1": 0.8, "5": 0.1, "3": 0.1}},
            "incidence": 0.75,
        },
    ),
    # CLINICAL COVARIATES
    # BMI
    bmi=patients.most_recent_bmi(
        on_or_after="2010-02-01",
        minimum_age_at_measurement=16,
        include_measurement_date=True,
        include_month=True,
        return_expectations={
            "incidence": 0.6,
            "float": {"distribution": "normal", "mean": 35, "stddev": 10},
        },
    ),
    # SMOKING
    smoking_status=patients.categorised_as(
        {
            "S": "most_recent_smoking_code = 'S'",
            "E": """
                     most_recent_smoking_code = 'E' OR (    
                       most_recent_smoking_code = 'N' AND ever_smoked   
                     )  
                """,
            "N": "most_recent_smoking_code = 'N' AND NOT ever_smoked",
            "M": "DEFAULT",
        },
        return_expectations={
            "category": {"ratios": {"S": 0.6, "E": 0.1, "N": 0.2, "M": 0.1}}
        },
        most_recent_smoking_code=patients.with_these_clinical_events(
            clear_smoking_codes,
            find_last_match_in_period=True,
            on_or_before="2020-02-29",
            returning="category",
        ),
        ever_smoked=patients.with_these_clinical_events(
            filter_codes_by_category(clear_smoking_codes, include=["S", "E"]),
            on_or_before="2020-02-29",
        ),
    ),
    smoking_status_date=patients.with_these_clinical_events(
        clear_smoking_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # HYPERTENSION - CLINICAL CODES ONLY
    hypertension=patients.with_these_clinical_events(
        hypertension_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # HEART FAILURE
    heart_failure=patients.with_these_clinical_events(
        heart_failure_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # OTHER HEART DISEASES
    other_heart_disease=patients.with_these_clinical_events(
        other_heart_disease_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # DIABETES
    diabetes=patients.with_these_clinical_events(
        diabetes_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    hba1c_mmol_per_mol=patients.with_these_clinical_events(
        hba1c_new_codes,
        find_last_match_in_period=True,
        on_or_before="2020-02-29",
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "date": {"latest": "2020-02-29"},
            "float": {"distribution": "normal", "mean": 40.0, "stddev": 20},
            "incidence": 0.95,
        },
    ),
    hba1c_percentage=patients.with_these_clinical_events(
        hba1c_old_codes,
        find_last_match_in_period=True,
        on_or_before="2020-02-29",
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "date": {"latest": "2020-02-29"},
            "float": {"distribution": "normal", "mean": 5, "stddev": 2},
            "incidence": 0.95,
        },
    ),
    # COPD
    copd=patients.with_these_clinical_events(
        copd_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # OTHER RESPIRATORY DISEASES
    other_respiratory=patients.with_these_clinical_events(
        other_respiratory_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # CURRENT ASTHMA
    asthma=patients.with_these_clinical_events(
        current_asthma_codes,
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # CANCER - 3 TYPES
    cancer=patients.with_these_clinical_events(
        combine_codelists(lung_cancer_codes, haem_cancer_codes, other_cancer_codes),
        on_or_before="2020-02-29",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # IMMUNOSUPPRESSION
    #### PERMANENT
    permanent_immunodeficiency=patients.with_these_clinical_events(
        combine_codelists(
            hiv_codes,
            permanent_immune_codes,
            sickle_cell_codes,
            organ_transplant_codes,
            spleen_codes,
        ),
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    aplastic_anaemia=patients.with_these_clinical_events(
        aplastic_codes,
        between=["2019-03-01", "2020-02-29"],
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2019-03-01", "latest": "2020-02-29"}
        },
    ),
    #### TEMPORARY
    temporary_immunodeficiency=patients.with_these_clinical_events(
        temp_immune_codes,
        between=["2019-03-01", "2020-02-29"],
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2019-03-01", "latest": "2020-02-29"}
        },
    ),
    # CKD
    creatinine=patients.with_these_clinical_events(
        creatinine_codes,
        find_last_match_in_period=True,
        between=["2019-02-28", "2020-02-29"],
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "float": {"distribution": "normal", "mean": 60.0, "stddev": 15},
            "date": {"earliest": "2019-02-28", "latest": "2020-02-29"},
            "incidence": 0.95,
        },
    ),
    #### end stage renal disease codes incl. dialysis / transplant
    esrf=patients.with_these_clinical_events(
        ckd_codes,  # CHECK IS THIS DEF RIGHT HERE
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    #### stroke
    stroke=patients.with_these_clinical_events(
        stroke_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    #### Myocardial infarction
    mi=patients.with_these_clinical_events(
        mi_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    #### GI BLEED
    gi_bleed_ulcer=patients.with_these_clinical_events(
        gi_bleed_ulcer_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # OSTEOARTHRITIS
    osteoarthritis=patients.with_these_clinical_events(
        osteoarthritis_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # RHEUMATOID ARTHRITIS
    rheumatoid=patients.with_these_clinical_events(
        rheumatoid_codes,
        on_or_before="2020-02-29",
        return_last_date_in_period=True,
        include_month=True,
        return_expectations={"date": {"latest": "2020-02-29"}},
    ),
    # RHEUMATOID ARTHRITIS/OSTEOARTHRITIS MIXED - PLACEHOLDER
    mixed_arthritis=patients.categorised_as(
        {
            "R": "rheumatoid = 'R'",
            "O": "osteoarthritis = 'O'",
            "RO": """
                    rheumatoid OR osteoarthritis
                  """,
            "M": "DEFAULT",
        },
        return_expectations={
            "category": {"ratios": {"R": 0.3, "O": 0.1, "RO": 0.2, "M": 0.4}}
        },
    ),
    # FLU VACCINATION STATUS
    flu_vaccine_tpp_table=patients.with_tpp_vaccination_record(
        target_disease_matches="INFLUENZA",
        between=["2019-09-01", "2020-02-29"],  # current flu season
        returning="date",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2019-09-01", "latest": "2020-02-29"}
        },
    ),
    flu_vaccine_med=patients.with_these_medications(
        flu_med_codes,
        between=["2019-09-01", "2020-02-29"],  # current flu season
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=True,
        return_expectations={
            "date": {"earliest": "2019-09-01", "latest": "2020-02-29"}
        },
    ),
    flu_vaccine_clinical=patients.with_these_clinical_events(
        flu_clinical_given_codes,
        ignore_days_where_these_codes_occur=flu_clinical_not_given_codes,
        between=["2019-09-01", "2020-02-29"],  # current flu season
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2019-09-01", "latest": "2020-02-29"}
        },
    ),
    flu_vaccine=patients.satisfying(
        """
        flu_vaccine_tpp_table OR
        flu_vaccine_med OR
        flu_vaccine_clinical
        """,
    ),
    # PNEUMOCOCCAL VACCINATION STATUS
    pneumococcal_vaccine_tpp_table=patients.with_tpp_vaccination_record(
        target_disease_matches="PNEUMOCOCCAL",
        between=["2015-03-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2015-03-01", "latest": "2020-02-29"}
        },
    ),
    pneumococcal_vaccine_med=patients.with_these_medications(
        pneumococcal_med_codes,
        between=["2015-03-01", "2020-02-29"],  # past five years
        returning="date",
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2015-03-01", "latest": "2020-02-29"}
        },
    ),
    pneumococcal_vaccine_clinical=patients.with_these_clinical_events(
        pneumococcal_clinical_given_codes,
        ignore_days_where_these_codes_occur=pneumococcal_clinical_not_given_codes,
        between=["2015-03-01", "2020-02-29"],  # past five years
        return_first_date_in_period=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2015-03-01", "latest": "2020-02-29"}
        },
    ),
    pneumococcal_vaccine=patients.satisfying(
        """
        pneumococcal_vaccine_tpp_table OR
        pneumococcal_vaccine_med OR
        pneumococcal_vaccine_clinical
        """,
    ),
    # STATIN USAGE
    statin=patients.with_these_medications(
        statin_med_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    # PROTON PUMP INHIBITOR USAGE
    ppi=patients.with_these_medications(
        ppi_med_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"}
        },
    ),
    #### SABA SINGLE CONSTITUENT - asthma treatment
    saba_single=patients.with_these_medications(
        saba_med_codes,
        between=["2019-11-01", "2020-02-29"],
        returning="date",
        find_last_match_in_period=True,
        include_month=True,
        include_day=False,
        return_expectations={
            "date": {"earliest": "2019-11-01", "latest": "2020-02-29"},
        },
    ),
    ##A&E ATTENDANCE IN PREVIOUS YEAR
    annde_attendance_last_year=patients.attended_emergency_care(
        between=["2019-03-01", "2020-02-29"],
        returning="number_of_matches_in_period",
        return_expectations={
            "int": {"distribution": "normal", "mean": 2, "stddev": 2},
            "date": {"earliest": "2019-03-01", "latest": "2020-02-29"},
            "incidence": 0.3,
        },
    ),
    ### GP CONSULTATION RATE
    gp_consult_count=patients.with_gp_consultations(
        between=["2019-03-01", "2020-02-29"],
        returning="number_of_matches_in_period",
        return_expectations={
            "int": {"distribution": "normal", "mean": 4, "stddev": 2},
            "date": {"earliest": "2019-03-01", "latest": "2020-02-29"},
            "incidence": 0.7,
        },
    ),
    has_consultation_history=patients.with_complete_gp_consultation_history_between(
        "2019-03-01", "2020-02-29", return_expectations={"incidence": 0.9},
    ),
)
