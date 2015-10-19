function [SWC_at_sf] = SWC_at_sf_SMlogi(coeff, sf_value)
SWC_at_sf = (coeff(1) - log(1/sf_value - 1))./coeff(2);