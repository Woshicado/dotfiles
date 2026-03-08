#!/bin/bash
sops exec-env ~/secrets.env 'curl -sL "https://api.openweathermap.org/data/2.5/weather?q=${POSH_OWM_LOCATION}&appid=${POSH_OWM_API_KEY}&units=metric"'
