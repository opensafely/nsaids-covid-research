# OpenSAFELY Association between routine use of NSAIDs and COVID-19 deaths

This is the code and configuration of our pre-print paper available on MedRxiv [here](https://www.medrxiv.org/content/10.1101/2020.08.12.20171405v1). You can sign up for the [OpenSAFELY email newsletter here](https://opensafely.org/contact/) for updates about this study and other OpenSAFELY projects.

* The paper is [here](https://ard.bmj.com/content/early/2021/01/20/annrheumdis-2020-219517.full#main-content)
* Raw model outputs, including charts, crosstabs, etc, are in `paper_revision_redacted_outputs/`
- If you are interested in how we defined our variables, take a look at the [study definition for study 1](analysis/study_definition_nsaid_population.py) and [study definition for study 2](analysis/study_definition_ra_oa_population.py); this is written in `python`, but non-programmers should be able to understand what is going on there
* If you are interested in how we defined our code lists, look in the [codelists folder](./codelists/). All codelists are available online at [OpenCodelists](https://codelists.opensafely.org/) for inspection and re-use by anyone 
* Developers and epidemiologists interested in the framework should review [the OpenSAFELY documentation](https://docs.opensafely.org)

# About the OpenSAFELY framework

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).