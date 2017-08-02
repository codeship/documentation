echo "Appranix: Logging in."
ssh ${USER}@app.appranix.net << (echo "${PASSWORD}\n")
sleep 2

echo "Appranix: Creating appranix.json"
cat <<EOF > ---
platforms:
  ${PLATFORM}:
      artifact/core.1.Artifact:
        ${ARTIFACT}:
          install_dir: /opt/tomcat7/webapps
          version: ${CI_BUILD_NUMBER},
      user/core.1.User:
        user: {}
EOF
echo "Appranix: Design is Loaded"
sleep 5

/inductor/appranix/client commit -m "auto commit"
echo "Appranix: Design is commited with message 'auto commit'"
sleep 5

/inductor/appranix/client/deploy -m "auto deploy"
echo "Appranix: Deploying Build #${CI_BUILD_NUMBER}"
sleep 6


echo "Appranix: Deployment completed successfully"
sleep 2

logout
exit
