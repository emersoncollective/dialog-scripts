#!/bin/zsh

CrashPlanPath="/Applications/Code42.app"

# Check if CrashPlan is installed before anything else
if [[ ! -d "$CrashPlanPath" ]]; then
    echo "<result>Not Running</result>"
fi

# Sets value of CrashPlan Application Log
CrashPlanAppLog="/Library/Logs/CrashPlan/app.log"

#If value is 0, no user is logged in to CrashPlan
CrashPlanLoggedIn="$(/usr/bin/awk '/USER/{getline; gsub("\,",""); print $1; exit }' $CrashPlanAppLog)"

# Gets CrashPlan username
CrashPlanUser="$(/usr/bin/awk '/USER/{getline; gsub("\,",""); print $2; exit }' $CrashPlanAppLog)"

# Checks if Code42 Client is Running
CrashPlanRunning="$(/usr/bin/pgrep "Code42Service")"


# Reports CrashPlan Status and Username
if [[ -n "${CrashPlanRunning}" ]]; then

    if [[ "${CrashPlanLoggedIn}" -eq 0 ]]
    then
        CrashPlanStatus="Validation Failure"
    else
        CrashPlanStatus="Running"
    fi
else
    CrashPlanStatus="Validation Failure"
fi

echo "<result>${CrashPlanStatus}</result>"