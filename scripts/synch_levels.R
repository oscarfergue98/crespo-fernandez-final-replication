
# Clean working space #

rm(list=ls())
base::set.seed(14091998)

# Load the necessary functions, packages, and specifications

func.files <- base::list.files(path = "./", pattern = "^~", full.names = TRUE)

for (file in func.files) {
  
  base::source(file)
  
}

# Read the corresponding dataset

fulldata = readxl::read_excel(base::file.path(data_path, "synch_levels.xlsx"))

# Add Draghi dummy + interactions

fulldata = add.draghi.synch(fulldata)

# Model with Fixed Effects #

# Select appropriate variables #
# Create dummy variables to control for year and country fixed effects #
# Note: need to create dummies except for one country and year group! #
# We have in total 15 countries and 21 years #
# So in total, 14 country dummies + 20 year dummies = 34 FE #
# All countries except Spain, all years except for 2021 #
# Important: to avoid multicollinearity issues, do not estimate dummy for PI(I)GS #


fe_data = fulldata %>% 
  dplyr::select(-date,-uncert,-bop,-debttogdp,-gdp,-euribor,-inflation) %>% 
  dummy_cols(select_columns = "year", remove_first_dummy = T) %>%
  dummy_cols(select_columns = "country", remove_first_dummy = T) %>% 
  dplyr::select(-year,-country, -pigs)

# Create year and country dummy names 

year_dummy_names = fe_data %>% 
  dplyr::select(dplyr::starts_with("year_")) %>% 
  base::colnames()

country_dummy_names = fe_data %>% 
  dplyr::select(dplyr::starts_with("country_")) %>% 
  base::colnames()

# Fit the BMS model

model_fe <- fit.bms(fe_data, 1)


coefs_fe <- stats::coef(model_fe,  std.coefs = T, order.by.pip = F)

# Do not select the Fixed Effects results (year & country) #

coefs_fe = coefs_fe[!row.names(coefs_fe) %in% c(country_dummy_names, year_dummy_names),1:3]

# Before moving into the Fixed Effects model, run the jointness analysis #
# Compute jointness for all variables

jointness.dw2 = jointness.score(model_fe, method = "DW2") %>% 
  reshape2::melt(.) %>% 
  dplyr::mutate(value = as.numeric(value))

jointness.ls2 = jointness.score(model_fe, method = "LS2") %>% 
  reshape2::melt(.) %>% 
  dplyr::mutate(value = as.numeric(value))

jointness.yqm = jointness.score(model_fe, method = "YQM") %>% 
  reshape2::melt(.) %>% 
  dplyr::mutate(value = as.numeric(value))


# Get the maximum values in order to select the variables
# that present the higher jointness

max.jointness.dw2 = jointness.dw2 %>% 
  dplyr::filter(value == base::max(value, na.rm = T)) %>% 
  dplyr::mutate(pair = base::paste(pmin(as.character(Var1), as.character(Var2)), 
                                   pmax(as.character(Var1), as.character(Var2)), sep = '-')) %>% 
  dplyr::distinct(pair) %>% 
  dplyr::filter(!grepl('year_',pair)) %>% 
  dplyr::filter(!grepl('country_',pair))

max.jointness.ls2 = jointness.ls2 %>% 
  dplyr::filter(value == base::max(value, na.rm = T)) %>% 
  dplyr::mutate(pair = base::paste(pmin(as.character(Var1), as.character(Var2)), 
                                   pmax(as.character(Var1), as.character(Var2)), sep = '-')) %>% 
  dplyr::distinct(pair) %>% 
  dplyr::filter(!grepl('year_',pair)) %>% 
  dplyr::filter(!grepl('country_',pair))

max.jointness.yqm = jointness.yqm %>% 
  dplyr::filter(value == base::max(value, na.rm = T)) %>% 
  dplyr::mutate(pair = base::paste(pmin(as.character(Var1), as.character(Var2)), 
                                   pmax(as.character(Var1), as.character(Var2)), sep = '-')) %>% 
  dplyr::distinct(pair) %>% 
  dplyr::filter(!grepl('year_',pair)) %>% 
  dplyr::filter(!grepl('country_',pair))


# Plot the matrices #
# Recall: we do not show the year fixed effects #




# Reproduce Figure A.1 in the paper

jointness.yqm %>% 
  dplyr::filter(!grepl("year_", Var1)) %>% 
  dplyr::filter(!grepl("year_", Var2)) %>% 
  dplyr::filter(!grepl("country_", Var1)) %>% 
  dplyr::filter(!grepl("country_", Var2)) %>% 
  ggplot2::ggplot(aes(Var1, Var2, fill= value)) + 
  ggplot2::geom_tile() + 
  ggplot2::theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggplot2::labs(x = "", y = "") + 
  ggplot2::theme(axis.text=element_text(size=6)) +  
  ggplot2::scale_fill_continuous( low = "black", high = "red") +
  ggplot2::theme(legend.text = element_text(size=7), legend.title = element_blank()) + 
  ggplot2::guides(fill = guide_colourbar(barwidth = 0.5,
                                barheight = 20))

# Reproduce Figure A.3 in the paper

jointness.dw2 %>% 
  dplyr::filter(!grepl("year_", Var1)) %>% 
  dplyr::filter(!grepl("year_", Var2)) %>% 
  dplyr::filter(!grepl("country_", Var1)) %>% 
  dplyr::filter(!grepl("country_", Var2)) %>% 
  ggplot2::ggplot(aes(Var1, Var2, fill= value)) + 
  ggplot2::geom_tile() + 
  ggplot2::theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggplot2::labs(x = "", y = "") + 
  ggplot2::theme(axis.text=element_text(size=5)) +  
  ggplot2::scale_fill_continuous( low = "black", high = "red") +
  ggplot2::theme(legend.text = element_text(size=7), legend.title = element_blank()) + 
  ggplot2::guides(fill = guide_colourbar(barwidth = 0.5,
                                barheight = 20))

# Reproduce Figure A.4 in the paper

jointness.ls2 %>% 
  dplyr::filter(!grepl("year_", Var1)) %>% 
  dplyr::filter(!grepl("year_", Var2)) %>% 
  dplyr::filter(!grepl("country_", Var1)) %>% 
  dplyr::filter(!grepl("country_", Var2)) %>% 
  ggplot2::ggplot(aes(Var1, Var2, fill= value)) + 
  ggplot2::geom_tile() + 
  ggplot2::theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  ggplot2::labs(x = "", y = "") + 
  ggplot2::theme(axis.text=element_text(size=5)) +  
  ggplot2::scale_fill_continuous( low = "black", high = "red") +
  ggplot2::theme(legend.text = element_text(size=7), legend.title = element_blank()) + 
  ggplot2::guides(fill = guide_colourbar(barwidth = 0.5,
                                barheight = 20))



# Model without Fixed Effects: add only time (year) fixed effects  #

nofe_data = fulldata %>% 
  dplyr::select(-date,-uncert,-bop,-debttogdp,-gdp,-euribor,-inflation) %>%
  dummy_cols(select_columns = "year", remove_first_dummy = T) %>%
  dplyr::select(-year,-country)



model_nofe <- fit.bms(nofe_data, 2)


coefs_nofe <- stats::coef(model_nofe,  std.coefs = T, order.by.pip = F)[,1:3]

# Do not select year fixed effects #

coefs_nofe = coefs_nofe[!row.names(coefs_nofe) %in% c(year_dummy_names),1:3]

# Model with strong heredity prior: add only time (year) fixed effects #
# Note that this is the same dataset used for the no Fixed Effects model #

heredity_data = fulldata %>% 
  dplyr::select(-date,-uncert,-bop,-debttogdp,-gdp,-euribor,-inflation) %>% 
  dummy_cols(select_columns = "year", remove_first_dummy = T) %>%
  dplyr::select(-year,-country)

  
# Need to change interaction variable names #
# For consistency with BMS package # 

heredity_data = rename.synch(heredity_data)

model_heredity =  fit.bms(heredity_data, 3)


coefs_heredity <- stats::coef(model_heredity,  std.coefs = T, order.by.pip = F)

# Do not select the year fixed effects #

coefs_heredity = coefs_heredity[!row.names(coefs_heredity) %in% year_dummy_names,1:3]

# Reproduce all columns of Table 1 in the paper 

base::round(coefs_fe, 4)
base::round(coefs_nofe, 4)
base::round(coefs_heredity, 4)
