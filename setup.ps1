param
(
     [Parameter()]
     [string]$destroy="NO",
 
     [Parameter()]
     [string]$functions=$null,
     
     [Parameter()]
     [string]$force="FALSE"
 )

$functionArray = $functions.Split(",")

echo "Destroy		: $destroy"
echo "Functions List: $functions"

echo "Install Serverless v 3.19.0"
choco install serverless --version=3.19.0 -y --no-progress

#install serverless plugins
echo "Installing serverless plugins"
npm install serverless-domain-manager --save-dev --forcedependencies
npm install serverless-plugin-conditional-functions --save-dev --forcedependencies
npm install serverless-plugin-ifelse --save-dev --forcedependencies
npm install serverless-plugin-log-retention --save-dev --forcedependencies
npm install serverless-plugin-utils --save-dev --forcedependencies

if ($destroy.ToUpper() -eq "YES"){
	echo "Destroying serverless all components"
	serverless remove
}
else{
    if ([String]::IsNullOrEmpty($functions)){		
        if($force.ToUpper() -eq "TRUE"){
          echo "Deploying all functions forcebily using serverless framework"
          serverless deploy --force
        }
        else{
          echo "Deploying all functions using serverless framework"
          serverless deploy
        }
    }
    else {
      foreach($function in $functionArray) {        
        if($force.ToUpper() -eq "TRUE"){
          echo "Deploying specific functions forecebily using serverless framework"
          serverless deploy function --function $function --force
        }
        else{
          echo "Deploying specific functions using serverless framework"
          serverless deploy function --function $function
        }
      }
    }   
}