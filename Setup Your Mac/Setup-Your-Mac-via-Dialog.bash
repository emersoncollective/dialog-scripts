#!/bin/bash

####################################################################################################
#
# Setup Your Mac via swiftDialog
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# https://snelson.us/sym
=======
# https://snelson.us/setup-your-mac/
>>>>>>> 0bc3777 (oops I had removed it)
=======
# https://snelson.us/setup-your-mac/
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# https://snelson.us/sym
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
#
####################################################################################################
#
# HISTORY
#
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
#   Version 1.8.0, 06-Mar-2023, Dan K. Snelson (@dan-snelson)
#   - Introduces "Configurations" (thanks, @drtaru!)
#       - Required
#       - Recommended
#       - Complete
#   - Play video at Welcome dialog (Issue No. 36)
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
#   Version 1.5.1, 07-Dec-2022, Dan K. Snelson (@dan-snelson)
#   - Updates to "Pre-flight Checks"
#     - Moved section to start of script
#     - Added additional check for Setup Assistant
#       (for Mac Admins using an "Enrollment Complete" trigger)
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
#
####################################################################################################



####################################################################################################
#
<<<<<<< HEAD
# Global Variables
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Script Version and Jamf Pro Script Parameters
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

scriptVersion="1.8.0"
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/
scriptLog="${4:-"/var/log/org.churchofjesuschrist.log"}"                        # Parameter 4: Script Log Location [ /var/log/org.churchofjesuschrist.log ] (i.e., Your organization's default location for client-side logs)
debugMode="${5:-"verbose"}"                                                     # Parameter 5: Debug Mode [ verbose (default) | true | false ]
welcomeDialog="${6:-"userInput"}"                                               # Parameter 6: Welcome dialog [ userInput (default) | video | false ]
completionActionOption="${7:-"Restart Attended"}"                               # Parameter 7: Completion Action [ wait | sleep (with seconds) | Shut Down | Shut Down Attended | Shut Down Confirm | Restart | Restart Attended (default) | Restart Confirm | Log Out | Log Out Attended | Log Out Confirm ]
requiredMinimumBuild="${8:-"disabled"}"                                         # Parameter 8: Required Minimum Build [ disabled (default) | 22D ] (i.e., Your organization's required minimum build of macOS to allow users to proceed; use "22D" for macOS 13.2.x)
outdatedOsAction="${9:-"/System/Library/CoreServices/Software Update.app"}"     # Parameter 9: Outdated OS Action [ /System/Library/CoreServices/Software Update.app (default) | jamfselfservice://content?entity=policy&id=117&action=view ] (i.e., Jamf Pro Self Service policy ID for operating system ugprades)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Operating System, currently logged-in user and default Exit Code
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

osVersion=$( sw_vers -productVersion )
osBuild=$( sw_vers -buildVersion )
osMajorVersion=$( echo "${osVersion}" | awk -F '.' '{print $1}' )
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
reconOptions=""
exitCode="0"

=======
=======
#   Version 1.7.0, 01-Feb-2023, Dan K. Snelson (@dan-snelson)
#   - Adds compatibility for and leverages new features of swiftDialog 2.1
#   - Addresses Issues Nos. 30 & 31
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
#
####################################################################################################

>>>>>>> 6a67ebc (bad merge, reverting)


####################################################################################################
#
<<<<<<< HEAD
=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
# Global Variables
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Script Version, Jamf Pro Script Parameters and default Exit Code
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

scriptVersion="1.7.0"
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/
scriptLog="${4:-"/Library/Logs/EC/com.ECComputerSetup.log"}"                    # Your organization's default location for client-side logs
debugMode="${5:-"true"}"                                                 # [ true | verbose (default) | false ]
welcomeDialog="${6:-"false"}"                                                # [ true (default) | false ]
completionActionOption="${7:-"Restart Attended"}"                           # [ wait | sleep (with seconds) | Shut Down | Shut Down Attended | Shut Down Confirm | Restart | Restart Attended (default) | Restart Confirm | Log Out | Log Out Attended | Log Out Confirm ]
requiredMinimumBuild="${8:-"22D"}"                                          # Your organization's required minimum build of macOS to allow users to proceed
outdatedOsAction=${9:-"/System/Library/CoreServices/Software Update.app"}   # Jamf Pro Self Service policy for operating system ugprades (i.e., "jamfselfservice://content?entity=policy&id=117&action=view") 
reconOptions=""                                                             # Initialize dynamic recon options; built based on user's input at Welcome dialog
exitCode="0"                                                                # Default exit code (i.e., "0" equals sucess)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Create Log File if It doesn't exist
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [ -f /Library/Logs/EC/com.ECComputerSetup.log ]; then
    echo "Log File Already Exists."
else
    if [ ! -d /Library/Logs/EC ]; then
        sudo mkdir /Library/Logs/EC/
    fi
    sudo touch /Library/Logs/EC/com.ECComputerSetup.log
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Retrieve Org name and install appropriate logos
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

org_name="$10"
if [[ $org_name = "Emerson Collective" ]]; then
    org_short_name="EC"
    echo "Org short name is $org_short_name for $org_name"
elif [[ $org_name = "XQ Institute" ]]; then
    org_short_name="XQ"
    echo "Org short name is $org_short_name for $org_name"
elif [[ $org_name = *"CRED"* ]]; then
    org_short_name="CC"
    echo "Org short name is $org_short_name for $org_name"
else
    org_short_name="EC"
    org_name="Emerson Collective"
    echo "Defaulting to $org_short_name for $org_name"
fi

logo_file="/Library/${org_short_name}/logo.png"
if [[ -e "$logo_file" ]]; then
    echo "logo file exists at ${logo_file}"
else
    echo "logo file not found, running appropriate JAMF policy to install"
    jamf policy -trigger install_${org_short_name}_logos
fi


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Operating System and currently logged-in user variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

osVersion=$( sw_vers -productVersion )
osBuild=$( sw_vers -buildVersion )
osMajorVersion=$( echo "${osVersion}" | awk -F '.' '{print $1}' )
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
timestamp=$( date +%Y-%m-%d\ %H:%M:%S )



####################################################################################################
#
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# Pre-flight Checks
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Pre-flight Check: Client-side Logging
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ ! -f "${scriptLog}" ]]; then
    touch "${scriptLog}"
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Initiate Pre-flight Checks
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo -e "\n###\n# Setup Your Mac (${scriptVersion})\n# https://snelson.us/sym\n###\n"
echo "${timestamp} - Pre-flight Check: Initiating …"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# Confirm script is running as root
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ $(id -u) -ne 0 ]]; then
    echo "${timestamp} - Pre-flight Check: This script must be run as root; exiting."
    exit 1
>>>>>>> 0bc3777 (oops I had removed it)
fi


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Determine Processor Type
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cpu=$(sysctl -a | grep brand | awk '{print $2}')
echo "CPU vendor is $cpu"
if [[ $cpu = "Apple"  ]]; then
    type="arm"
else
    type="intel"
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Validate Operating System Version and Build
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Since swiftDialog requires at least macOS 11 Big Sur, first confirm the major OS version
# shellcheck disable=SC2086 # purposely use single quotes with osascript
if [[ "${osMajorVersion}" -ge 11 ]] ; then
    
    echo "${timestamp} - Pre-flight Check: macOS ${osMajorVersion} installed; checking build version ..."
    
    # Confirm the Mac is running `requiredMinimumBuild` (or later)
    if [[ "${osBuild}" > "${requiredMinimumBuild}" ]]; then
        
        echo "${timestamp} - Pre-flight Check: macOS ${osVersion} (${osBuild}) installed; proceeding ..."
        
        # When the current `osBuild` is older than `requiredMinimumBuild`; exit with error
    else
        echo "${timestamp} - Pre-flight Check: The installed operating system, macOS ${osVersion} (${osBuild}), needs to be updated to Build ${requiredMinimumBuild}; exiting with error."
        osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\rExpected macOS Build '${requiredMinimumBuild}' (or newer), but found macOS '${osVersion}' ('${osBuild}').\r\r" with title "Setup Your Mac: Detected Outdated Operating System" buttons {"Open Software Update"} with icon caution'
        echo "${timestamp} - Pre-flight Check: Executing /usr/bin/open '${outdatedOsAction}' …"
        su - "${loggedInUser}" -c "/usr/bin/open \"${outdatedOsAction}\""
        exit 1
        
    fi
    
    # The Mac is running an operating system older than macOS 11 Big Sur; exit with error
else
    
    echo "${timestamp} - Pre-flight Check: swiftDialog requires at least macOS 11 Big Sur and this Mac is running ${osVersion} (${osBuild}), exiting with error."
    osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\rExpected macOS Build '${requiredMinimumBuild}' (or newer), but found macOS '${osVersion}' ('${osBuild}').\r\r" with title "Setup Your Mac: Detected Outdated Operating System" buttons {"Open Software Update"} with icon caution'
    echo "${timestamp} - Pre-flight Check: Executing /usr/bin/open '${outdatedOsAction}' …"
    su - "${loggedInUser}" -c "/usr/bin/open \"${outdatedOsAction}\""
    exit 1
    
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
# Pre-flight Check: Client-side Script Logging Function
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function updateScriptLog() {
    echo -e "$( date +%Y-%m-%d\ %H:%M:%S ) - ${1}" | tee -a "${scriptLog}"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Logging Preamble
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

updateScriptLog "\n\n###\n# Setup Your Mac (${scriptVersion})\n# https://snelson.us/sym\n###\n"
updateScriptLog "Pre-flight Check: Initiating …"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Confirm script is running as root
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ $(id -u) -ne 0 ]]; then
    updateScriptLog "Pre-flight Check: This script must be run as root; exiting."
    exit 1
fi
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
# Ensure computer does not go to sleep while running this script (thanks, @grahampugh!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo "${timestamp} - Pre-flight Check: Caffeinating this script (PID: $$)"
caffeinate -dimsu -w $$ &
>>>>>>> 0bc3777 (oops I had removed it)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Pre-flight Check: Validate Setup Assistant has completed
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

while pgrep -q -x "Setup Assistant"; do
    updateScriptLog "Pre-flight Check: Setup Assistant is still running; pausing for 2 seconds"
    sleep 2
done

updateScriptLog "Pre-flight Check: Setup Assistant is no longer running; proceeding …"
=======
# Validate Setup Assistant has completed
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

while pgrep -q -x "Setup Assistant"; do
    echo "${timestamp} - Pre-flight Check: Setup Assistant is still running; pausing for 2 seconds"
    sleep 2
done

<<<<<<< HEAD
echo "Setup Assistant is no longer running; proceeding …"
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Pre-flight Check: Confirm Dock is running / user is at Desktop
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

until pgrep -q -x "Finder" && pgrep -q -x "Dock"; do
    updateScriptLog "Pre-flight Check: Finder & Dock are NOT running; pausing for 1 second"
    sleep 1
done

updateScriptLog "Pre-flight Check: Finder & Dock are running; proceeding …"
=======
echo "${timestamp} - Pre-flight Check: Setup Assistant is no longer running; proceeding …"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Validate Operating System Version and Build
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${requiredMinimumBuild}" == "disabled" ]]; then

    updateScriptLog "Pre-flight Check: 'requiredMinimumBuild' has been set to ${requiredMinimumBuild}; skipping OS validation."
    updateScriptLog "Pre-flight Check: macOS ${osVersion} (${osBuild}) installed"

else

    # Since swiftDialog requires at least macOS 11 Big Sur, first confirm the major OS version
    # shellcheck disable=SC2086 # purposely use single quotes with osascript
    if [[ "${osMajorVersion}" -ge 11 ]] ; then

        updateScriptLog "Pre-flight Check: macOS ${osMajorVersion} installed; checking build version ..."

        # Confirm the Mac is running `requiredMinimumBuild` (or later)
        if [[ "${osBuild}" > "${requiredMinimumBuild}" ]]; then

            updateScriptLog "Pre-flight Check: macOS ${osVersion} (${osBuild}) installed; proceeding ..."

        # When the current `osBuild` is older than `requiredMinimumBuild`; exit with error
        else
            updateScriptLog "Pre-flight Check: The installed operating system, macOS ${osVersion} (${osBuild}), needs to be updated to Build ${requiredMinimumBuild}; exiting with error."
            osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\rExpected macOS Build '${requiredMinimumBuild}' (or newer), but found macOS '${osVersion}' ('${osBuild}').\r\r" with title "Setup Your Mac: Detected Outdated Operating System" buttons {"Open Software Update"} with icon caution'
            updateScriptLog "Pre-flight Check: Executing /usr/bin/open '${outdatedOsAction}' …"
            su - "${loggedInUser}" -c "/usr/bin/open \"${outdatedOsAction}\""
            exit 1

        fi

    # The Mac is running an operating system older than macOS 11 Big Sur; exit with error
    else

        updateScriptLog "Pre-flight Check: swiftDialog requires at least macOS 11 Big Sur and this Mac is running ${osVersion} (${osBuild}), exiting with error."
        osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\rExpected macOS Build '${requiredMinimumBuild}' (or newer), but found macOS '${osVersion}' ('${osBuild}').\r\r" with title "Setup Your Mac: Detected Outdated Operating System" buttons {"Open Software Update"} with icon caution'
        updateScriptLog "Pre-flight Check: Executing /usr/bin/open '${outdatedOsAction}' …"
        su - "${loggedInUser}" -c "/usr/bin/open \"${outdatedOsAction}\""
        exit 1

    fi

fi
=======
# Confirm Dock is running / user is at Desktop
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

until pgrep -q -x "Finder" && pgrep -q -x "Dock"; do
    echo "${timestamp} - Pre-flight Check: Finder & Dock are NOT running; pausing for 1 second"
    sleep 1
done

<<<<<<< HEAD
echo "Finder & Dock are running; proceeding …"
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Pre-flight Check: Ensure computer does not go to sleep during SYM (thanks, @grahampugh!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

updateScriptLog "Pre-flight Check: Caffeinating this script (PID: $$)"
caffeinate -dimsu -w $$ &
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
echo "${timestamp} - Pre-flight Check: Finder & Dock are running; proceeding …"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Validate logged-in user
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ -z "${loggedInUser}" || "${loggedInUser}" == "loginwindow" ]]; then
    updateScriptLog "Pre-flight Check: No user logged-in; exiting."
    exit 1
else
    loggedInUserFullname=$( id -F "${loggedInUser}" )
    loggedInUserFirstname=$( echo "$loggedInUserFullname" | cut -d " " -f 1 )
    loggedInUserID=$( id -u "${loggedInUser}" )
=======
# Validate logged-in user
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

if [[ -z "${loggedInUser}" || "${loggedInUser}" == "loginwindow" ]]; then
    echo "${timestamp} - Pre-flight Check: No user logged-in; exiting."
    exit 1
else
    loggedInUserID=$(id -u "${loggedInUser}")
>>>>>>> 0bc3777 (oops I had removed it)
fi



<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Temporarily disable `jamf` binary check-in (thanks, @mactroll and @cube!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
    updateScriptLog "Pre-flight Check: DEBUG MODE: Normally, 'jamf' binary check-in would be temporarily disabled"
else
    updateScriptLog "Pre-flight Check: Temporarily disable 'jamf' binary check-in"
=======
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Temporarily disable `jamf` binary check-in (thanks, @mactroll and @cube!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
    echo "${timestamp} - Pre-flight Check: DEBUG MODE: Normally, 'jamf' binary check-in would be temporarily disabled"
else
    echo "${timestamp} - Pre-flight Check: Temporarily disable 'jamf' binary check-in"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    jamflaunchDaemon="/Library/LaunchDaemons/com.jamfsoftware.task.1.plist"
    while [[ ! -f "${jamflaunchDaemon}" ]] ; do
        sleep 0.1
    done
    /bin/launchctl bootout system "$jamflaunchDaemon"
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Pre-flight Check: Validate / install swiftDialog (Thanks big bunches, @acodega!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dialogCheck() {

    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "Pre-flight Check: # # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    # Get the URL of the latest PKG From the Dialog GitHub repo
    dialogURL=$(curl --silent --fail "https://api.github.com/repos/bartreardon/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")

    # Expected Team ID of the downloaded PKG
    expectedDialogTeamID="PWA5E9TQ59"

    # Check for Dialog and install if not found
    if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then

        updateScriptLog "Pre-flight Check: Dialog not found. Installing..."

        # Create temporary working directory
        workDirectory=$( /usr/bin/basename "$0" )
        tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )

        # Download the installer package
        /usr/bin/curl --location --silent "$dialogURL" -o "$tempDirectory/Dialog.pkg"

        # Verify the download
        teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')

        # Install the package if Team ID validates
        if [[ "$expectedDialogTeamID" == "$teamID" ]]; then

            /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
            sleep 2
            dialogVersion=$( /usr/local/bin/dialog --version )
            updateScriptLog "Pre-flight Check: swiftDialog version ${dialogVersion} installed; proceeding..."

        else

            # Display a so-called "simple" dialog if Team ID fails to validate
            osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\r• Dialog Team ID verification failed\r\r" with title "Setup Your Mac: Error" buttons {"Close"} with icon caution'
            completionActionOption="Quit"
            exitCode="1"
            quitScript

        fi

        # Remove the temporary working directory when done
        /bin/rm -Rf "$tempDirectory"

    else

        updateScriptLog "Pre-flight Check: swiftDialog version $(dialog --version) found; proceeding..."

    fi

}

if [[ ! -e "/Library/Application Support/Dialog/Dialog.app" ]]; then
    dialogCheck
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Pre-flight Check: Complete
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

updateScriptLog "Pre-flight Check: Complete"



####################################################################################################
#
# Dialog Variables
=======
####################################################################################################
#
# Variables
>>>>>>> 0bc3777 (oops I had removed it)
=======
####################################################################################################
#
# Variables
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Pre-flight Checks Complete
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo "${timestamp} - Pre-flight Check: Complete"



####################################################################################################
#
# Dialog Variables
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# infobox-related variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

macOSproductVersion="$( sw_vers -productVersion )"
macOSbuildVersion="$( sw_vers -buildVersion )"
serialNumber=$( system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}' )
timestamp="$( date '+%Y-%m-%d-%H%M%S' )"
dialogVersion=$( /usr/local/bin/dialog --version )
=======
# Script Version, Jamf Pro Script Parameters and default Exit Code
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

=======
# Script Version, Jamf Pro Script Parameters and default Exit Code
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

>>>>>>> 6a67ebc (bad merge, reverting)
scriptVersion="1.5.1"
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/
scriptLog="${4:-"/var/tmp/org.ec.log"}"
debugMode="${5:-"true"}"                           # [ true (default) | false ]
welcomeDialog="${6:-"true"}"                       # [ true (default) | false ]
completionActionOption="${7:-"Restart Attended"}"  # [ wait | sleep (with seconds) | Shut Down | Shut Down Attended | Shut Down Confirm | Restart | Restart Attended (default) | Restart Confirm | Log Out | Log Out Attended | Log Out Confirm ]
reconOptions=""                                    # Initialize dynamic recon options; built based on user's input at Welcome dialog
exitCode="0"
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)

org_name="$8"
if [[ $org_name = "Emerson Collective" ]]; then
    org_short_name="EC"
    echo "Org short name is $org_short_name for $org_name"
elif [[ $org_name = "XQ Institute" ]]; then
    org_short_name="XQ"
    echo "Org short name is $org_short_name for $org_name"
elif [[ $org_name = *"CRED"* ]]; then
    org_short_name="CC"
    echo "Org short name is $org_short_name for $org_name"
else
    org_short_name="EC"
    org_name="Emerson Collective"
    echo "Defaulting to $org_short_name for $org_name"
fi
=======
# infobox-related variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

macOSproductVersion="$( sw_vers -productVersion )"
macOSbuildVersion="$( sw_vers -buildVersion )"
serialNumber=$( system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}' )
timestamp="$( date '+%Y-%m-%d-%H%M%S' )"
dialogVersion=$( /usr/local/bin/dialog --version )
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Reflect Debug Mode in `infotext` (i.e., bottom, left-hand corner of each dialog)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
case ${debugMode} in
    "true"      ) scriptVersion="DEBUG MODE | Dialog: v${dialogVersion} • Setup Your Mac: v${scriptVersion}" ;;
    "verbose"   ) scriptVersion="VERBOSE DEBUG MODE | Dialog: v${dialogVersion} • Setup Your Mac: v${scriptVersion}" ;;
esac
=======
if [[ "${debugMode}" == "true" ]]; then
    scriptVersion="DEBUG MODE | Dialog: v$(dialog --version) • Setup Your Mac: v${scriptVersion}"
fi
>>>>>>> 0bc3777 (oops I had removed it)
=======
if [[ "${debugMode}" == "true" ]]; then
    scriptVersion="DEBUG MODE | Dialog: v$(dialog --version) • Setup Your Mac: v${scriptVersion}"
fi
>>>>>>> 6a67ebc (bad merge, reverting)
=======
case ${debugMode} in
    "true"      ) scriptVersion="DEBUG MODE | Dialog: v$(dialog --version) • Setup Your Mac: v${scriptVersion}" ;;
    "verbose"   ) scriptVersion="VERBOSE DEBUG MODE | Dialog: v$(dialog --version) • Setup Your Mac: v${scriptVersion}" ;;
esac
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Set Dialog path, Command Files, JAMF binary, log files and currently logged-in user
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
dialogApp="/Library/Application\ Support/Dialog/Dialog.app/Contents/MacOS/Dialog"
dialogBinary="/usr/local/bin/dialog"
=======
dialogApp="/usr/local/bin/dialog"
>>>>>>> 0bc3777 (oops I had removed it)
=======
dialogApp="/usr/local/bin/dialog"
>>>>>>> 6a67ebc (bad merge, reverting)
=======
dialogApp="/Library/Application\ Support/Dialog/Dialog.app/Contents/MacOS/Dialog"
dialogBinary="/usr/local/bin/dialog"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
welcomeCommandFile=$( mktemp /var/tmp/dialogWelcome.XXX )
setupYourMacCommandFile=$( mktemp /var/tmp/dialogSetupYourMac.XXX )
failureCommandFile=$( mktemp /var/tmp/dialogFailure.XXX )
jamfBinary="/usr/local/bin/jamf"
<<<<<<< HEAD
=======
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
loggedInUserFullname=$( id -F "${loggedInUser}" )
loggedInUserFirstname=$( echo "$loggedInUserFullname" | cut -d " " -f 1 )
>>>>>>> 0bc3777 (oops I had removed it)



####################################################################################################
#
# Welcome dialog
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Welcome" dialog Title, Message and Icon
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
welcomeTitle="Welcome to your new Mac, ${loggedInUserFirstname}!"
welcomeMessage="Please enter your Mac's **Asset Tag**, select your preferred **Configuration** then click **Continue** to start applying settings to your new Mac.  \n\nOnce completed, the **Wait** button will be enabled and you'll be able to review the results before restarting your Mac.  \n\nIf you need assistance, please contact the Help Desk: +1 (801) 555-1212.  \n\n---  \n\n#### Configurations  \n- **Required:** Minimum organization apps  \n- **Recommended:** Required apps and Microsoft Office  \n- **Complete:** Recommended apps, Adobe Acrobat Reader and Google Chrome"
welcomeBannerImage="https://img.freepik.com/free-photo/yellow-watercolor-paper_95678-446.jpg"
welcomeBannerText="Welcome to your new Mac, ${loggedInUserFirstname}!"
welcomeCaption="Please review the above video, then click Continue."
welcomeVideoID="vimeoid=803933536"
=======
welcomeTitle="Welcome to the Collective, ${loggedInUserFirstname}!"
welcomeMessage="To begin, please select 'OK' and the computer setup process will begin. If you need assistance, please email ithelp@emersoncollective.com. The process will begin in 5 minutes automatically"
>>>>>>> 0bc3777 (oops I had removed it)
=======
welcomeTitle="Welcome to the Collective, ${loggedInUserFirstname}!"
welcomeMessage="To begin, please select 'OK' and the computer setup process will begin. If you need assistance, please email ithelp@emersoncollective.com. The process will begin in 5 minutes automatically"
>>>>>>> 6a67ebc (bad merge, reverting)
=======
welcomeTitle="Welcome to your new Mac, ${loggedInUserFirstname}!"
welcomeMessage="To begin, please enter the required information below, then click **Continue** to start applying settings to your new Mac.  \n\nOnce completed, the **Wait** button will be enabled and you'll be able to review the results before restarting your Mac.  \n\nIf you need assistance, please contact the Help Desk: +1 (801) 555-1212."
welcomeBannerImage="/System/Library/Desktop Pictures/hello Orange.heic"
welcomeBannerText="Welcome to your new Mac, ${loggedInUserFirstname}!"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)

# Welcome icon set to either light or dark, based on user's Apperance setting (thanks, @mm2270!)
appleInterfaceStyle=$( /usr/bin/defaults read /Users/"${loggedInUser}"/Library/Preferences/.GlobalPreferences.plist AppleInterfaceStyle 2>&1 )
if [[ "${appleInterfaceStyle}" == "Dark" ]]; then
    welcomeIcon="https://cdn-icons-png.flaticon.com/512/740/740878.png"
else
    welcomeIcon="https://cdn-icons-png.flaticon.com/512/979/979585.png"
fi



<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Welcome" Video Settings and Features
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

welcomeVideo="--title \"$welcomeTitle\" \
--videocaption \"$welcomeCaption\" \
--video \"$welcomeVideoID\" \
--infotext \"$scriptVersion\" \
--button1text \"Continue …\" \
--autoplay \
--moveable \
--ontop \
--width '800' \
--height '600' \
--commandfile \"$welcomeCommandFile\" "



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Welcome" JSON for Capturing User Input (thanks, @bartreardon!)
=======
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Welcome" JSON (thanks, @bartreardon!)
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

welcomeJSON='{
    "bannerimage" : "'"${welcomeBannerImage}"'",
    "bannertext" : "'"${welcomeBannerText}"'",
    "title" : "'"${welcomeTitle}"'",
    "message" : "'"${welcomeMessage}"'",
    "icon" : "'"${welcomeIcon}"'",
    "iconsize" : "198.0",
    "button1text" : "Continue",
    "button2text" : "Quit",
    "infotext" : "'"${scriptVersion}"'",
    "blurscreen" : "true",
    "ontop" : "true",
    "titlefont" : "shadow=true, size=40",
<<<<<<< HEAD
    "messagefont" : "size=14",
    "textfield" : [
=======
    "messagefont" : "size=16",
    "textfield" : [
        {   "title" : "Comment",
            "required" : false,
            "prompt" : "Enter a comment",
            "editor" : true
        },
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        {   "title" : "Computer Name",
            "required" : false,
            "prompt" : "Computer Name"
        },
        {   "title" : "User Name",
            "required" : false,
            "prompt" : "User Name"
        },
        {   "title" : "Asset Tag",
            "required" : true,
            "prompt" : "Please enter the seven-digit Asset Tag",
<<<<<<< HEAD
            "regex" : "^(AP|IP|CD)?[0-9]{7,}$",
            "regexerror" : "Please enter (at least) seven digits for the Asset Tag, optionally preceed by either AP, IP or CD."
        }
    ],
  "selectitems" : [
        {   "title" : "Configuration",
            "default" : "Required",
            "values" : [
                "Required",
                "Recommended",
                "Complete"
            ]
        },  
=======
            "regex" : "^(AP|IP)?[0-9]{7,}$",
            "regexerror" : "Please enter (at least) seven digits for the Asset Tag, optionally preceed by either AP or IP."
        }
    ],
    "selectitems" : [
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        {   "title" : "Department",
            "default" : "Please select your department",
            "values" : [
                "Please select your department",
                "Asset Management",
                "Australia Area Office",
                "Board of Directors",
                "Business Development",
                "Corporate Communications",
                "Creative Services",
                "Customer Service / Customer Experience",
                "Engineering",
                "Finance / Accounting",
                "General Management",
                "Human Resources",
                "Information Technology / Technology",
                "Investor Relations",
                "Legal",
                "Marketing",
                "Operations",
                "Product Management",
                "Production",
                "Project Management Office",
                "Purchasing / Sourcing",
                "Quality Assurance",
                "Risk Management",
                "Sales",
                "Strategic Initiatives & Programs",
                "Technology"
            ]
<<<<<<< HEAD
        }
    ],
    "height" : "725"
}'
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
## # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
## "Welcome" JSON (thanks, @bartreardon!)
## # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#"title" : "Welcome To The Collective",
#"message" : "'"${welcomeMessage}"'",
#"icon" : '/Library/EC/logo.png',
#"iconsize" : "198.0",
#"button1text" : "Continue",
#"button2text" : "Get Help",
#"infotext" : "'"${scriptVersion}"'",
#"blurscreen" : "false",
#"ontop" : "true",
#"titlefont" : "size=26",
#"messagefont" : "size=16",
#welcomeJSON='{
#   "title" : "'"${welcomeTitle}"'",
#   "message" : "'"${welcomeMessage}"'",
#   "icon" : '/Library/EC/logo.png',
#   "iconsize" : "198.0",
#   "button1text" : "Continue",
#   "button2text" : "Get Help",
#   "infotext" : "'"${scriptVersion}"'",
#   "blurscreen" : "false",
#   "ontop" : "true",
#   "titlefont" : "size=26",
#   "messagefont" : "size=16",
#   "textfield" : [
#       {   "title" : "Comment",
#           "required" : false,
#           "prompt" : "Enter a comment",
#           "editor" : true
#       },
#       {   "title" : "Computer Name",
#           "required" : false,
#           "prompt" : "Computer Name"
#       },
#       {   "title" : "User Name",
#           "required" : false,
#           "prompt" : "User Name"
#       },
#       {   "title" : "Asset Tag",
#           "required" : true,
#           "prompt" : "Please enter the seven-digit Asset Tag",
#           "regex" : "^(AP|IP)?[0-9]{7,}$",
#           "regexerror" : "Please enter (at least) seven digits for the Asset Tag, optionally preceed by either AP or IP."
#       }
#   ],
# "selectitems" : [
#       {   "title" : "Department",
#           "default" : "Please select your department",
#           "values" : [
#               "Please select your department",
#               "Asset Management",
#               "Australia Area Office",
#               "Board of Directors",
#               "Business Development",
#               "Corporate Communications",
#               "Creative Services",
#               "Customer Service / Customer Experience",
#               "Engineering",
#               "Finance / Accounting",
#               "General Management",
#               "Human Resources",
#               "Information Technology / Technology",
#               "Investor Relations",
#               "Legal",
#               "Marketing",
#               "Operations",
#               "Product Management",
#               "Production",
#               "Project Management Office",
#               "Purchasing / Sourcing",
#               "Quality Assurance",
#               "Risk Management",
#               "Sales",
#               "Strategic Initiatives & Programs",
#               "Technology"
#           ]
#       },
#       {   "title" : "Select B",
#           "values" : [
#               "B1",
#               "B2",
#               "B3"
#           ]
#       },
#       {   "title" : "Select C",
#           "values" : [
#               "C1",
#               "C2",
#               "C3"
#           ]
#       }
#   ],
#   "height" : "635"
#}'
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
        },
        {   "title" : "Select B",
            "values" : [
                "B1",
                "B2",
                "B3"
            ]
        },
        {   "title" : "Select C",
            "values" : [
                "C1",
                "C2",
                "C3"
            ]
        }
    ],
    "height" : "700"
}'
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



####################################################################################################
#
# Setup Your Mac dialog
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Setup Your Mac" dialog Title, Message, Overlay Icon and Icon
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

title="Setting up ${loggedInUserFirstname}'s Mac"
message="Please wait while the following apps are installed …"
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
bannerImage="https://img.freepik.com/free-photo/yellow-watercolor-paper_95678-446.jpg"
bannerText="Setting up ${loggedInUserFirstname}'s Mac"
helpmessage="If you need assistance, please contact the Global Service Department:  \n- **Telephone:** +1 (801) 555-1212  \n- **Email:** support@domain.org  \n- **Knowledge Base Article:** KB0057050  \n\n**Computer Information:** \n\n- **Operating System:**  ${macOSproductVersion} ($macOSbuildVersion)  \n- **Serial Number:** ${serialNumber}  \n- **Dialog:** ${dialogVersion}  \n- **Started:** ${timestamp}"
infobox="Analyzing input …" # Customize at "Update Setup Your Mac's infobox"
selfServiceBrandingImage="/Users/${loggedInUser}/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
if [[ ! -f "${selfServiceBrandingImage}" ]]; then
    overlayicon="https://ics.services.jamfcloud.com/icon/hash_aa63d5813d6ed4846b623ed82acdd1562779bf3716f2d432a8ee533bba8950ee"
else
    # overlayicon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path 2>&1 )
    overlayicon="${selfServiceBrandingImage}"
fi
=======
overlayicon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path )
>>>>>>> 0bc3777 (oops I had removed it)
=======
overlayicon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path )
>>>>>>> 6a67ebc (bad merge, reverting)
=======
overlayicon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path 2>&1 )
bannerImage="/System/Library/Desktop Pictures/hello Orange.heic"
bannerText="Setting up ${loggedInUserFirstname}'s Mac"
helpmessage="If you need assistance, please contact the IT Help:\n- **Email:** ithelp@emersoncollective.com  \n- **Knowledge Base Article:** https://drive.google.com/drive/u/0/search?q=computer%20setup  \n\n**Computer Information:** \n\n- **Operating System:**  ${macOSproductVersion} ($macOSbuildVersion)  \n- **Serial Number:** ${serialNumber}  \n- **Dialog:** ${dialogVersion}  \n- **Started:** ${timestamp}"
infobox="Analyzing input …" # Customize at "Update Setup Your Mac's infobox"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)

# Set initial icon based on whether the Mac is a desktop or laptop
if system_profiler SPPowerDataType | grep -q "Battery Power"; then
    icon="SF=laptopcomputer.and.arrow.down,weight=semibold,colour1=#ef9d51,colour2=#ef7951"
else
    icon="SF=desktopcomputer.and.arrow.down,weight=semibold,colour1=#ef9d51,colour2=#ef7951"
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Setup Your Mac" dialog Settings and Features
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
dialogSetupYourMacCMD="$dialogBinary \
--bannerimage \"$bannerImage\" \
--bannertext \"$bannerText\" \
=======
dialogSetupYourMacCMD="$dialogApp \
>>>>>>> 6a67ebc (bad merge, reverting)
--title \"$title\" \
--message \"$message\" \
--icon \"$icon\" \
<<<<<<< HEAD
--infobox \"${infobox}\" \
=======
dialogSetupYourMacCMD="$dialogApp \
=======
dialogSetupYourMacCMD="$dialogBinary \
--bannerimage \"$bannerImage\" \
--bannertext \"$bannerText\" \
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
--title \"$title\" \
--message \"$message\" \
--helpmessage \"$helpmessage\" \
--icon \"$icon\" \
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
--infobox \"${infobox}\" \
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
--progress \
--progresstext \"Initializing configuration …\" \
--button1text \"Wait\" \
--button1disabled \
--infotext \"$scriptVersion\" \
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
--titlefont 'shadow=true, size=40' \
--messagefont 'size=14' \
--height '780' \
=======
--titlefont 'size=28' \
--messagefont 'size=14' \
--height '70%' \
>>>>>>> 0bc3777 (oops I had removed it)
=======
--titlefont 'size=28' \
--messagefont 'size=14' \
--height '70%' \
>>>>>>> 6a67ebc (bad merge, reverting)
=======
--titlefont 'shadow=true, size=40' \
--messagefont 'size=14' \
--height '775' \
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
--position 'centre' \
--moveable \
--blurscreen \
--ontop \
--overlayicon \"$overlayicon\" \
--quitkey k \
--commandfile \"$setupYourMacCommandFile\" "



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
#
=======
>>>>>>> 0bc3777 (oops I had removed it)
# "Setup Your Mac" policies to execute (Thanks, Obi-@smithjw!)
#
# For each configuration step, specify:
# - listitem: The text to be displayed in the list
# - icon: The hash of the icon to be displayed on the left
#   - See: https://vimeo.com/772998915
# - progresstext: The text to be displayed below the progress bar
# - trigger: The Jamf Pro Policy Custom Event Name
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# - validation: [ {absolute path} | Local | Remote | None ]
#   See: https://snelson.us/2023/01/setup-your-mac-validation/
#       - {absolute path} (simulates pre-v1.6.0 behavior, for example: "/Applications/Microsoft Teams.app/Contents/Info.plist")
#       - Local (for validation within this script, for example: "filevault")
<<<<<<< HEAD
#       - Remote (for validation via a single-script Jamf Pro policy, for example: "symvGlobalProtect")
#       - None (for triggers which don't require validation, for example: recon; always evaluates as successful)
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# From @wakco: If you would prefer to get your policyJSON externally replace it with:
#  - policyJSON="$(cat /path/to/file.json)" # For getting from a file, replacing /path/to/file.json with the path to your file, or
#  - policyJSON="$(curl -sL https://server.name/jsonquery)" # For a URL, replacing https://server.name/jsonquery with the URL of your file.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# From @astrugatch: I added this line to global variables:
# jsonURL=${10}                                                               # URL Hosting JSON for policy_array
#
# And this line replaces the entirety of the policy_array (~ line 503):
# policy_array=("$(curl -sL $jsonURL)")
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# shellcheck disable=SC1112 # use literal slanted single quotes for typographic reasons
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

setupYourMacPolicyArrayIconPrefixUrl="https://ics.services.jamfcloud.com/icon/hash_"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Select `policyJSON` based on Configuration selected in "Welcome" dialog (thanks, @drtaru!)
# shellcheck disable=SC1112 # use literal slanted single quotes for typographic reasons
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function policyJSONConfiguration() {

    updateScriptLog "WELCOME DIALOG: PolicyJSON Configuration: $symConfiguration"

    case ${symConfiguration} in

        "Required" )

            policyJSON='
            {
                "steps": [
                    {
                        "listitem": "Rosetta",
                        "icon": "8bac19160fabb0c8e7bac97b37b51d2ac8f38b7100b6357642d9505645d37b52",
                        "progresstext": "Rosetta enables a Mac with Apple silicon to use apps built for a Mac with an Intel processor.",
                        "trigger_list": [
                            {
                                "trigger": "rosettaInstall",
                                "validation": "None"
                            },
                            {
                                "trigger": "rosetta",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "FileVault Disk Encryption",
                        "icon": "f9ba35bd55488783456d64ec73372f029560531ca10dfa0e8154a46d7732b913",
                        "progresstext": "FileVault is built-in to macOS and provides full-disk encryption to help prevent unauthorized access to your Mac.",
                        "trigger_list": [
                            {
                                "trigger": "filevault",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint",
                        "icon": "c70f1acf8c96b99568fec83e165d2a534d111b0510fb561a283d32aa5b01c60c",
                        "progresstext": "You’ll enjoy next-gen protection with Sophos Endpoint which doesn’t rely on signatures to catch malware.",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpoint",
                                "validation": "/Applications/Sophos/Sophos Endpoint.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint Services (Remote)",
                        "icon": "c05d087189f0b25a94f02eeb43b0c5c928e5e378f2168f603554bce2b5c71209",
                        "progresstext": "Remotely validating Sophos Endpoint services …",
                        "trigger_list": [
                            {
                                "trigger": "symvSophosEndpointRTS",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect",
                        "icon": "ea794c5a1850e735179c7c60919e3b51ed3ed2b301fe3f0f27ad5ebd394a2e4b",
                        "progresstext": "Use Palo Alto GlobalProtect to establish a Virtual Private Network (VPN) connection to Church headquarters.",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "/Applications/GlobalProtect.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect Services (Remote)",
                        "icon": "709e8bdf0019e8faf9df85ec0a68545bfdb8bfa1227ac9bed9bba40a1fa8ff42",
                        "progresstext": "Remotely validating Palo Alto GlobalProtect services …",
                        "trigger_list": [
                            {
                                "trigger": "symvGlobalProtect",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Final Configuration",
                        "icon": "00d7c19b984222630f20b6821425c3548e4b5094ecd846b03bde0994aaf08826",
                        "progresstext": "Finalizing Configuration …",
                        "trigger_list": [
                            {
                                "trigger": "finalConfiguration",
                                "validation": "None"
                            },
                            {
                                "trigger": "reconAtReboot",
                                "validation": "None"
                            }
                        ]
                    },
                    {
                        "listitem": "Computer Inventory",
                        "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
                        "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
                        "trigger_list": [
                            {
                                "trigger": "recon",
                                "validation": "None"
                            }
                        ]
                    }
                ]
            }
            '
            ;;

        "Recommended" )

            policyJSON='
            {
                "steps": [
                    {
                        "listitem": "Rosetta",
                        "icon": "8bac19160fabb0c8e7bac97b37b51d2ac8f38b7100b6357642d9505645d37b52",
                        "progresstext": "Rosetta enables a Mac with Apple silicon to use apps built for a Mac with an Intel processor.",
                        "trigger_list": [
                            {
                                "trigger": "rosettaInstall",
                                "validation": "None"
                            },
                            {
                                "trigger": "rosetta",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "FileVault Disk Encryption",
                        "icon": "f9ba35bd55488783456d64ec73372f029560531ca10dfa0e8154a46d7732b913",
                        "progresstext": "FileVault is built-in to macOS and provides full-disk encryption to help prevent unauthorized access to your Mac.",
                        "trigger_list": [
                            {
                                "trigger": "filevault",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint",
                        "icon": "c70f1acf8c96b99568fec83e165d2a534d111b0510fb561a283d32aa5b01c60c",
                        "progresstext": "You’ll enjoy next-gen protection with Sophos Endpoint which doesn’t rely on signatures to catch malware.",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpoint",
                                "validation": "/Applications/Sophos/Sophos Endpoint.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint Services (Local)",
                        "icon": "c05d087189f0b25a94f02eeb43b0c5c928e5e378f2168f603554bce2b5c71209",
                        "progresstext": "Locally validating Sophos Endpoint services …",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpointServices",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect",
                        "icon": "ea794c5a1850e735179c7c60919e3b51ed3ed2b301fe3f0f27ad5ebd394a2e4b",
                        "progresstext": "Use Palo Alto GlobalProtect to establish a Virtual Private Network (VPN) connection to Church headquarters.",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "/Applications/GlobalProtect.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect Services (Local)",
                        "icon": "709e8bdf0019e8faf9df85ec0a68545bfdb8bfa1227ac9bed9bba40a1fa8ff42",
                        "progresstext": "Locally validating Palo Alto GlobalProtect services …",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Microsoft Office 365",
                        "icon": "10e2ebed512e443189badcaf9143293d447f4a3fd8562cd419f6666ca07eb775",
                        "progresstext": "Microsoft Office 365 for Mac gives you the essentials to get it all done with the classic versions of the Office applications.",
                        "trigger_list": [
                            {
                                "trigger": "microsoftOffice365",
                                "validation": "/Applications/Microsoft Outlook.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Microsoft Teams",
                        "icon": "dcb65709dba6cffa90a5eeaa54cb548d5ecc3b051f39feadd39e02744f37c19e",
                        "progresstext": "Microsoft Teams is a hub for teamwork in Office 365. Keep all your team’s chats, meetings and files together in one place.",
                        "trigger_list": [
                            {
                                "trigger": "microsoftTeams",
                                "validation": "/Applications/Microsoft Teams.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Final Configuration",
                        "icon": "00d7c19b984222630f20b6821425c3548e4b5094ecd846b03bde0994aaf08826",
                        "progresstext": "Finalizing Configuration …",
                        "trigger_list": [
                            {
                                "trigger": "finalConfiguration",
                                "validation": "None"
                            },
                            {
                                "trigger": "reconAtReboot",
                                "validation": "None"
                            }
                        ]
                    },
                    {
                        "listitem": "Computer Inventory",
                        "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
                        "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
                        "trigger_list": [
                            {
                                "trigger": "recon",
                                "validation": "None"
                            }
                        ]
                    }
                ]
            }
            '
            ;;

        "Complete" )

            policyJSON='
            {
                "steps": [
                    {
                        "listitem": "Rosetta",
                        "icon": "8bac19160fabb0c8e7bac97b37b51d2ac8f38b7100b6357642d9505645d37b52",
                        "progresstext": "Rosetta enables a Mac with Apple silicon to use apps built for a Mac with an Intel processor.",
                        "trigger_list": [
                            {
                                "trigger": "rosettaInstall",
                                "validation": "None"
                            },
                            {
                                "trigger": "rosetta",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "FileVault Disk Encryption",
                        "icon": "f9ba35bd55488783456d64ec73372f029560531ca10dfa0e8154a46d7732b913",
                        "progresstext": "FileVault is built-in to macOS and provides full-disk encryption to help prevent unauthorized access to your Mac.",
                        "trigger_list": [
                            {
                                "trigger": "filevault",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint",
                        "icon": "c70f1acf8c96b99568fec83e165d2a534d111b0510fb561a283d32aa5b01c60c",
                        "progresstext": "You’ll enjoy next-gen protection with Sophos Endpoint which doesn’t rely on signatures to catch malware.",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpoint",
                                "validation": "/Applications/Sophos/Sophos Endpoint.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint Services (Local)",
                        "icon": "c05d087189f0b25a94f02eeb43b0c5c928e5e378f2168f603554bce2b5c71209",
                        "progresstext": "Locally validating Sophos Endpoint services …",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpointServices",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint Services (Remote)",
                        "icon": "c05d087189f0b25a94f02eeb43b0c5c928e5e378f2168f603554bce2b5c71209",
                        "progresstext": "Remotely validating Sophos Endpoint services …",
                        "trigger_list": [
                            {
                                "trigger": "symvSophosEndpointRTS",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect",
                        "icon": "ea794c5a1850e735179c7c60919e3b51ed3ed2b301fe3f0f27ad5ebd394a2e4b",
                        "progresstext": "Use Palo Alto GlobalProtect to establish a Virtual Private Network (VPN) connection to Church headquarters.",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "/Applications/GlobalProtect.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect Services (Local)",
                        "icon": "709e8bdf0019e8faf9df85ec0a68545bfdb8bfa1227ac9bed9bba40a1fa8ff42",
                        "progresstext": "Locally validating Palo Alto GlobalProtect services …",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect Services (Remote)",
                        "icon": "709e8bdf0019e8faf9df85ec0a68545bfdb8bfa1227ac9bed9bba40a1fa8ff42",
                        "progresstext": "Remotely validating Palo Alto GlobalProtect services …",
                        "trigger_list": [
                            {
                                "trigger": "symvGlobalProtect",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Microsoft Office 365",
                        "icon": "10e2ebed512e443189badcaf9143293d447f4a3fd8562cd419f6666ca07eb775",
                        "progresstext": "Microsoft Office 365 for Mac gives you the essentials to get it all done with the classic versions of the Office applications.",
                        "trigger_list": [
                            {
                                "trigger": "microsoftOffice365",
                                "validation": "/Applications/Microsoft Outlook.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Microsoft Teams",
                        "icon": "dcb65709dba6cffa90a5eeaa54cb548d5ecc3b051f39feadd39e02744f37c19e",
                        "progresstext": "Microsoft Teams is a hub for teamwork in Office 365. Keep all your team’s chats, meetings and files together in one place.",
                        "trigger_list": [
                            {
                                "trigger": "microsoftTeams",
                                "validation": "/Applications/Microsoft Teams.app/Contents/Info.plist"
                            }
                        ]
                    },                    {
                        "listitem": "Adobe Acrobat Reader",
                        "icon": "988b669ca27eab93a9bcd53bb7e2873fb98be4eaa95ae8974c14d611bea1d95f",
                        "progresstext": "Views, prints, and comments on PDF documents, and connects to Adobe Document Cloud.",
                        "trigger_list": [
                            {
                                "trigger": "adobeAcrobatReader",
                                "validation": "/Applications/Adobe Acrobat Reader.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Google Chrome",
                        "icon": "12d3d198f40ab2ac237cff3b5cb05b09f7f26966d6dffba780e4d4e5325cc701",
                        "progresstext": "Google Chrome is a browser that combines a minimal design with sophisticated technology to make the Web faster.",
                        "trigger_list": [
                            {
                                "trigger": "googleChrome",
                                "validation": "/Applications/Google Chrome.app/Contents/Info.plist"
                            }
                        ]
                    },
                    {
                        "listitem": "Final Configuration",
                        "icon": "00d7c19b984222630f20b6821425c3548e4b5094ecd846b03bde0994aaf08826",
                        "progresstext": "Finalizing Configuration …",
                        "trigger_list": [
                            {
                                "trigger": "finalConfiguration",
                                "validation": "None"
                            },
                            {
                                "trigger": "reconAtReboot",
                                "validation": "None"
                            }
                        ]
                    },
                    {
                        "listitem": "Computer Inventory",
                        "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
                        "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
                        "trigger_list": [
                            {
                                "trigger": "recon",
                                "validation": "None"
                            }
                        ]
                    }
                ]
            }
            '
            ;;

        * ) # Catch-all (i.e., used when `welcomeDialog` is set to `video` or `false`)

            policyJSON='
            {
                "steps": [
                    {
                        "listitem": "Rosetta",
                        "icon": "8bac19160fabb0c8e7bac97b37b51d2ac8f38b7100b6357642d9505645d37b52",
                        "progresstext": "Rosetta enables a Mac with Apple silicon to use apps built for a Mac with an Intel processor.",
                        "trigger_list": [
                            {
                                "trigger": "rosettaInstall",
                                "validation": "None"
                            },
                            {
                                "trigger": "rosetta",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "FileVault Disk Encryption",
                        "icon": "f9ba35bd55488783456d64ec73372f029560531ca10dfa0e8154a46d7732b913",
                        "progresstext": "FileVault is built-in to macOS and provides full-disk encryption to help prevent unauthorized access to your Mac.",
                        "trigger_list": [
                            {
                                "trigger": "filevault",
                                "validation": "Local"
                            }
                        ]
                    },
                    {
                        "listitem": "Sophos Endpoint",
                        "icon": "c70f1acf8c96b99568fec83e165d2a534d111b0510fb561a283d32aa5b01c60c",
                        "progresstext": "You’ll enjoy next-gen protection with Sophos Endpoint which doesn’t rely on signatures to catch malware.",
                        "trigger_list": [
                            {
                                "trigger": "sophosEndpoint",
                                "validation": "/Applications/Sophos/Sophos Endpoint.app/Contents/Info.plist"
                            },
                            {
                                "trigger": "symvSophosEndpointRTS",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Palo Alto GlobalProtect",
                        "icon": "ea794c5a1850e735179c7c60919e3b51ed3ed2b301fe3f0f27ad5ebd394a2e4b",
                        "progresstext": "Use Palo Alto GlobalProtect to establish a Virtual Private Network (VPN) connection to Church headquarters.",
                        "trigger_list": [
                            {
                                "trigger": "globalProtect",
                                "validation": "/Applications/GlobalProtect.app/Contents/Info.plist"
                            },
                            {
                                "trigger": "symvGlobalProtect",
                                "validation": "Remote"
                            }
                        ]
                    },
                    {
                        "listitem": "Final Configuration",
                        "icon": "00d7c19b984222630f20b6821425c3548e4b5094ecd846b03bde0994aaf08826",
                        "progresstext": "Finalizing Configuration …",
                        "trigger_list": [
                            {
                                "trigger": "finalConfiguration",
                                "validation": "None"
                            },
                            {
                                "trigger": "reconAtReboot",
                                "validation": "None"
                            }
                        ]
                    },
                    {
                        "listitem": "Computer Inventory",
                        "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
                        "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
                        "trigger_list": [
                            {
                                "trigger": "recon",
                                "validation": "None"
                            }
                        ]
                    }
                ]
            }
            '
            ;;

    esac

}
=======
# - path: The filepath for validation
#
=======
#       - Remote (for validation validation via a single-script Jamf Pro policy, for example: "symvGlobalProtect")
#       - None (for triggers which don't require validation, for example: recon; always evaluates as successful)
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# The fully qualified domain name of the server which hosts your icons, including any required sub-directories
setupYourMacPolicyArrayIconPrefixUrl="https://ics.services.jamfcloud.com/icon/hash_"

# shellcheck disable=SC1112 # use literal slanted single quotes for typographic reasons
policy_array=('
{
    "steps": [
        {
            "listitem": "Rosetta",
            "icon": "8bac19160fabb0c8e7bac97b37b51d2ac8f38b7100b6357642d9505645d37b52",
            "progresstext": "Rosetta enables a Mac with Apple silicon to use apps built for a Mac with an Intel processor.",
            "trigger_list": [
                {
                    "trigger": "install_rosetta",
                    "validation": "Local"
                }            ]
        },

        {
            "listitem": "Code42",
            "icon": "c6eea7e3663ad37c248dc6881ed97498048f502da8a427caefaf6d31963f3681",
            "progresstext": "Install the EC Data Protection and Backup Software",
            "trigger_list": [
                {
                    "trigger": "'code42_${type}'",
                    "validation": "/Applications/Code42.app/Contents/Info.plist"
                }
            ]
},
{
            "listitem": "Crowdstrike Falcon",
            "icon": "5dbbf8eebbecb20ac443f958bfb3aa9a44ed23ce4f49005a12b29a8f33522c8b",
            "progresstext": "Install The Computer Security Software",
            "trigger_list": [
                {
                    "trigger": "install_crowdstrike",
                    "validation": "/Applications/Falcon.app/Contents/Info.plist"                }
            ]
        },        {
            "listitem": "Enable Filevault 2",
            "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
            "progresstext": "Install and Configure macOS FileVault 2.",
            "trigger_list": [
                {
                    "trigger": "enable_filevault",
                    "validation": "Local"
                }
            ]
        },
        {
            "listitem": "Microsoft Office 365",
            "icon": "f9ba35bd55488783456d64ec73372f029560531ca10dfa0e8154a46d7732b913",
            "progresstext": "Utilize the full Microsoft 365 suite of applicaitons.",
            "trigger_list": [
                {
                    "trigger": "install_365",
                    "validation": "/Applications/Microsoft Outlook.app/Contents/Info.plist"
                }
            ]
        },
        {
            "listitem": "Zoom",
            "icon": "be66420495a3f2f1981a49a0e0ad31783e9a789e835b4196af60554bf4c115ac",
            "progresstext": "Zoom is a videotelephony software program developed by Zoom Video Communications.",
            "trigger_list": [
                {
                    "trigger": "install_zoom",
                    "validation": "/Applications/zoom.us.app/Contents/Info.plist"
                }
            ]
        },{
            "listitem": "Google Chrome",
            "icon": "12d3d198f40ab2ac237cff3b5cb05b09f7f26966d6dffba780e4d4e5325cc701",
            "progresstext": "Browse the Internet with ease",
            "trigger_list": [
                {
                    "trigger": "install_google_chrome",
                    "validation": "/Applications/Google Chrome.app/Contents/Info.plist"
                }
            ]
        },
        
{
            "listitem": "Slack",
            "icon": "a1ecbe1a4418113177cc061def4996d20a01a1e9b9adf9517899fcca31f3c026",
            "progresstext": "Install Slack Messaging System",
            "trigger_list": [
                {
                    "trigger": "install_slack",
                    "validation": "/Applications/Slack.app/Contents/Info.plist"
                }
            ]
        },
       {
            "listitem": "Google Drive",
            "icon": "a6954a50da661bd785407e23f83c6a1ac27006180eae1813086e64f4d6e65dcc",
            "progresstext": "The Preferred Cloud Storage Of The Collective.",
            "trigger_list": [
                {
                    "trigger": "install_google_drive",
                    "validation": "/Applications/Google Drive.app/Contents/Info.plist"
                }
            ]
        },{
            "listitem": "Conditional Access Tool",
            "icon": "7a97c3926c07d26c111a1f5c3d11fcaeb8471f6046e7b289d67bac74669f916a",
            "progresstext": "Ensure that Collective data is accessed by approved devices.",
            "trigger_list": [
                {
                    "trigger": "'okta_cba_${type}'",
                    "validation": "Local"
                }
            ]
        },
        {
            "listitem": "Crowdstrike Running Validation",
            "icon": "5dbbf8eebbecb20ac443f958bfb3aa9a44ed23ce4f49005a12b29a8f33522c8b",
            "progresstext": "Verify that the Crowdstrike Falcon agent is running",
            "trigger_list": [
                {
                    "trigger": "crowdstrike_validation",
                    "validation": "Remote"
                }
            ]

        },
        {
            "listitem": "Code42 Running Validation",
            "icon": "c6eea7e3663ad37c248dc6881ed97498048f502da8a427caefaf6d31963f3681",
            "progresstext": "Verify that the Code42 agent is running",
            "trigger_list": [
                {
                    "trigger": "code42_validate",
                    "validation": "Remote"
                }
            ]

        },
        {
            "listitem": "Re-name Computer",
            "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
            "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
            "trigger_list": [
                {
                    "trigger": "rename_computer",
                    "validation": "None"
                }
            ]
        },
                    {
            "listitem": "Computer Inventory",
            "icon": "90958d0e1f8f8287a86a1198d21cded84eeea44886df2b3357d909fe2e6f1296",
            "progresstext": "A listing of your Mac’s apps and settings — its inventory — is sent automatically to the Jamf Pro server daily.",
            "trigger_list": [
                {
                    "trigger": "recon",
                    "validation": "None"
                }
            ]
        }
    ]
}
')
>>>>>>> 0bc3777 (oops I had removed it)



####################################################################################################
#
# Failure dialog
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Failure" dialog Title, Message and Icon
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

failureTitle="Failure Detected"
failureMessage="Placeholder message; update in the 'finalise' function"
failureIcon="SF=xmark.circle.fill,weight=bold,colour1=#BB1717,colour2=#F31F1F"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# "Failure" dialog Settings and Features
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
dialogFailureCMD="$dialogBinary \
=======
dialogFailureCMD="$dialogApp \
>>>>>>> 0bc3777 (oops I had removed it)
=======
dialogFailureCMD="$dialogApp \
>>>>>>> 6a67ebc (bad merge, reverting)
=======
dialogFailureCMD="$dialogBinary \
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
--moveable \
--title \"$failureTitle\" \
--message \"$failureMessage\" \
--icon \"$failureIcon\" \
--iconsize 125 \
--width 625 \
<<<<<<< HEAD
<<<<<<< HEAD
--height 525 \
=======
--height 400 \
>>>>>>> 0bc3777 (oops I had removed it)
=======
--height 500 \
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
--position topright \
--button1text \"Close\" \
--infotext \"$scriptVersion\" \
--titlefont 'size=22' \
--messagefont 'size=14' \
--overlayicon \"$overlayicon\" \
--commandfile \"$failureCommandFile\" "



#------------------------ With the execption of the `finalise` function, -------------------------#
#------------------------ edits below these line are optional. -----------------------------------#



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Dynamically set `button1text` based on the value of `completionActionOption`
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

case ${completionActionOption} in
    
    "Shut Down" )
        button1textCompletionActionOption="Shutting Down …"
        progressTextCompletionAction="shut down and "
    ;;
    
    "Shut Down "* )
        button1textCompletionActionOption="Shut Down"
        progressTextCompletionAction="shut down and "
    ;;
    
    "Restart" )
        button1textCompletionActionOption="Restarting …"
        progressTextCompletionAction="restart and "
    ;;
    
    "Restart "* )
        button1textCompletionActionOption="Restart"
        progressTextCompletionAction="restart and "
    ;;
    
    "Log Out" )
        button1textCompletionActionOption="Logging Out …"
        progressTextCompletionAction="log out and "
    ;;
    
    "Log Out "* )
        button1textCompletionActionOption="Log Out"
        progressTextCompletionAction="log out and "
    ;;
    
    "Sleep"* )
        button1textCompletionActionOption="Close"
        progressTextCompletionAction=""
    ;;
    
    "Quit" )
        button1textCompletionActionOption="Quit"
        progressTextCompletionAction=""
    ;;
    
    * )
        button1textCompletionActionOption="Close"
        progressTextCompletionAction=""
    ;;
    
esac



####################################################################################################
#
# Functions
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
=======
# Client-side Script Logging
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function updateScriptLog() {
    echo -e "$( date +%Y-%m-%d\ %H:%M:%S ) - ${1}" | tee -a "${scriptLog}"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
>>>>>>> 0bc3777 (oops I had removed it)
# Run command as logged-in user (thanks, @scriptingosx!)
# shellcheck disable=SC2145
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function runAsUser() {
    
    updateScriptLog "Run \"$@\" as \"$loggedInUserID\" … "
    launchctl asuser "$loggedInUserID" sudo -u "$loggedInUser" "$@"
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
=======
# Check for / install swiftDialog (Thanks big bunches, @acodega!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dialogCheck() {
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    # Get the URL of the latest PKG From the Dialog GitHub repo
    dialogURL=$(curl --silent --fail "https://api.github.com/repos/bartreardon/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
    
    # Expected Team ID of the downloaded PKG
    expectedDialogTeamID="PWA5E9TQ59"
    
    # Check for Dialog and install if not found
    if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then
        
        updateScriptLog "Dialog not found. Installing..."
        
        # Create temporary working directory
        workDirectory=$( /usr/bin/basename "$0" )
        tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
        
        # Download the installer package
        /usr/bin/curl --location --silent "$dialogURL" -o "$tempDirectory/Dialog.pkg"
        
        # Verify the download
        teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
        
        # Install the package if Team ID validates
        if [[ "$expectedDialogTeamID" == "$teamID" ]]; then
            
            /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
            sleep 2
            updateScriptLog "swiftDialog version $(dialog --version) installed; proceeding..."
            
        else
            
            # Display a so-called "simple" dialog if Team ID fails to validate
            runAsUser osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\r• Dialog Team ID verification failed\r\r" with title "Setup Your Mac: Error" buttons {"Close"} with icon caution'
            completionActionOption="Quit"
            exitCode="1"
            quitScript
            
        fi
        
        # Remove the temporary working directory when done
        /bin/rm -Rf "$tempDirectory"
        
    else
        
        updateScriptLog "swiftDialog version $(dialog --version) found; proceeding..."
        
    fi
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
>>>>>>> 0bc3777 (oops I had removed it)
# Update the "Welcome" dialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dialogUpdateWelcome(){
    updateScriptLog "WELCOME DIALOG: $1"
    echo "$1" >> "$welcomeCommandFile"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Update the "Setup Your Mac" dialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dialogUpdateSetupYourMac() {
    updateScriptLog "SETUP YOUR MAC DIALOG: $1"
    echo "$1" >> "$setupYourMacCommandFile"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Update the "Failure" dialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dialogUpdateFailure(){
    updateScriptLog "FAILURE DIALOG: $1"
    echo "$1" >> "$failureCommandFile"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Finalise User Experience
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function finalise(){
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

=======
>>>>>>> 6a67ebc (bad merge, reverting)
    if [[ "${jamfProPolicyTriggerFailure}" == "failed" ]]; then

        killProcess "caffeinate"
=======
=======
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    if [[ "${jamfProPolicyTriggerFailure}" == "failed" ]]; then
        
        killProcess "caffeinate"
<<<<<<< HEAD
        updateScriptLog "Jamf Pro Policy Name Failures: ${jamfProPolicyPolicyNameFailures}"
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        dialogUpdateSetupYourMac "title: Sorry ${loggedInUserFirstname}, something went sideways"
        dialogUpdateSetupYourMac "icon: SF=xmark.circle.fill,weight=bold,colour1=#BB1717,colour2=#F31F1F"
        dialogUpdateSetupYourMac "progresstext: Failures detected. Please click Continue for troubleshooting information."
        dialogUpdateSetupYourMac "button1text: Continue …"
        dialogUpdateSetupYourMac "button1: enable"
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        dialogUpdateSetupYourMac "progress: reset"
=======
        dialogUpdateSetupYourMac "progress: complete"
>>>>>>> 0bc3777 (oops I had removed it)
=======
        dialogUpdateSetupYourMac "progress: complete"
>>>>>>> 6a67ebc (bad merge, reverting)

=======
        dialogUpdateSetupYourMac "progress: reset"
        
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        # Wait for user-acknowledgment due to detected failure
        wait
        
        dialogUpdateSetupYourMac "quit:"
        eval "${dialogFailureCMD}" & sleep 0.3
<<<<<<< HEAD

<<<<<<< HEAD
        updateScriptLog "\n\n# # #\n# FAILURE DIALOG\n# # #\n"
        updateScriptLog "Jamf Pro Policy Name Failures:"
        updateScriptLog "${jamfProPolicyNameFailures}"

        dialogUpdateFailure "message: A failure has been detected, ${loggedInUserFirstname}.  \n\nPlease complete the following steps:\n1. Reboot and login to your Mac  \n2. Login to Self Service  \n3. Re-run any failed policy listed below  \n\nThe following failed:  \n${jamfProPolicyNameFailures}  \n\n\n\nIf you need assistance, please contact the Help Desk,  \n+1 (801) 555-1212, and mention [KB86753099](https://servicenow.company.com/support?id=kb_article_view&sysparm_article=KB86753099#Failures). "
=======
        dialogUpdateFailure "message: A failure has been detected, ${loggedInUserFirstname}.  \n\The following failed to install:  \n${jamfProPolicyPolicyNameFailures}  \n\n\n\nIf you need assistance, please ithelp@emersoncollective.com,"
>>>>>>> 0bc3777 (oops I had removed it)
=======
        
        updateScriptLog "\n\n# # #\n# FAILURE DIALOG\n# # #\n"
        updateScriptLog "Jamf Pro Policy Name Failures:"
        updateScriptLog "${jamfProPolicyNameFailures}"
        
        dialogUpdateFailure "message: A failure has been detected, ${loggedInUserFirstname}.  \n\nPlease complete the following steps:\n1. Reboot and login to your Mac  \n2. Login to Self Service  \n3. Re-run any failed policy listed below  \n\nThe following failed:  \n${jamfProPolicyNameFailures}  \n\n\n\nIf you need assistance, please contact the IT Team via email at ithelp@emersoncollective.com. "
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        dialogUpdateFailure "icon: SF=xmark.circle.fill,weight=bold,colour1=#BB1717,colour2=#F31F1F"
        dialogUpdateFailure "button1text: ${button1textCompletionActionOption}"
        
        # Wait for user-acknowledgment due to detected failure
        wait
        
        dialogUpdateFailure "quit:"
        quitScript "1"
        
    else
        
        dialogUpdateSetupYourMac "title: ${loggedInUserFirstname}'s Mac is ready!"
        dialogUpdateSetupYourMac "icon: SF=checkmark.circle.fill,weight=bold,colour1=#00ff44,colour2=#075c1e"
        dialogUpdateSetupYourMac "progresstext: Complete! Please ${progressTextCompletionAction}enjoy your new Mac, ${loggedInUserFirstname}!"
        dialogUpdateSetupYourMac "progress: complete"
        dialogUpdateSetupYourMac "button1text: ${button1textCompletionActionOption}"
        dialogUpdateSetupYourMac "button1: enable"
        
        # If either "wait" or "sleep" has been specified for `completionActionOption`, honor that behavior
        if [[ "${completionActionOption}" == "wait" ]] || [[ "${completionActionOption}" == "[Ss]leep"* ]]; then
            updateScriptLog "Honoring ${completionActionOption} behavior …"
            eval "${completionActionOption}" "${dialogSetupYourMacProcessID}"
        fi
        
        quitScript "0"
        
    fi
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Parse JSON via osascript and JavaScript
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function get_json_value() {
    JSON="$1" osascript -l 'JavaScript' \
    -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' \
    -e "JSON.parse(env).$2"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Parse JSON via osascript and JavaScript for the Welcome dialog (thanks, @bartreardon!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
function get_json_value_welcomeDialog() {
=======
function get_json_value_welcomeDialog () {
>>>>>>> 0bc3777 (oops I had removed it)
=======
function get_json_value_welcomeDialog() {
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    for var in "${@:2}"; do jsonkey="${jsonkey}['${var}']"; done
    JSON="$1" osascript -l 'JavaScript' \
    -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' \
    -e "JSON.parse(env)$jsonkey"
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Execute Jamf Pro Policy Custom Events (thanks, @smithjw)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function run_jamf_trigger() {
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

=======
>>>>>>> 6a67ebc (bad merge, reverting)
    trigger="$1"

    if [[ "${debugMode}" == "true" ]]; then

        updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: TRIGGER: $jamfBinary policy -trigger $trigger"
=======
    trigger="$1"

    if [[ "${debugMode}" == "true" ]]; then

        updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: TRIGGER: $jamfBinary policy -event $trigger"
>>>>>>> 0bc3777 (oops I had removed it)
=======
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    trigger="$1"
    
    if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
        
        updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: TRIGGER: $jamfBinary policy -trigger $trigger"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        if [[ "$trigger" == "recon" ]]; then
            updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: RECON: $jamfBinary recon ${reconOptions}"
        fi
        sleep 1
        
    elif [[ "$trigger" == "recon" ]]; then
        
        dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Updating …, "
        updateScriptLog "SETUP YOUR MAC DIALOG: Updating computer inventory with the following reconOptions: \"${reconOptions}\" …"
        eval "${jamfBinary} recon ${reconOptions}"
        
    else
        
        updateScriptLog "SETUP YOUR MAC DIALOG: RUNNING: $jamfBinary policy -trigger $trigger"
        eval "${jamfBinary} policy -trigger ${trigger}"                                     # Add comment for policy testing
        # eval "${jamfBinary} policy -trigger ${trigger} -verbose | tee -a ${scriptLog}"    # Remove comment for policy testing
        
    fi
    
}

<<<<<<< HEAD
<<<<<<< HEAD
        updateScriptLog "SETUP YOUR MAC DIALOG: RUNNING: $jamfBinary policy -trigger $trigger"
        eval "${jamfBinary} policy -trigger ${trigger}"                                     # Add comment for policy testing
        # eval "${jamfBinary} policy -trigger ${trigger} -verbose | tee -a ${scriptLog}"    # Remove comment for policy testing
=======
        updateScriptLog "SETUP YOUR MAC DIALOG: RUNNING: $jamfBinary policy -event $trigger"
        "$jamfBinary" policy -event "$trigger"
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Confirm Policy Execution
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function confirmPolicyExecution() {
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    trigger="${1}"
    validation="${2}"
    updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: '${trigger}' '${validation}'"
    
    case ${validation} in
        
        */* ) # If the validation variable contains a forward slash (i.e., "/"), presume it's a path and check if that path exists on disk
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: DEBUG MODE: Skipping 'run_jamf_trigger ${trigger}'"
                sleep 0.5
            elif [[ -f "${validation}" ]]; then
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation} exists; skipping 'run_jamf_trigger ${trigger}'"
            else
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation} does NOT exist; executing 'run_jamf_trigger ${trigger}'"
                run_jamf_trigger "${trigger}"
            fi
        ;;
        
        "None" )
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation}"
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                sleep 0.5
            else
                run_jamf_trigger "${trigger}"
            fi
        ;;
        
        * )
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution Catch-all: ${validation}"
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                sleep 0.5
            else
                run_jamf_trigger "${trigger}"
            fi
        ;;
        
    esac
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Validate Policy Result
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function validatePolicyResult() {
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    trigger="${1}"
    validation="${2}"
    updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: '${trigger}' '${validation}'"
    
    case ${validation} in
        
        ###
        # Absolute Path
        # Simulates pre-v1.6.0 behavior, for example: "/Applications/Microsoft Teams.app/Contents/Info.plist"
        ###
        
        */* ) 
            updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: Testing for \"$validation\" …"
            if [[ -f "${validation}" ]]; then
                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Installed"
            else
                dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                jamfProPolicyTriggerFailure="failed"
                exitCode="1"
                jamfProPolicyNameFailures+="• $listitem  \n"
            fi
        ;;
        
        
        
        ###
        # Local
        # Validation within this script, for example: "rosetta" or "filevault"
        ###
        
        "Local" )
            case ${trigger} in
                install_rosetta ) 
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 … " # Thanks, @smithjw!
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    arch=$( /usr/bin/arch )
                    if [[ "${arch}" == "arm64" ]]; then
                        # Mac with Apple silicon; check for Rosetta
                        rosettaTest=$( arch -x86_64 /usr/bin/true 2> /dev/null ; echo $? )
                        if [[ "${rosettaTest}" -eq 0 ]]; then
                            # Installed
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is installed"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                        else
                            # Not Installed
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is NOT installed"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                            jamfProPolicyTriggerFailure="failed"
                            exitCode="1"
                            jamfProPolicyNameFailures+="• $listitem  \n"
                        fi
                    else
                        # Inelligible
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is not applicable"
                        dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Inelligible"
                    fi
                ;;
                enable_filevault )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Validate FileVault … "
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: Pausing for 5 seconds for FileVault … "
                    sleep 5 # Arbitrary value; tuning needed
                    if [[ -f /Library/Preferences/com.apple.fdesetup.plist ]]; then
                        fileVaultStatus=$( fdesetup status -extended -verbose 2>&1 )
                        case ${fileVaultStatus} in
                            *"FileVault is On."* ) 
                                updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: FileVault: FileVault is On."
                                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Enabled"
                            ;;
                            *"Deferred enablement appears to be active for user"* )
                                updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: FileVault: Enabled"
                                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Enabled (next login)"
                            ;;
                            *  )
                                dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Unknown"
                                jamfProPolicyTriggerFailure="failed"
                                exitCode="1"
                                jamfProPolicyNameFailures+="• $listitem  \n"
                            ;;
                        esac
                    else
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: '/Library/Preferences/com.apple.fdesetup.plist' NOT Found"
                        dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                        jamfProPolicyTriggerFailure="failed"
                        exitCode="1"
                        jamfProPolicyNameFailures+="• $listitem  \n"
                    fi
                ;;
                okta_cba_${type} )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Validate CBA … "
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: Pausing for 5 seconds for CBA … "
                    sleep 5 # Arbitrary value; tuning needed
                    if [[ $(security find-generic-password -l device_trust -w) ]]; then
                        echo "CBA Key Found"
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: CBA: CBA is Installed."
                        dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Enabled"
                    else
                        echo "CBA Key Not Found"
                        dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Unknown"
                        jamfProPolicyTriggerFailure="failed"
                        exitCode="1"
                        jamfProPolicyNameFailures+="• $listitem  \n"
                    fi
                    
                    
            esac
        ;;
        
        
        
        ###
        # Remote
        # Validation via a Jamf Pro policy which has a single-script payload, for example: "symvGlobalProtect"
        # See: https://vimeo.com/782561166
        ###
        
        "Remote" )
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: Remotely Confirm Policy Execution: Skipping 'run_jamf_trigger ${trigger}'"
                dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Debug Mode Enabled"
                sleep 0.5
            else
                updateScriptLog "SETUP YOUR MAC DIALOG: Remotely Validate '${trigger}' '${validation}'"
                dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                result=$( "${jamfBinary}" policy -trigger "${trigger}" | grep "Script result:" )
                if [[ "${result}" == *"Running"* ]]; then
                    dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                else
                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                    jamfProPolicyTriggerFailure="failed"
                    exitCode="1"
                    jamfProPolicyNameFailures+="• $listitem  \n"
                fi
            fi
        ;;
        
        
        
        ###
        # None (always evaluates as successful)
        # For triggers which don't require validation, for example: recon
        ###
        
        "None" )
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation}"
            dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Installed"
            if [[ "${trigger}" == "recon" ]]; then
                dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Updating …, "
                updateScriptLog "SETUP YOUR MAC DIALOG: Updating computer inventory with the following reconOptions: \"${reconOptions}\" …"
                if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                    updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: eval ${jamfBinary} recon ${reconOptions}"
                else
                    eval "${jamfBinary} recon ${reconOptions}"
                fi
                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Updated"
            fi
        ;;
        
        
        
        ###
        # Catch-all
        ###
        
        * )
            updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Results Catch-all: ${validation}"
            dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Error"
        ;;
        
    esac
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
# Confirm Policy Execution
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function confirmPolicyExecution() {

    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    trigger="${1}"
    validation="${2}"
    updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: '${trigger}' '${validation}'"

    case ${validation} in

        */* ) # If the validation variable contains a forward slash (i.e., "/"), presume it's a path and check if that path exists on disk
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: DEBUG MODE: Skipping 'run_jamf_trigger ${trigger}'"
                sleep 1
            elif [[ -f "${validation}" ]]; then
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation} exists; skipping 'run_jamf_trigger ${trigger}'"
            else
                updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation} does NOT exist; executing 'run_jamf_trigger ${trigger}'"
                run_jamf_trigger "${trigger}"
            fi
            ;;

        "None" )
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation}"
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                sleep 1
            else
                run_jamf_trigger "${trigger}"
            fi
            ;;

        * )
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution Catch-all: ${validation}"
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                sleep 1
            else
                run_jamf_trigger "${trigger}"
            fi
            ;;

    esac

}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Validate Policy Result
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function validatePolicyResult() {

    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    trigger="${1}"
    validation="${2}"
    updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: '${trigger}' '${validation}'"

    case ${validation} in

        ###
        # Absolute Path
        # Simulates pre-v1.6.0 behavior, for example: "/Applications/Microsoft Teams.app/Contents/Info.plist"
        ###

        */* ) 
            updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: Testing for \"$validation\" …"
            if [[ -f "${validation}" ]]; then
                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Installed"
            else
                dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                jamfProPolicyTriggerFailure="failed"
                exitCode="1"
                jamfProPolicyNameFailures+="• $listitem  \n"
            fi
            ;;



        ###
        # Local
        # Validation within this script, for example: "rosetta" or "filevault"
        ###

        "Local" )
            case ${trigger} in
                rosetta ) 
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 … " # Thanks, @smithjw!
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    arch=$( /usr/bin/arch )
                    if [[ "${arch}" == "arm64" ]]; then
                        # Mac with Apple silicon; check for Rosetta
                        rosettaTest=$( arch -x86_64 /usr/bin/true 2> /dev/null ; echo $? )
                        if [[ "${rosettaTest}" -eq 0 ]]; then
                            # Installed
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is installed"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                        else
                            # Not Installed
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is NOT installed"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                            jamfProPolicyTriggerFailure="failed"
                            exitCode="1"
                            jamfProPolicyNameFailures+="• $listitem  \n"
                        fi
                    else
                        # Inelligible
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Rosetta 2 is not applicable"
                        dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Inelligible"
                    fi
                    ;;
                filevault )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Validate FileVault … "
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Result: Pausing for 5 seconds for FileVault … "
                    sleep 5 # Arbitrary value; tuning needed
                    if [[ -f /Library/Preferences/com.apple.fdesetup.plist ]]; then
                        fileVaultStatus=$( fdesetup status -extended -verbose 2>&1 )
                        case ${fileVaultStatus} in
                            *"FileVault is On."* ) 
                                updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: FileVault: FileVault is On."
                                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Enabled"
                                ;;
                            *"Deferred enablement appears to be active for user"* )
                                updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: FileVault: Enabled"
                                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Enabled (next login)"
                                ;;
                            *  )
                                dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Unknown"
                                jamfProPolicyTriggerFailure="failed"
                                exitCode="1"
                                jamfProPolicyNameFailures+="• $listitem  \n"
                                ;;
                        esac
                    else
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: '/Library/Preferences/com.apple.fdesetup.plist' NOT Found"
                        dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                        jamfProPolicyTriggerFailure="failed"
                        exitCode="1"
                        jamfProPolicyNameFailures+="• $listitem  \n"
                    fi
                    ;;
                sophosEndpointServices )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Sophos Endpoint RTS Status … "
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    if [[ -d /Applications/Sophos/Sophos\ Endpoint.app ]]; then
                        if [[ -f /Library/Preferences/com.sophos.sav.plist ]]; then
                            sophosOnAccessRunning=$( /usr/bin/defaults read /Library/Preferences/com.sophos.sav.plist OnAccessRunning )
                            case ${sophosOnAccessRunning} in
                                "0" ) 
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Sophos Endpoint RTS Status: Disabled"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                                    jamfProPolicyTriggerFailure="failed"
                                    exitCode="1"
                                    jamfProPolicyNameFailures+="• $listitem  \n"
                                    ;;
                                "1" )
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Sophos Endpoint RTS Status: Enabled"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                                    ;;
                                *  )
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Sophos Endpoint RTS Status: Unknown"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Unknown"
                                    jamfProPolicyTriggerFailure="failed"
                                    exitCode="1"
                                    jamfProPolicyNameFailures+="• $listitem  \n"
                                    ;;
                            esac
                        else
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Sophos Endpoint Not Found"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                            jamfProPolicyTriggerFailure="failed"
                            exitCode="1"
                            jamfProPolicyNameFailures+="• $listitem  \n"
                        fi
                    else
                        dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                        jamfProPolicyTriggerFailure="failed"
                        exitCode="1"
                        jamfProPolicyNameFailures+="• $listitem  \n"
                    fi
                    ;;
                globalProtect )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Palo Alto Networks GlobalProtect Status … "
                    dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                    if [[ -d /Applications/GlobalProtect.app ]]; then
                        updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Pausing for 10 seconds to allow Palo Alto Networks GlobalProtect Services … "
                        sleep 10 # Arbitrary value; tuning needed
                        if [[ -f /Library/Preferences/com.paloaltonetworks.GlobalProtect.settings.plist ]]; then
                            globalProtectStatus=$( /usr/libexec/PlistBuddy -c "print :Palo\ Alto\ Networks:GlobalProtect:PanGPS:disable-globalprotect" /Library/Preferences/com.paloaltonetworks.GlobalProtect.settings.plist )
                            case "${globalProtectStatus}" in
                                "0" )
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Palo Alto Networks GlobalProtect Status: Enabled"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                                    ;;
                                "1" )
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Palo Alto Networks GlobalProtect Status: Disabled"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                                    jamfProPolicyTriggerFailure="failed"
                                    exitCode="1"
                                    jamfProPolicyNameFailures+="• $listitem  \n"
                                    ;;
                                *  )
                                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Palo Alto Networks GlobalProtect Status: Unknown"
                                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Unknown"
                                    jamfProPolicyTriggerFailure="failed"
                                    exitCode="1"
                                    jamfProPolicyNameFailures+="• $listitem  \n"
                                    ;;
                            esac
                        else
                            updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Result: Palo Alto Networks GlobalProtect Not Found"
                            dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                            jamfProPolicyTriggerFailure="failed"
                            exitCode="1"
                            jamfProPolicyNameFailures+="• $listitem  \n"
                        fi
                    else
                        dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                        jamfProPolicyTriggerFailure="failed"
                        exitCode="1"
                        jamfProPolicyNameFailures+="• $listitem  \n"
                    fi
                    ;;
                * )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Locally Validate Policy Results Local Catch-all: ${validation}"
                    ;;
            esac
            ;;



        ###
        # Remote
        # Validation via a Jamf Pro policy which has a single-script payload, for example: "symvGlobalProtect"
        # See: https://vimeo.com/782561166
        ###

        "Remote" )
            if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: Remotely Confirm Policy Execution: Skipping 'run_jamf_trigger ${trigger}'"
                dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Debug Mode Enabled"
                sleep 0.5
            else
                updateScriptLog "SETUP YOUR MAC DIALOG: Remotely Validate '${trigger}' '${validation}'"
                dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Checking …"
                result=$( "${jamfBinary}" policy -trigger "${trigger}" | grep "Script result:" )
                if [[ "${result}" == *"Running"* ]]; then
                    dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Running"
                else
                    dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
                    jamfProPolicyTriggerFailure="failed"
                    exitCode="1"
                    jamfProPolicyNameFailures+="• $listitem  \n"
                fi
            fi
            ;;



        ###
        # None (always evaluates as successful)
        # For triggers which don't require validation, for example: recon
        ###

        "None" )
            # Output Line Number in `verbose` Debug Mode
            if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
            updateScriptLog "SETUP YOUR MAC DIALOG: Confirm Policy Execution: ${validation}"
            dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Installed"
            if [[ "${trigger}" == "recon" ]]; then
                dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Updating …, "
                updateScriptLog "SETUP YOUR MAC DIALOG: Updating computer inventory with the following reconOptions: \"${reconOptions}\" …"
                if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                    updateScriptLog "SETUP YOUR MAC DIALOG: DEBUG MODE: eval ${jamfBinary} recon ${reconOptions}"
                else
                    eval "${jamfBinary} recon ${reconOptions}"
                fi
                dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Updated"
            fi
            ;;



        ###
        # Catch-all
        ###

        * )
            # Output Line Number in `verbose` Debug Mode
            if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
            updateScriptLog "SETUP YOUR MAC DIALOG: Validate Policy Results Catch-all: ${validation}"
            dialogUpdateSetupYourMac "listitem: index: $i, status: error, statustext: Error"
            ;;

    esac

}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
# Kill a specified process (thanks, @grahampugh!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function killProcess() {
    process="$1"
    if process_pid=$( pgrep -a "${process}" 2>/dev/null ) ; then
        updateScriptLog "Attempting to terminate the '$process' process …"
        updateScriptLog "(Termination message indicates success.)"
        kill "$process_pid" 2> /dev/null
        if pgrep -a "$process" >/dev/null ; then
            updateScriptLog "ERROR: '$process' could not be terminated."
        fi
    else
        updateScriptLog "The '$process' process isn't running."
    fi
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Completion Action (i.e., Wait, Sleep, Logout, Restart or Shutdown)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function completionAction() {
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
=======
    if [[ "${debugMode}" == "true" ]]; then
>>>>>>> 0bc3777 (oops I had removed it)
=======
    if [[ "${debugMode}" == "true" ]]; then
>>>>>>> 6a67ebc (bad merge, reverting)

=======
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
        
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        # If Debug Mode is enabled, ignore specified `completionActionOption`, display simple dialog box and exit
        runAsUser osascript -e 'display dialog "Setup Your Mac is operating in Debug Mode.\r\r• completionActionOption == '"'${completionActionOption}'"'\r\r" with title "Setup Your Mac: Debug Mode" buttons {"Close"} with icon note'
        exitCode="0"
        
    else
        
        shopt -s nocasematch
        
        case ${completionActionOption} in
            
            "Shut Down" )
                updateScriptLog "Shut Down sans user interaction"
                killProcess "Self Service"
                # runAsUser osascript -e 'tell app "System Events" to shut down'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                sleep 5 && shutdown -h now &
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                # shutdown -h +1 &
>>>>>>> 0bc3777 (oops I had removed it)
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                # shutdown -h +1 &
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                sleep 5 && shutdown -h now &
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Shut Down Attended" )
                updateScriptLog "Shut Down, requiring user-interaction"
                killProcess "Self Service"
                wait
                # runAsUser osascript -e 'tell app "System Events" to shut down'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                sleep 5 && shutdown -h now &
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                # shutdown -h +1 &
>>>>>>> 0bc3777 (oops I had removed it)
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                # shutdown -h +1 &
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to shut down' &
                sleep 5 && shutdown -h now &
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Shut Down Confirm" )
                updateScriptLog "Shut down, only after macOS time-out or user confirmation"
                runAsUser osascript -e 'tell app "loginwindow" to «event aevtrsdn»'
            ;;
            
            "Restart" )
                updateScriptLog "Restart sans user interaction"
                killProcess "Self Service"
                # runAsUser osascript -e 'tell app "System Events" to restart'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                sleep 5 && shutdown -r now &
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                # shutdown -r +1 &
>>>>>>> 0bc3777 (oops I had removed it)
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                # shutdown -r +1 &
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                sleep 5 && shutdown -r now &
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Restart Attended" )
                updateScriptLog "Restart, requiring user-interaction"
                killProcess "Self Service"
                wait
                # runAsUser osascript -e 'tell app "System Events" to restart'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                sleep 5 && shutdown -r now &
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                # shutdown -r +1 &
>>>>>>> 0bc3777 (oops I had removed it)
=======
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                # shutdown -r +1 &
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "System Events" to restart' &
                sleep 5 && shutdown -r now &
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Restart Confirm" )
                updateScriptLog "Restart, only after macOS time-out or user confirmation"
                runAsUser osascript -e 'tell app "loginwindow" to «event aevtrrst»'
            ;;
            
            "Log Out" )
                updateScriptLog "Log out sans user interaction"
                killProcess "Self Service"
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                sleep 5 && launchctl bootout user/"${loggedInUserID}"
=======
                # runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                # launchctl bootout user/"${loggedInUserID}"
>>>>>>> 0bc3777 (oops I had removed it)
=======
                # runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                # launchctl bootout user/"${loggedInUserID}"
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                sleep 5 && launchctl bootout user/"${loggedInUserID}"
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Log Out Attended" )
                updateScriptLog "Log out sans user interaction"
                killProcess "Self Service"
                wait
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                sleep 5 && launchctl bootout user/"${loggedInUserID}"
=======
                # runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                # launchctl bootout user/"${loggedInUserID}"
>>>>>>> 0bc3777 (oops I had removed it)
=======
                # runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                # launchctl bootout user/"${loggedInUserID}"
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

            "Log Out Confirm" )
                updateScriptLog "Log out, only after macOS time-out or user confirmation"
<<<<<<< HEAD
<<<<<<< HEAD
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to log out'
=======
                runAsUser osascript -e 'tell app "System Events" to log out'
>>>>>>> 0bc3777 (oops I had removed it)
=======
                runAsUser osascript -e 'tell app "System Events" to log out'
>>>>>>> 6a67ebc (bad merge, reverting)
                ;;

=======
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»'
                # sleep 5 && runAsUser osascript -e 'tell app "loginwindow" to «event aevtrlgo»' &
                sleep 5 && launchctl bootout user/"${loggedInUserID}"
            ;;
            
            "Log Out Confirm" )
                updateScriptLog "Log out, only after macOS time-out or user confirmation"
                sleep 5 && runAsUser osascript -e 'tell app "System Events" to log out'
            ;;
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            "Sleep"* )
                sleepDuration=$( awk '{print $NF}' <<< "${1}" )
                updateScriptLog "Sleeping for ${sleepDuration} seconds …"
                sleep "${sleepDuration}"
                killProcess "Dialog"
                updateScriptLog "Goodnight!"
            ;;
            
            "Quit" )
                updateScriptLog "Quitting script"
                exitCode="0"
            ;;
            
            * )
                updateScriptLog "Using the default of 'wait'"
                wait
            ;;
            
        esac
        
        shopt -u nocasematch
        
    fi
    
    exit "${exitCode}"
    
}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Quit Script (thanks, @bartreadon!)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function quitScript() {
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    updateScriptLog "QUIT SCRIPT: Exiting …"
=======
    updateScriptLog "Exiting …"
>>>>>>> 6a67ebc (bad merge, reverting)

    # Stop `caffeinate` process
    updateScriptLog "QUIT SCRIPT: De-caffeinate …"
    killProcess "caffeinate"

<<<<<<< HEAD
    # Reenable 'jamf' binary check-in
    # Purposely commented-out on 2023-01-26-092705; presumes Mac will be rebooted
    # updateScriptLog "QUIT SCRIPT: Reenable 'jamf' binary check-in"
    # launchctl bootstrap system "${jamflaunchDaemon}"

=======
>>>>>>> 6a67ebc (bad merge, reverting)
    # Remove welcomeCommandFile
    if [[ -e ${welcomeCommandFile} ]]; then
        updateScriptLog "QUIT SCRIPT: Removing ${welcomeCommandFile} …"
=======
=======
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    updateScriptLog "Exiting …"
    
    # Stop `caffeinate` process
    updateScriptLog "De-caffeinate …"
    killProcess "caffeinate"
    
    # Reenable 'jamf' binary check-in
    # Purposely commented-out on 2023-01-26-092705; presumes Mac will be rebooted
    # updateScriptLog "Reenable 'jamf' binary check-in"
    # launchctl bootstrap system "${jamflaunchDaemon}"
    
    # Remove welcomeCommandFile
    if [[ -e ${welcomeCommandFile} ]]; then
        updateScriptLog "Removing ${welcomeCommandFile} …"
>>>>>>> 0bc3777 (oops I had removed it)
        rm "${welcomeCommandFile}"
    fi
    
    # Remove setupYourMacCommandFile
    if [[ -e ${setupYourMacCommandFile} ]]; then
<<<<<<< HEAD
        updateScriptLog "QUIT SCRIPT: Removing ${setupYourMacCommandFile} …"
=======
        updateScriptLog "Removing ${setupYourMacCommandFile} …"
>>>>>>> 0bc3777 (oops I had removed it)
        rm "${setupYourMacCommandFile}"
    fi
    
    # Remove failureCommandFile
    if [[ -e ${failureCommandFile} ]]; then
<<<<<<< HEAD
        updateScriptLog "QUIT SCRIPT: Removing ${failureCommandFile} …"
=======
        updateScriptLog "Removing ${failureCommandFile} …"
>>>>>>> 0bc3777 (oops I had removed it)
        rm "${failureCommandFile}"
    fi
    
    # Remove any default dialog file
    if [[ -e /var/tmp/dialog.log ]]; then
<<<<<<< HEAD
        updateScriptLog "QUIT SCRIPT: Removing default dialog file …"
=======
        updateScriptLog "Removing default dialog file …"
>>>>>>> 0bc3777 (oops I had removed it)
        rm /var/tmp/dialog.log
    fi
    
    # Check for user clicking "Quit" at Welcome dialog
    if [[ "${welcomeReturnCode}" == "2" ]]; then
        exitCode="1"
        exit "${exitCode}"
    else
<<<<<<< HEAD
        updateScriptLog "QUIT SCRIPT: Executing Completion Action Option: '${completionActionOption}' …"
=======
        updateScriptLog "Executing Completion Action Option: '${completionActionOption}' …"
>>>>>>> 0bc3777 (oops I had removed it)
        completionAction "${completionActionOption}"
    fi
    
}



####################################################################################################
#
# Program
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Debug Mode Logging Notification
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
    updateScriptLog "\n\n###\n# ${scriptVersion}\n###\n"
=======
# Client-side Logging
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ ! -f "${scriptLog}" ]]; then
    touch "${scriptLog}"
    updateScriptLog "*** Created log file via script ***"
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Debug Mode Logging Notification
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
    updateScriptLog "\n\n###\n# ${scriptVersion}\n###\n"
<<<<<<< HEAD
else
    updateScriptLog "\n\n###\n# Setup Your Mac (${scriptVersion})\n###\n"
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# If Debug Mode is enabled, replace `blurscreen` with `movable`
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
=======
# Validate swiftDialog is installed
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

dialogCheck



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# If Debug Mode is enabled, replace `blurscreen` with `movable`
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
if [[ "${debugMode}" == "true" ]]; then
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    welcomeJSON=${welcomeJSON//blurscreen/moveable}
    dialogSetupYourMacCMD=${dialogSetupYourMacCMD//blurscreen/moveable}
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Display Welcome dialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${welcomeDialog}" == "video" ]]; then

    updateScriptLog "WELCOME DIALOG: Displaying "
    eval "${dialogBinary} --args ${welcomeVideo}"

    policyJSONConfiguration

    eval "${dialogSetupYourMacCMD[*]}" & sleep 0.3
    dialogSetupYourMacProcessID=$!
    until pgrep -q -x "Dialog"; do
        # Output Line Number in `verbose` Debug Mode
        if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
        updateScriptLog "WELCOME DIALOG: Waiting to display 'Setup Your Mac' dialog; pausing"
        sleep 0.5
    done
    updateScriptLog "WELCOME DIALOG: 'Setup Your Mac' dialog displayed; ensure it's the front-most app"
    runAsUser osascript -e 'tell application "Dialog" to activate'

elif [[ "${welcomeDialog}" == "userInput" ]]; then

    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    # Write Welcome JSON to disk
    echo "$welcomeJSON" > "$welcomeCommandFile"

    welcomeResults=$( eval "${dialogApp} --jsonfile ${welcomeCommandFile} --json" )

=======
# Write Welcome JSON to disk
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo "$welcomeJSON" > "$welcomeCommandFile"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Display Welcome dialog and capture user's input
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [[ "${welcomeDialog}" == "true" ]]; then
<<<<<<< HEAD

    welcomeResults=$( ${dialogApp} --jsonfile "$welcomeCommandFile" --json )
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    welcomeResults=$( eval "${dialogApp} --jsonfile ${welcomeCommandFile} --json" )
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    if [[ -z "${welcomeResults}" ]]; then
        welcomeReturnCode="2"
    else
        welcomeReturnCode="0"
    fi
    
    case "${welcomeReturnCode}" in
        
        0)  # Process exit code 0 scenario here
            updateScriptLog "WELCOME DIALOG: ${loggedInUser} entered information and clicked Continue"
            
            ###
            # Extract the various values from the welcomeResults JSON
            ###
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
            computerName=$(get_json_value_welcomeDialog "$welcomeResults" "Computer Name")
            userName=$(get_json_value_welcomeDialog "$welcomeResults" "User Name")
            assetTag=$(get_json_value_welcomeDialog "$welcomeResults" "Asset Tag")
            symConfiguration=$(get_json_value_welcomeDialog "$welcomeResults" "Configuration" "selectedValue")
            department=$(get_json_value_welcomeDialog "$welcomeResults" "Department" "selectedValue")
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            comment=$(get_json_value_welcomeDialog "$welcomeResults" "Comment")
            computerName=$(get_json_value_welcomeDialog "$welcomeResults" "Computer Name")
            userName=$(get_json_value_welcomeDialog "$welcomeResults" "User Name")
            assetTag=$(get_json_value_welcomeDialog "$welcomeResults" "Asset Tag")
            department=$(get_json_value_welcomeDialog "$welcomeResults" "Department" "selectedValue")
            selectB=$(get_json_value_welcomeDialog "$welcomeResults" "Select B" "selectedValue")
            selectC=$(get_json_value_welcomeDialog "$welcomeResults" "Select C" "selectedValue")
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)



            ###
            # Output the various values from the welcomeResults JSON to the log file
            ###

<<<<<<< HEAD
<<<<<<< HEAD
            updateScriptLog "WELCOME DIALOG: • Computer Name: $computerName"
            updateScriptLog "WELCOME DIALOG: • User Name: $userName"
            updateScriptLog "WELCOME DIALOG: • Asset Tag: $assetTag"
            updateScriptLog "WELCOME DIALOG: • Configuration: $symConfiguration"
            updateScriptLog "WELCOME DIALOG: • Department: $department"



            ###
            # Select `policyJSON` based on selected Configuration
            ###

            policyJSONConfiguration
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
            
            
            
            ###
            # Output the various values from the welcomeResults JSON to the log file
            ###
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            updateScriptLog "WELCOME DIALOG: • Comment: $comment"
            updateScriptLog "WELCOME DIALOG: • Computer Name: $computerName"
            updateScriptLog "WELCOME DIALOG: • User Name: $userName"
            updateScriptLog "WELCOME DIALOG: • Asset Tag: $assetTag"
            updateScriptLog "WELCOME DIALOG: • Department: $department"
            updateScriptLog "WELCOME DIALOG: • Select B: $selectB"
            updateScriptLog "WELCOME DIALOG: • Select C: $selectC"
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)



=======
            
            
            
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
            ###
            # Evaluate Various User Input
            ###
            
            # Computer Name
            if [[ -n "${computerName}" ]]; then
                
                # UNTESTED, UNSUPPORTED "YOYO" EXAMPLE
                updateScriptLog "WELCOME DIALOG: Set Computer Name …"
                currentComputerName=$( scutil --get ComputerName )
                currentLocalHostName=$( scutil --get LocalHostName )
                
                # Sets LocalHostName to a maximum of 15 characters, comprised of first eight characters of the computer's
                # serial number and the last six characters of the client's MAC address
                firstEightSerialNumber=$( system_profiler SPHardwareDataType | awk '/Serial\ Number\ \(system\)/ {print $NF}' | cut -c 1-8 )
                lastSixMAC=$( ifconfig en0 | awk '/ether/ {print $2}' | sed 's/://g' | cut -c 7-12 )
                newLocalHostName=${firstEightSerialNumber}-${lastSixMAC}
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
                if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then

                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Would have renamed computer from: \"${currentComputerName}\" to \"${computerName}\" "
                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Would have renamed LocalHostName from: \"${currentLocalHostName}\" to \"${newLocalHostName}\" "
=======
=======
>>>>>>> 6a67ebc (bad merge, reverting)
                if [[ "${debugMode}" == "true" ]]; then

                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Renamed computer from: \"${currentComputerName}\" to \"${computerName}\" "
                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Renamed LocalHostName from: \"${currentLocalHostName}\" to \"${newLocalHostName}\" "
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)

=======
                
                if [[ "${debugMode}" == "true" ]] || [[ "${debugMode}" == "verbose" ]] ; then
                    
                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Would have renamed computer from: \"${currentComputerName}\" to \"${computerName}\" "
                    updateScriptLog "WELCOME DIALOG: DEBUG MODE: Would have renamed LocalHostName from: \"${currentLocalHostName}\" to \"${newLocalHostName}\" "
                    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
                else
                    
                    # Set the Computer Name to the user-entered value
                    scutil --set ComputerName "${computerName}"
                    
                    # Set the LocalHostName to `newLocalHostName`
                    scutil --set LocalHostName "${newLocalHostName}"
                    
                    # Delay required to reflect change …
                    # … side-effect is a delay in the "Setup Your Mac" dialog appearing
                    sleep 5
                    updateScriptLog "WELCOME DIALOG: Renamed computer from: \"${currentComputerName}\" to \"$( scutil --get ComputerName )\" "
                    updateScriptLog "WELCOME DIALOG: Renamed LocalHostName from: \"${currentLocalHostName}\" to \"$( scutil --get LocalHostName )\" "
                    
                fi
                
            else
                
                updateScriptLog "WELCOME DIALOG: ${loggedInUser} did NOT specify a new computer name"
                updateScriptLog "WELCOME DIALOG: • Current Computer Name: \"$( scutil --get ComputerName )\" "
                updateScriptLog "WELCOME DIALOG: • Current Local Host Name: \"$( scutil --get LocalHostName )\" "
                
            fi
            
            # User Name
            if [[ -n "${userName}" ]]; then
                # UNTESTED, UNSUPPORTED "YOYO" EXAMPLE
                reconOptions+="-endUsername \"${userName}\" "
            fi
            
            # Asset Tag
            if [[ -n "${assetTag}" ]]; then
                reconOptions+="-assetTag \"${assetTag}\" "
            fi
            
            # Department
            if [[ -n "${department}" ]]; then
                # UNTESTED, UNSUPPORTED "YOYO" EXAMPLE
                reconOptions+="-department \"${department}\" "
            fi
            
            # Output `recon` options to log
            updateScriptLog "WELCOME DIALOG: reconOptions: ${reconOptions}"
            
            ###
            # Display "Setup Your Mac" dialog (and capture Process ID)
            ###
            
            eval "${dialogSetupYourMacCMD[*]}" & sleep 0.3
            dialogSetupYourMacProcessID=$!
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
            until pgrep -q -x "Dialog"; do
                # Output Line Number in `verbose` Debug Mode
                if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
                updateScriptLog "WELCOME DIALOG: Waiting to display 'Setup Your Mac' dialog; pausing"
                sleep 0.5
            done
            updateScriptLog "WELCOME DIALOG: 'Setup Your Mac' dialog displayed; ensure it's the front-most app"
            runAsUser osascript -e 'tell application "Dialog" to activate'
=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
            ;;

=======
        ;;
        
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
        2)  # Process exit code 2 scenario here
            updateScriptLog "WELCOME DIALOG: ${loggedInUser} clicked Quit at Welcome dialog"
            completionActionOption="Quit"
            quitScript "1"
        ;;
        
        3)  # Process exit code 3 scenario here
            updateScriptLog "WELCOME DIALOG: ${loggedInUser} clicked infobutton"
            osascript -e "set Volume 3"
            afplay /System/Library/Sounds/Glass.aiff
        ;;
        
        4)  # Process exit code 4 scenario here
            updateScriptLog "WELCOME DIALOG: ${loggedInUser} allowed timer to expire"
            quitScript "1"
        ;;
        
        *)  # Catch all processing
            updateScriptLog "WELCOME DIALOG: Something else happened; Exit code: ${welcomeReturnCode}"
            quitScript "1"
        ;;
        
    esac
    
else
<<<<<<< HEAD
<<<<<<< HEAD

=======
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
    ###
<<<<<<< HEAD
    # Select `policyJSON` based on selected Configuration
    ###

    policyJSONConfiguration


=======
>>>>>>> 6a67ebc (bad merge, reverting)

    ###
=======
>>>>>>> 0bc3777 (oops I had removed it)
    # Display "Setup Your Mac" dialog (and capture Process ID)
    ###
    
    eval "${dialogSetupYourMacCMD[*]}" & sleep 0.3
    dialogSetupYourMacProcessID=$!
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    until pgrep -q -x "Dialog"; do
        # Output Line Number in `verbose` Debug Mode
        if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
        updateScriptLog "WELCOME DIALOG: Waiting to display 'Setup Your Mac' dialog; pausing"
        sleep 0.5
    done
    updateScriptLog "WELCOME DIALOG: 'Setup Your Mac' dialog displayed; ensure it's the front-most app"
    runAsUser osascript -e 'tell application "Dialog" to activate'
=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)

=======
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
fi



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
# Iterate through policyJSON to construct the list for swiftDialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

dialog_step_length=$(get_json_value "${policyJSON}" "steps.length")
for (( i=0; i<dialog_step_length; i++ )); do
    listitem=$(get_json_value "${policyJSON}" "steps[$i].listitem")
    list_item_array+=("$listitem")
    icon=$(get_json_value "${policyJSON}" "steps[$i].icon")
=======
# Iterate through policy_array JSON to construct the list for swiftDialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
dialog_step_length=$(get_json_value "${policy_array[*]}" "steps.length")
for (( i=0; i<dialog_step_length; i++ )); do
    listitem=$(get_json_value "${policy_array[*]}" "steps[$i].listitem")
    list_item_array+=("$listitem")
    icon=$(get_json_value "${policy_array[*]}" "steps[$i].icon")
>>>>>>> 0bc3777 (oops I had removed it)
    icon_url_array+=("$icon")
done



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Determine the "progress: increment" value based on the number of steps in policyJSON
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

totalProgressSteps=$(get_json_value "${policyJSON}" "steps.length")
progressIncrementValue=$(( 100 / totalProgressSteps ))
updateScriptLog "SETUP YOUR MAC DIALOG: Total Number of Steps: ${totalProgressSteps}"
updateScriptLog "SETUP YOUR MAC DIALOG: Progress Increment Value: ${progressIncrementValue}"
=======
# Set progress_total to the number of steps in policy_array
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

progress_total=$(get_json_value "${policy_array[*]}" "steps.length")
updateScriptLog "SETUP YOUR MAC DIALOG: progress_total=$progress_total"
>>>>>>> 0bc3777 (oops I had removed it)
=======
# Set progress_total to the number of steps in policy_array
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

progress_total=$(get_json_value "${policy_array[*]}" "steps.length")
updateScriptLog "SETUP YOUR MAC DIALOG: progress_total=$progress_total"
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Determine the "progress: increment" value based on the number of steps in policy_array
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

totalProgressSteps=$(get_json_value "${policy_array[*]}" "steps.length")
progressIncrementValue=$(( 100 / totalProgressSteps ))
updateScriptLog "SETUP YOUR MAC DIALOG: Total Number of Steps: ${totalProgressSteps}"
updateScriptLog "SETUP YOUR MAC DIALOG: Progress Increment Value: ${progressIncrementValue}"
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# The ${array_name[*]/%/,} expansion will combine all items within the array adding a "," character at the end
# To add a character to the start, use "/#/" instead of the "/%/"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
list_item_string=${list_item_array[*]/%/,}
dialogUpdateSetupYourMac "list: ${list_item_string%?}"
for (( i=0; i<dialog_step_length; i++ )); do
    dialogUpdateSetupYourMac "listitem: index: $i, icon: ${setupYourMacPolicyArrayIconPrefixUrl}${icon_url_array[$i]}, status: pending, statustext: Pending …"
done
dialogUpdateSetupYourMac "list: show"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Set initial progress bar
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

updateScriptLog "SETUP YOUR MAC DIALOG: Initial progress bar"
dialogUpdateSetupYourMac "progress: 1"
<<<<<<< HEAD
=======
progress_index=0
dialogUpdateSetupYourMac "progress: $progress_index"
>>>>>>> 0bc3777 (oops I had removed it)
=======
progress_index=0
dialogUpdateSetupYourMac "progress: $progress_index"
>>>>>>> 6a67ebc (bad merge, reverting)
=======
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Close Welcome dialog
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

=======
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
dialogUpdateWelcome "quit:"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Update Setup Your Mac's infobox
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

infobox=""

if [[ -n ${comment} ]]; then infobox+="**Comment:**  \n$comment  \n\n" ; fi
if [[ -n ${computerName} ]]; then infobox+="**Computer Name:**  \n$computerName  \n\n" ; fi
if [[ -n ${userName} ]]; then infobox+="**Username:**  \n$userName  \n\n" ; fi
if [[ -n ${assetTag} ]]; then infobox+="**Asset Tag:**  \n$assetTag  \n\n" ; fi
if [[ -n ${symConfiguration} ]]; then infobox+="**Configuration:**  \n$symConfiguration  \n\n" ; fi
if [[ -n ${department} ]]; then infobox+="**Department:**  \n$department  \n\n" ; fi

dialogUpdateSetupYourMac "infobox: ${infobox}"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This for loop will iterate over each distinct step in the policyJSON
=======
# This for loop will iterate over each distinct step in the policy_array array
>>>>>>> 6a67ebc (bad merge, reverting)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

for (( i=0; i<dialog_step_length; i++ )); do 

<<<<<<< HEAD
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

    # Initialize SECONDS
    SECONDS="0"

    # Creating initial variables
    listitem=$(get_json_value "${policyJSON}" "steps[$i].listitem")
    icon=$(get_json_value "${policyJSON}" "steps[$i].icon")
    progresstext=$(get_json_value "${policyJSON}" "steps[$i].progresstext")
    trigger_list_length=$(get_json_value "${policyJSON}" "steps[$i].trigger_list.length")

    # If there's a value in the variable, update running swiftDialog
    if [[ -n "$listitem" ]]; then
        updateScriptLog "\n\n# # #\n# SETUP YOUR MAC DIALOG: policyJSON > listitem: ${listitem}\n# # #\n"
        dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Installing …, "
    fi
    if [[ -n "$icon" ]]; then dialogUpdateSetupYourMac "icon: ${setupYourMacPolicyArrayIconPrefixUrl}${icon}"; fi
    if [[ -n "$progresstext" ]]; then dialogUpdateSetupYourMac "progresstext: $progresstext"; fi
    if [[ -n "$trigger_list_length" ]]; then

        for (( j=0; j<trigger_list_length; j++ )); do

            # Setting variables within the trigger_list
            trigger=$(get_json_value "${policyJSON}" "steps[$i].trigger_list[$j].trigger")
            validation=$(get_json_value "${policyJSON}" "steps[$i].trigger_list[$j].validation")
            case ${validation} in
                "Local" | "Remote" )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Skipping Policy Execution due to '${validation}' validation"
                    ;;
                * )
                    confirmPolicyExecution "${trigger}" "${validation}"
                    ;;
            esac

        done

    fi

    validatePolicyResult "${trigger}" "${validation}"

    # Increment the progress bar
    dialogUpdateSetupYourMac "progress: increment ${progressIncrementValue}"

    # Record duration
    updateScriptLog "SETUP YOUR MAC DIALOG: Elapsed Time: $(printf '%dh:%dm:%ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))"
=======
# This for loop will iterate over each distinct step in the policy_array array
=======
# Update Setup Your Mac's infobox
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

<<<<<<< HEAD
=======
>>>>>>> 6a67ebc (bad merge, reverting)
    # Increment the progress bar
    dialogUpdateSetupYourMac "progress: $(( i * ( 100 / progress_total ) ))"
=======
infobox=""

if [[ -n ${comment} ]]; then infobox+="**Comment:**  \n$comment  \n\n" ; fi
if [[ -n ${computerName} ]]; then infobox+="**Computer Name:**  \n$computerName  \n\n" ; fi
if [[ -n ${userName} ]]; then infobox+="**Username:**  \n$userName  \n\n" ; fi
if [[ -n ${assetTag} ]]; then infobox+="**Asset Tag:**  \n$assetTag  \n\n" ; fi
if [[ -n ${department} ]]; then infobox+="**Department:**  \n$department  \n\n" ; fi
if [[ -n ${selectB} ]]; then infobox+="**Select B:**  \n$selectB  \n\n" ; fi
if [[ -n ${selectC} ]]; then infobox+="**Select C:**  \n$selectC  \n\n" ; fi

dialogUpdateSetupYourMac "infobox: ${infobox}"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This for loop will iterate over each distinct step in the policy_array array
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)

for (( i=0; i<dialog_step_length; i++ )); do 
    
    # Output Line Number in `verbose` Debug Mode
    if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi
    
    # Initialize SECONDS
    SECONDS="0"
    
    # Creating initial variables
    listitem=$(get_json_value "${policy_array[*]}" "steps[$i].listitem")
    icon=$(get_json_value "${policy_array[*]}" "steps[$i].icon")
    progresstext=$(get_json_value "${policy_array[*]}" "steps[$i].progresstext")
    trigger_list_length=$(get_json_value "${policy_array[*]}" "steps[$i].trigger_list.length")
    
    # If there's a value in the variable, update running swiftDialog
    if [[ -n "$listitem" ]]; then
        updateScriptLog "\n\n# # #\n# SETUP YOUR MAC DIALOG: policy_array > listitem: ${listitem}\n# # #\n"
        dialogUpdateSetupYourMac "listitem: index: $i, status: wait, statustext: Installing …, "
    fi
    if [[ -n "$icon" ]]; then dialogUpdateSetupYourMac "icon: ${setupYourMacPolicyArrayIconPrefixUrl}${icon}"; fi
    if [[ -n "$progresstext" ]]; then dialogUpdateSetupYourMac "progresstext: $progresstext"; fi
    if [[ -n "$trigger_list_length" ]]; then
        
        for (( j=0; j<trigger_list_length; j++ )); do
            
            # Setting variables within the trigger_list
            trigger=$(get_json_value "${policy_array[*]}" "steps[$i].trigger_list[$j].trigger")
            validation=$(get_json_value "${policy_array[*]}" "steps[$i].trigger_list[$j].validation")
            case ${validation} in
                "Local" | "Remote" )
                    updateScriptLog "SETUP YOUR MAC DIALOG: Skipping Policy Execution due to '${validation}' validation"
                ;;
                * )
                    confirmPolicyExecution "${trigger}" "${validation}"
                ;;
            esac
            
        done
        
    fi
<<<<<<< HEAD

    # Validate the expected path exists
    updateScriptLog "SETUP YOUR MAC DIALOG: Testing for \"$path\" …"
    if [[ -f "$path" ]] || [[ -z "$path" ]]; then
        dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Installed"
        if [[ "$trigger" == "recon" ]]; then
            dialogUpdateSetupYourMac "listitem: index: $i, status: success, statustext: Updated"
        fi
    else
        dialogUpdateSetupYourMac "listitem: index: $i, status: fail, statustext: Failed"
        jamfProPolicyTriggerFailure="failed"
        exitCode="1"
        jamfProPolicyPolicyNameFailures+="• $listitem  \n"
    fi
<<<<<<< HEAD
>>>>>>> 0bc3777 (oops I had removed it)
=======
>>>>>>> 6a67ebc (bad merge, reverting)

=======
    
    validatePolicyResult "${trigger}" "${validation}"
    
    # Increment the progress bar
    dialogUpdateSetupYourMac "progress: increment ${progressIncrementValue}"
    
    # Record duration
    updateScriptLog "SETUP YOUR MAC DIALOG: Elapsed Time: $(printf '%dh:%dm:%ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))"
    
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
done



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Complete processing and enable the "Done" button
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

finalise
=======
finalise
>>>>>>> 0bc3777 (oops I had removed it)
=======
finalise
>>>>>>> 6a67ebc (bad merge, reverting)
=======
# Output Line Number in `verbose` Debug Mode
if [[ "${debugMode}" == "verbose" ]]; then updateScriptLog "# # # SETUP YOUR MAC VERBOSE DEBUG MODE: Line No. ${LINENO} # # #" ; fi

finalise
>>>>>>> 55fa7da (updated to v1.7 including is it running checks)
