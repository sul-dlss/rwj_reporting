[![Build Status](https://travis-ci.org/sul-dlss/rwj_reporting.svg?branch=master)](https://travis-ci.org/sul-dlss/rwj_reporting) | [![Coverage Status](https://coveralls.io/repos/sul-dlss/rwj_reporting/badge.svg)](https://coveralls.io/r/sul-dlss/rwj_reporting) |
[![Dependency Status](https://gemnasium.com/sul-dlss/rwj_reporting.svg)](https://gemnasium.com/sul-dlss/rwj_reporting) | [![Code Climate](https://codeclimate.com/github/sul-dlss/rwj_reporting/badges/gpa.svg)](https://codeclimate.com/github/sul-dlss/rwj_reporting)

# Script to get usage counts from logs for Riverwalk Jazz.  

As of Jan 2016, the SoundExchange reporting requirements for SUL related to our statutory license as a noncommercial webcaster of the Riverwalk Jazz collection online requires us to prepare monthly reports on the number of “performances” of each "song" ie, each time a particular "song" is streamed.

This script will gather that usage data from the hourly logs that are created and stored on media@libstream.stanford.edu/var/log/ezstream/.

Inputs to the script would reflect the reporting time period.

# Usage

1. log in to libstream box as media user
2. `cd rwj_reporting/current`  (end up in `home/media/rwj_reporting/current`)
3. `rake reports[160301,160331]`
 * the dates given are yymmdd format
 * the dates are inclusive
 * the square brackets and comma are required
4.  reports are written to the `home/media` directory as, e.g. `160301-160331_channel_1_usage_counts.csv` and `160301-160331_channel_2_usage_counts.csv`.   
 * You can change the directory where the reports are written by changing `home/media/rwj_reporting/shared/config/settings.yml`  output_dir

Log files are expected to be in `/var/log/ezstream`.  This directory is also configurable in `home/media/rwj_reporting/shared/config/settings.yml`

The template of the master tracking spreadsheet is held in this codebase under the `/data` directory. This file is configurable in `home/media/rwj_reporting/shared/config/settings.yml`
