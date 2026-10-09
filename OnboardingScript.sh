# Add the service principal application ID and secret here
ServicePrincipalId="30eb9c75-7ab8-4778-8534-def424380ae4";
ServicePrincipalClientSecret="JW68Q~gvLRumJtCYgBWv08eyBRfi88POBj.J5dcT";


export subscriptionId="87365253-b426-4b96-a766-16c2b8a046dd";
export resourceGroup="Sentinel-Practice";
export tenantId="6bd180e5-0af3-4af3-9ce4-c7faed6b04cb";
export location="eastus";
export authType="principal";
export correlationId="420c171e-4efd-4409-a2b6-ac77d9708fe7";
export cloud="AzureCloud";


# Download the installation package
LINUX_INSTALL_SCRIPT="/tmp/install_linux_azcmagent.sh"
if [ -f "$LINUX_INSTALL_SCRIPT" ]; then rm -f "$LINUX_INSTALL_SCRIPT"; fi;
output=$(wget https://gbl.his.arc.azure.com/azcmagent-linux -O "$LINUX_INSTALL_SCRIPT" 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"operation\":\"onboarding\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";

# Install the hybrid agent
bash "$LINUX_INSTALL_SCRIPT";
sleep 5;

# Run connect command
sudo azcmagent connect --service-principal-id "$ServicePrincipalId" --service-principal-secret "$ServicePrincipalClientSecret" --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --enable-automatic-upgrade --correlation-id "$correlationId";
