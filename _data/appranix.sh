echo "Installing Appranix CLI"
gem install prana

echo "Setting Appranix URL"
prana config set site=http://app.appranix.net/web -g

echo "Logging into Appranix"
prana auth login --username=${USER} --password=${PASSWORD} --account=${ORG}

echo "Setting Organization as ${SUBORG}"
prana config set organization=${SUBORG}

echo "Setting Assembly as ${ASSEMBLY}"
prana config set assembly=${ASSEMBLY} -g

echo "Updating latest build number"
prana design variable update -a ${ASSEMBLY} --platform=${PLATFORM} appVersion=${CI_BUILD_NUMBER}

echo "Commiting design"
prana design commit design-commit

echo "Pulling design to ${AppSpace} AppSpace"
prana configure pull -e ${AppSpace}

echo "Commiting AppSpace changes"
prana configure commit appspace-commit -e ${AppSpace}

echo "Starting AppSpace deployment"
prana transition deployment create -e ${AppSpace}
