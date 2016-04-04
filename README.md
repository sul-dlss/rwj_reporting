[![Build Status](https://travis-ci.org/sul-dlss/rwj_reporting.svg?branch=master)](https://travis-ci.org/sul-dlss/rwj_reporting) | [![Coverage Status](https://coveralls.io/repos/sul-dlss/rwj_reporting/badge.svg)](https://coveralls.io/r/sul-dlss/rwj_reporting) |
[![Dependency Status](https://gemnasium.com/sul-dlss/rwj_reporting.svg)](https://gemnasium.com/sul-dlss/rwj_reporting) | [![Code Climate](https://codeclimate.com/github/sul-dlss/rwj_reporting/badges/gpa.svg)](https://codeclimate.com/github/sul-dlss/rwj_reporting)

# Script to get usage counts from logs for Riverwalk Jazz.  

As of Jan 2016, the SoundExchange reporting requirements for SUL related to our statutory license as a noncommercial webcaster of the Riverwalk Jazz collection online requires us to prepare monthly reports on the number of “performances” of each "song" ie, each time a particular "song" is streamed.

This script will gather that usage data from the hourly logs that are created and stored on media@libstream.stanford.edu/var/log/ezstream/.

Inputs to the script would reflect the reporting time period.
