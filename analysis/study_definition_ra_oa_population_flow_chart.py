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
    population=patients.all(),
    # has_follow_up AND
    # (age >=18 AND age <= 110) AND
    # (rheumatoid OR osteoarthritis) AND
    # imd >0 AND NOT (
    # (has_asthma AND saba_single) OR
    # aspirin_ten_years OR
    # stroke OR
    # mi OR
    # gi_bleed_ulcer
    # )
    has_follow_up=patients.registered_with_one_practice_between(
        "2019-02-28", "2020-02-29", return_expectations={"incidence": 0.9},
    ),
    has_asthma=patients.with_these_clinical_events(
        current_asthma_codes,
        between=["2017-02-28", "2020-02-29"],
        return_expectations={"incidence": 0.9},
    ),
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
    age=patients.age_as_of(
        "2020-03-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
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
)
