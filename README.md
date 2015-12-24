# lita-timezone

[![Build Status](https://travis-ci.org/ResultadosDigitais/lita-timezone.png?branch=master)](https://travis-ci.org/ResultadosDigitais/lita-timezone)
[![Coverage Status](https://coveralls.io/repos/ResultadosDigitais/lita-timezone/badge.png)](https://coveralls.io/r/ResultadosDigitais/lita-timezone)
[![Code
Climate](https://codeclimate.com/github/ResultadosDigitais/lita-timezone/badges/gpa.svg)](https://codeclimate.com/github/ResultadosDigitais/lita-timezone)

Lita handler to convert time between timezones.

## Installation

Add lita-timezone to your Lita instance's Gemfile:

``` ruby
gem "lita-timezone"
```

## Configuration

Setup your default timezone

``` ruby
config.handlers.timezone.default_zone = 'Brasilia'
```
Tip: See in the `initialize` method of the handler how to get all available timezones of your machine.
## Usage

`lita time now in Beijing`
- Returns the time in Beijing for current time

`lita time 14:00 in Beijing`
- Returns the time in Beijing for 14:00 in the default_zone

`lita time now from Buenos Aires to Beijing`
- Returns the time in Beijing for current time in Buenos Aires

`lita time 14:00 from Buenos Aires to Beijing`
- Returns the time in Beijing for 14:00 in Buenos Aires

`lita available timezones`
- Returns all timezones names available for use

`lita available timezones containing Pacific`
- Returns all timezones that contains Pacific in the name
