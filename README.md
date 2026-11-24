# Updates on Oliver et al. (2018)

This repository contains the code and supporting data used to update the analysis of Oliver et al. (2018). The materials include MATLAB scripts for figure generation and marine heatwave (MHW) reconstruction, as well as processed trend data for each ecoregion.

## Repository Contents

### Code

| File | Description |
| --- | --- |
| `mhwdetectf.m` | Detect MHWs and estimate MHW metrics|
| `submhwdetectf.sh` | Submit jobs to Gadi|
| `mhwdetectfanalysis.sh` | Parallel Computation|
| `MHW_reconstruct.m` | Reconstructs MHWs using the monthly proxy and a generalized linear model (GLM). |

### Data

| File | Description |
| --- | --- |
| `MHW_OISST_206_ecoregion_trends.xlsx` | Contains MHW trend data for each ecoregion in OISST. |
| `MHW_CoralTemp_206_ecoregion_trends.xlsx` | Contains MHW trend data for each ecoregion in CoralTemp. |

The spreadsheet includes the following information for each ecoregion:

- Biogeographic realm
- Trends estimated for 1982-2025
- MHW frequency
- Maximum MHW intensity
- MHW duration
- Annual MHW days
- Annual cumulative MHW intensity
- Proportion of ice-covered area
- Color-coded trend categories for the trend columns


