
# Code to reproduce Table 1 in the paper #

# Clean working space and load necessary libraries #

rm(list = ls())
base::set.seed(14091998)

# Load the necessary functions, packages, and specifications

func.files <- base::list.files(path = "./", pattern = "^~", full.names = TRUE)

for (file in func.files) {
  
  base::source(file)
  
}


# Read the data to import the synchronization variables 
# Note that any of the two files "synch_levels.xlsx" or "synch_synch.xlsx"
# Contain the same number of observations, we can choose any

fulldata = readxl::read_excel(base::file.path(data_path, "synch_synch.xlsx")) %>% 
  dplyr::mutate(date = as.Date(date)) %>% 
  dplyr::filter(date <= as.Date("2020-10-01"))

####################################################################################################
#                                           AR (pooled) MODELS                                     #
####################################################################################################


# Subset the data to forecast and complete with NA for some countries are missing some dates
# Keep the observation for 2018Q4 because we will need it to forecast
# We have 9 observations per country: 8 to forecast + 1 the initial one 2018Q4

ar_forecast_data = fulldata %>% 
  dplyr::filter(date >= as.Date("2018-10-01")) %>% 
  dplyr::select(country, synch,date) %>% 
  tidyr::complete(country, date) %>% 
  dplyr::mutate(f_synch = NA)

# Create all the AR models #
# We need in total 8 models (we use up until the last_obs - 1 to forecast)

ar.pooled.1 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::filter(date <= as.Date("2018-10-01"))) 

ar.pooled.2 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2019-01-01"))) 

ar.pooled.3 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2019-04-01")))

ar.pooled.4 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2019-07-01")))

ar.pooled.5 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2019-10-01"))) 

ar.pooled.6 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2020-01-01")))

ar.pooled.7 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2020-04-01"))) 

ar.pooled.8 = stats::lm(synch ~ synch_lag1 + country + factor(year), data = fulldata %>% 
                  dplyr::mutate(date = as.Date(date)) %>% 
                  dplyr::filter(date <= as.Date("2020-07-01")))




# Now, create the forecasts #
# Note that the first observation is the last observation used in the models
# Hence, it is the first one used to build the forecast
# Add not only the intercept term but also all the country fixed effects
# Remember, we omit Austria (which acts as the intercept now)

ar_forecast_data = ar_forecast_data %>% 
  dplyr::group_by(country) %>% 
  dplyr::mutate(f_synch = dplyr::case_when(
    
    row_number() == 2 ~ ar.pooled.1$coefficients[1] + ar.pooled.1$coefficients[2]*synch[1]
      +ar.pooled.1$coefficients[3]  +ar.pooled.1$coefficients[4] +ar.pooled.1$coefficients[5]
    +ar.pooled.1$coefficients[6] +ar.pooled.1$coefficients[7] +ar.pooled.1$coefficients[8]
    +ar.pooled.1$coefficients[9] +ar.pooled.1$coefficients[10] +ar.pooled.1$coefficients[11]
    +ar.pooled.1$coefficients[12] +ar.pooled.1$coefficients[13] +ar.pooled.1$coefficients[14]
    +ar.pooled.1$coefficients[15] +ar.pooled.1$coefficients[16],
    
    
    row_number() == 3 ~ ar.pooled.2$coefficients[1] + ar.pooled.2$coefficients[2]*synch[2]
    +ar.pooled.2$coefficients[3]  +ar.pooled.2$coefficients[4] +ar.pooled.2$coefficients[5]
    +ar.pooled.2$coefficients[6] +ar.pooled.2$coefficients[7] +ar.pooled.2$coefficients[8]
    +ar.pooled.2$coefficients[9] +ar.pooled.2$coefficients[10] +ar.pooled.2$coefficients[11]
    +ar.pooled.2$coefficients[12] +ar.pooled.2$coefficients[13] +ar.pooled.2$coefficients[14]
    +ar.pooled.2$coefficients[15] +ar.pooled.2$coefficients[16],
    
    
    
    row_number() == 4 ~ ar.pooled.3$coefficients[1] + ar.pooled.3$coefficients[2]*synch[3]
    +ar.pooled.3$coefficients[3]  +ar.pooled.3$coefficients[4] +ar.pooled.3$coefficients[5]
    +ar.pooled.3$coefficients[6] +ar.pooled.3$coefficients[7] +ar.pooled.3$coefficients[8]
    +ar.pooled.3$coefficients[9] +ar.pooled.3$coefficients[10] +ar.pooled.3$coefficients[11]
    +ar.pooled.3$coefficients[12] +ar.pooled.3$coefficients[13] +ar.pooled.3$coefficients[14]
    +ar.pooled.3$coefficients[15] +ar.pooled.3$coefficients[16],
    
    
    row_number() == 5 ~ ar.pooled.4$coefficients[1] + ar.pooled.4$coefficients[2]*synch[4]
    +ar.pooled.4$coefficients[3]  +ar.pooled.4$coefficients[4] +ar.pooled.4$coefficients[5]
    +ar.pooled.4$coefficients[6] +ar.pooled.4$coefficients[7] +ar.pooled.4$coefficients[8]
    +ar.pooled.4$coefficients[9] +ar.pooled.4$coefficients[10] +ar.pooled.4$coefficients[11]
    +ar.pooled.4$coefficients[12] +ar.pooled.4$coefficients[13] +ar.pooled.4$coefficients[14]
    +ar.pooled.4$coefficients[15] +ar.pooled.4$coefficients[16],
    
    
    row_number() == 6 ~ ar.pooled.5$coefficients[1] + ar.pooled.5$coefficients[2]*synch[5]
    +ar.pooled.5$coefficients[3]  +ar.pooled.5$coefficients[4] +ar.pooled.5$coefficients[5]
    +ar.pooled.5$coefficients[6] +ar.pooled.5$coefficients[7] +ar.pooled.5$coefficients[8]
    +ar.pooled.5$coefficients[9] +ar.pooled.5$coefficients[10] +ar.pooled.5$coefficients[11]
    +ar.pooled.5$coefficients[12] +ar.pooled.5$coefficients[13] +ar.pooled.5$coefficients[14]
    +ar.pooled.5$coefficients[15] +ar.pooled.5$coefficients[16],
    
    
    row_number() == 7 ~ ar.pooled.6$coefficients[1] + ar.pooled.6$coefficients[2]*synch[6]
    +ar.pooled.6$coefficients[3]  +ar.pooled.6$coefficients[4] +ar.pooled.6$coefficients[5]
    +ar.pooled.6$coefficients[6] +ar.pooled.6$coefficients[7] +ar.pooled.6$coefficients[8]
    +ar.pooled.6$coefficients[9] +ar.pooled.6$coefficients[10] +ar.pooled.6$coefficients[11]
    +ar.pooled.6$coefficients[12] +ar.pooled.6$coefficients[13] +ar.pooled.6$coefficients[14]
    +ar.pooled.6$coefficients[15] +ar.pooled.6$coefficients[16],
    
    
    row_number() == 8 ~ ar.pooled.7$coefficients[1] + ar.pooled.7$coefficients[2]*synch[7]
    +ar.pooled.7$coefficients[3]  +ar.pooled.7$coefficients[4] +ar.pooled.7$coefficients[5]
    +ar.pooled.7$coefficients[6] +ar.pooled.7$coefficients[7] +ar.pooled.7$coefficients[8]
    +ar.pooled.7$coefficients[9] +ar.pooled.7$coefficients[10] +ar.pooled.7$coefficients[11]
    +ar.pooled.7$coefficients[12] +ar.pooled.7$coefficients[13] +ar.pooled.7$coefficients[14]
    +ar.pooled.7$coefficients[15] +ar.pooled.7$coefficients[16],
    
    
    row_number() == 9 ~ ar.pooled.8$coefficients[1] + ar.pooled.8$coefficients[2]*synch[8]
    +ar.pooled.8$coefficients[3]  +ar.pooled.8$coefficients[4] +ar.pooled.8$coefficients[5]
    +ar.pooled.8$coefficients[6] +ar.pooled.8$coefficients[7] +ar.pooled.8$coefficients[8]
    +ar.pooled.8$coefficients[9] +ar.pooled.8$coefficients[10] +ar.pooled.8$coefficients[11]
    +ar.pooled.8$coefficients[12] +ar.pooled.8$coefficients[13] +ar.pooled.8$coefficients[14]
    +ar.pooled.8$coefficients[15] +ar.pooled.8$coefficients[16]
    )
    
    
    
  ) %>% 
  dplyr::ungroup()
  

# Create variable for directional accuracy

ar_forecast_data = ar_forecast_data %>% 
  dplyr::group_by(country) %>% 
  dplyr::mutate(synch_diff = synch - dplyr::lag(synch), 
         f_synch_diff = f_synch - dplyr::lag(f_synch), 
         synch_direction = dplyr::if_else(synch_diff > 0, "up", "down"), 
         f_synch_direction = dplyr::if_else(f_synch_diff > 0, "up", "down")) %>% 
  dplyr::select(-synch_diff, -f_synch_diff) %>% 
  dplyr::ungroup()
  
  

# Create squared difference between realization and forecast #

ar_forecast_data = ar_forecast_data %>% 
  dplyr::mutate(res_sq = (synch-f_synch)^2)

# Create forecasting dataset for PIIGS and non-PIIGS countries

ar_forecast_data.piigs = ar_forecast_data %>% 
  dplyr::filter(country %in% piigs_subset)

ar_forecast_data.nopiigs = ar_forecast_data %>% 
  dplyr::filter(!country %in% piigs_subset)

# Print the forecast results for all the sample (part of Table 3 in the paper)

base::cat(dir.results(ar_forecast_data), "\n")
base::cat(dir.results(ar_forecast_data.piigs), "\n")
base::cat(dir.results(ar_forecast_data.nopiigs), "\n")

# Print the forecast results without 2020 (part of Table A.5 in the paper)

base::cat(dir.results(without.2020(ar_forecast_data)), "\n")
base::cat(dir.results(without.2020(ar_forecast_data.piigs)), "\n")
base::cat(dir.results(without.2020(ar_forecast_data.nopiigs)), "\n")

####################################################################################################
#                                           AR (country-specific) MODELS                           #
####################################################################################################

# First, get the data for each country
# Get the data from "ar_forecast_data_ (already expanded)

country.specific.data = fulldata %>% 
  dplyr::select(date, country, synch, synch_lag1) %>% 
  tidyr::complete(country, date) %>% 
  dplyr::mutate(f_synch = NA)

# Create a data frame for each country

for (jj in unique(country.specific.data$country) ) { 
  nam <- base::paste(jj, ".data", sep = "")
  base::assign(nam, country.specific.data %>% 
           dplyr::filter(country == jj))
}

# Now, run the AR model for each country and predict #
# Note that 2018-10-01 is in the 72th row
# They are all the same length, so choose last iteration arbitrarily
# Create list with all datasets

country.list = base::list(austria.data, 
                    belgium.data, 
                    finland.data, 
                    france.data, 
                    germany.data, 
                    greece.data, 
                    ireland.data, 
                    italy.data, 
                    latvia.data, 
                    lithuania.data, 
                    netherlands.data, 
                    portugal.data, 
                    slovakia.data, 
                    slovenia.data, 
                    spain.data)

  for (hh in 1:length(country.list)) {
    
    current.data = country.list[[hh]]
    
  for (kk in 72:(nrow(austria.data)-1)) {
    
    
    model = stats::lm(synch~synch_lag1, data = current.data[1:kk,]) # Run the AR model
    current.data[kk+1,5] = model$coefficients[1] + model$coefficients[2] * current.data[kk,3] # Make the prediction
    
  }
  
    country.list[[hh]] = current.data

  }

# Now, simply bind rows and subset the forecasting period

ar.country.data = dplyr::bind_rows(country.list) %>% 
  dplyr::filter(date >= zoo::as.Date("2018-10-01"))


# Create variable for directional accuracy

ar.country.data = ar.country.data %>% 
  dplyr::group_by(country) %>% 
  dplyr::mutate(synch_diff = synch - dplyr::lag(synch), 
         f_synch_diff = f_synch - dplyr::lag(f_synch), 
         synch_direction = dplyr::if_else(synch_diff > 0, "up", "down"), 
         f_synch_direction = dplyr::if_else(f_synch_diff > 0, "up", "down")) %>% 
  dplyr::select(-synch_diff, -f_synch_diff) %>% 
  dplyr::ungroup()

# Create squared difference between realization and forecast #

ar.country.data = ar.country.data %>% 
  dplyr::mutate(res_sq = (synch-f_synch)^2)

# Create one dataset for PIIGS and one for non-PIIGS

ar.country.data.piigs = ar.country.data %>% 
  dplyr::filter(country %in% piigs_subset)

ar.country.data.nopiigs = ar.country.data %>% 
  dplyr::filter(!country %in% piigs_subset)

# Print the forecast results for all the sample (part of Table 3 in the paper)

base::cat(dir.results(ar.country.data), "\n")
base::cat(dir.results(ar.country.data.piigs), "\n")
base::cat(dir.results(ar.country.data.nopiigs), "\n")

# Print the forecast results without 2020 (part of Table A.5 in the paper)

base::cat(dir.results(without.2020(ar.country.data)), "\n")
base::cat(dir.results(without.2020(ar.country.data.piigs)), "\n")
base::cat(dir.results(without.2020(ar.country.data.nopiigs)), "\n")

# ####################################################################################################
# #                                           BMA MODELS                                             #
# ####################################################################################################


# Read the data: remember, for BMA we need both synch-levels and synch-synch!

# synch-levels data

synch_levels_data = readxl::read_excel(base::file.path(data_path, "synch_levels.xlsx")) %>%
  dplyr::mutate(date = as.Date(date)) %>%
  dplyr::filter(date <= as.Date("2020-10-01")) %>% 
  add.draghi.synch()

synch_levels_data = synch_levels_data %>%
  dplyr::select(-uncert,-bop,-debttogdp,-gdp,-euribor,-inflation) %>%
  fastDummies::dummy_cols(select_columns = "year", remove_first_dummy = T) %>%
  fastDummies::dummy_cols(select_columns = "country", remove_first_dummy = T) %>% 
  dplyr::select(-year, -pigs)


# synch-synch data

synch_synch_data = readxl::read_excel(base::file.path(data_path, "synch_synch.xlsx")) %>%
  dplyr::mutate(date = as.Date(date)) %>%
  dplyr::filter(date <= as.Date("2020-10-01")) %>% 
  add.draghi.synch()

synch_synch_data = synch_synch_data %>%
  dplyr::select(-uncert,-bop,-debttogdp,-gdp,-euribor,-inflation) %>%
  fastDummies::dummy_cols(select_columns = "year", remove_first_dummy = T) %>%
  fastDummies::dummy_cols(select_columns = "country", remove_first_dummy = T) %>% 
  dplyr::select(-year, -pigs)



# Create the dataset for each model where we populate the forecasted quantities
# BMA synch-levels

bma.synch.levels.forecast.data = synch_levels_data %>%
  dplyr::mutate(date = as.Date(date)) %>%
  dplyr::filter(date >= "2018-10-01") %>% 
  tidyr::complete(country, date) %>%
  dplyr::mutate(f_synch = NA)

# BMA synch-synch

bma.synch.synch.forecast.data = synch_synch_data %>%
  dplyr::mutate(date = as.Date(date)) %>%
  dplyr::filter(date >= "2018-10-01") %>% 
  tidyr::complete(country, date) %>%
  dplyr::mutate(f_synch = NA)

# Before proceeding, create dummy names for the BMA exercise

year_dummy_names = synch_levels_data %>% 
  dplyr::select(starts_with("year_")) %>% 
  base::colnames() 

country_dummy_names = synch_levels_data %>% 
  dplyr::select(starts_with("country_")) %>% 
  base::colnames() 



# Create all the BMA models #
# Very important: consider the time fixed effects that correspond to each forecasting period
# E.g., if we are using 2001-2019 data, we cannot add 2020 fixed effect
# SYNCH-LEVELS (8 models) #

bma.model.synch.levels.1 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2018-10-01")) %>%
                                 dplyr::select(-date, -country, -year_2019, -year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names[-c(18,19)], country_dummy_names))

bma.model.synch.levels.2 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-01-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.levels.3 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-04-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.levels.4 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-07-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.levels.5 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-10-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.levels.6 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2020-01-01")) %>%
                                 dplyr::select(-date, -country),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names, country_dummy_names))

bma.model.synch.levels.7 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2020-04-01")) %>%
                                 dplyr::select(-date, -country),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names, country_dummy_names))

bma.model.synch.levels.8 = BMS::bms(synch_levels_data %>%
                                 dplyr::mutate(date = as.Date(date)) %>%
                                 dplyr::filter(date <= as.Date("2020-07-01")) %>%
                                 dplyr::select(-date, -country),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                               fixed.reg = c(year_dummy_names, country_dummy_names))




# SYNCH-SYNCH (8 models) #

bma.model.synch.synch.1 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2018-10-01")) %>%
                                 dplyr::select(-date, -country, -year_2019,-year_2020),
                               burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                               nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names[-c(18,19)], country_dummy_names))

bma.model.synch.synch.2 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-01-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.synch.3 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-04-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.synch.4 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-07-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.synch.5 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2019-10-01")) %>%
                                 dplyr::select(-date, -country, -year_2020),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names[-c(19)], country_dummy_names))

bma.model.synch.synch.6 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2020-01-01")) %>%
                                 dplyr::select(-date, -country),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names, country_dummy_names))

bma.model.synch.synch.7 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2020-04-01")) %>%
                                 dplyr::select(-date, -country),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names, country_dummy_names))

bma.model.synch.synch.8 = bms(synch_synch_data %>%
                                 dplyr::mutate(date = zoo::as.Date(date)) %>%
                                 dplyr::filter(date <= zoo::as.Date("2020-07-01")) %>%
                                 dplyr::select(-date, -country),
                              burn = n.burn.fcast, iter = n.iter.fcast, g = "BRIC", mprior = "random",
                              nmodel = 10000, mcmc = "bd", user.int = F, randomizeTimer = F,
                              fixed.reg = c(year_dummy_names, country_dummy_names))



# Create the forecasts #
# Find indices of certain variables because not all used for prediction #

f_synch_index = base::which(base::colnames(bma.synch.levels.forecast.data)=="f_synch" ) # Get the column number of the preallocated forecast
country_index = base::which(base::colnames(bma.synch.levels.forecast.data)=="country" )
synch_index =   base::which(base::colnames(bma.synch.levels.forecast.data)=="synch" )
date_index =    base::which(base::colnames(bma.synch.levels.forecast.data)=="date" )
d_2019_index =  base::which(base::colnames(bma.synch.levels.forecast.data)=="year_2019" )
d_2020_index =  base::which(base::colnames(bma.synch.levels.forecast.data)=="year_2020" )

# Arrange by country and date for consistency

bma.synch.levels.forecast.data = bma.synch.levels.forecast.data %>%
  dplyr::arrange(country,date)

for (dd in 1:dim(bma.synch.levels.forecast.data)[1]) {

  if (dd %in% seq(2,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.1, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                      country_index, synch_index, date_index,
                                                                                      d_2019_index, d_2020_index)])

  }

  if (dd %in% seq(3,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.2, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                          d_2020_index)])

  }

  if (dd %in% seq(4,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.3, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(5,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.4, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(6,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.5, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(7,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.6, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }

  if (dd %in% seq(8,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.7, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }

  if (dd %in% seq(9,135,9)) {

    bma.synch.levels.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.levels.8, newdata = bma.synch.levels.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }
}

bma.synch.levels.forecast.data = bma.synch.levels.forecast.data %>%
  dplyr::select(date, country, synch, f_synch)


# Create variable for directional accuracy

bma.synch.levels.forecast.data = bma.synch.levels.forecast.data %>%
  dplyr::group_by(country) %>%
  dplyr::mutate(synch_diff = synch - dplyr::lag(synch),
         f_synch_diff = f_synch - dplyr::lag(f_synch),
         synch_direction = dplyr::if_else(synch_diff > 0, "up", "down"),
         f_synch_direction = dplyr::if_else(f_synch_diff > 0, "up", "down")) %>%
  dplyr::select(-synch_diff, -f_synch_diff) %>% 
  dplyr::ungroup()



# Create squared difference between realization and forecast #

bma.synch.levels.forecast.data = bma.synch.levels.forecast.data %>%
  dplyr::mutate(res_sq = (synch-f_synch)^2)

# Create the PIIGS and non-PIIGS dataset

bma.synch.levels.forecast.data.piigs = bma.synch.levels.forecast.data %>% 
  dplyr::filter(country %in% piigs_subset)

bma.synch.levels.forecast.data.nopiigs = bma.synch.levels.forecast.data %>% 
  dplyr::filter(!country %in% piigs_subset)

# Print the forecast results for all the sample (part of Table 3 in the paper)

base::cat(dir.results(bma.synch.levels.forecast.data), "\n")
base::cat(dir.results(bma.synch.levels.forecast.data.piigs), "\n")
base::cat(dir.results(bma.synch.levels.forecast.data.nopiigs), "\n")

# Print the forecast results without 2020 (part of Table A.5 in the paper)

base::cat(dir.results(without.2020(bma.synch.levels.forecast.data)), "\n")
base::cat(dir.results(without.2020(bma.synch.levels.forecast.data.piigs)), "\n")
base::cat(dir.results(without.2020(bma.synch.levels.forecast.data.nopiigs)), "\n")

# Arrange by country and date for consistency

bma.synch.synch.forecast.data = bma.synch.synch.forecast.data %>%
  dplyr::arrange(country,date)

for (dd in 1:dim(bma.synch.synch.forecast.data)[1]) {

  if (dd %in% seq(2,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.1, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2019_index, d_2020_index)])

  }

  if (dd %in% seq(3,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.2, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(4,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.3, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(5,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.4, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(6,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.5, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index,
                                                                                         d_2020_index)])

  }

  if (dd %in% seq(7,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.6, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }

  if (dd %in% seq(8,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.7, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }

  if (dd %in% seq(9,135,9)) {

    bma.synch.synch.forecast.data[dd,f_synch_index] =
      stats::predict(bma.model.synch.synch.8, newdata = bma.synch.synch.forecast.data[dd,-c(f_synch_index,
                                                                                         country_index, synch_index, date_index)])

  }
}

bma.synch.synch.forecast.data = bma.synch.synch.forecast.data %>%
  dplyr::select(date, country, synch, f_synch)


# Create variable for directional accuracy

bma.synch.synch.forecast.data = bma.synch.synch.forecast.data %>%
  dplyr::group_by(country) %>%
  dplyr::mutate(synch_diff = synch - dplyr::lag(synch),
         f_synch_diff = f_synch - dplyr::lag(f_synch),
         synch_direction = dplyr::if_else(synch_diff > 0, "up", "down"),
         f_synch_direction = dplyr::if_else(f_synch_diff > 0, "up", "down")) %>%
  dplyr::select(-synch_diff, -f_synch_diff) %>% 
  dplyr::ungroup()



# Create squared difference between realization and forecast #

bma.synch.synch.forecast.data = bma.synch.synch.forecast.data %>%
  dplyr::mutate(res_sq = (synch-f_synch)^2)


# Create the PIIGS and non-PIIGS dataset

bma.synch.synch.forecast.data.piigs = bma.synch.synch.forecast.data %>% 
  dplyr::filter(country %in% piigs_subset)

bma.synch.synch.forecast.data.nopiigs = bma.synch.synch.forecast.data %>% 
  dplyr::filter(!country %in% piigs_subset)

# Print the forecast results for all the sample (part of Table 3 in the paper)

base::cat(dir.results(bma.synch.synch.forecast.data), "\n")
base::cat(dir.results(bma.synch.synch.forecast.data.piigs), "\n")
base::cat(dir.results(bma.synch.synch.forecast.data.nopiigs), "\n")

# Print the forecast results without 2020 (part of Table A.5 in the paper)

base::cat(dir.results(without.2020(bma.synch.synch.forecast.data)), "\n")
base::cat(dir.results(without.2020(bma.synch.synch.forecast.data.piigs)), "\n")
base::cat(dir.results(without.2020(bma.synch.synch.forecast.data.nopiigs)), "\n")

# Run the following code to find those variables with PIP>50%

# check.pip = as.data.frame(coef(bma.model.synch.synch.1))
# 
# 
# check.pip = check.pip %>%
#   filter(PIP>=.5)
# 
# 
# check.pip = check.pip %>%
#   filter(!(row.names(check.pip) %in% country_dummy_names),
#          !(row.names(check.pip) %in% year_dummy_names))
# 
# cat(sort(rownames(check.pip)))
