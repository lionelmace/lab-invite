#!/bin/bash
echo "
{
  \"name\": \"$WORKSPACE_NAME\",
  \"shared_data\": {
    \"region\": \"$REGION\"
  },
  \"type\": [
    \"terraform_v1.5\"
  ],
  \"template_repo\": {
    \"url\": \"$GITHUB_URL\"
  },
  \"template_data\": [
    {
      \"folder\": \"terraform\",
      \"type\": \"terraform_v1.5\",
      \"env_values\": [
        {
          \"__netrc__\":\"[['github.ibm.com','token','$GITHUB_TOKEN']]\"
        }
      ]
    }
  ]
}
" > DO-NOT-COMMIT-create-workspace.json

ibmcloud login --apikey $IBMCLOUD_API_KEY
ibmcloud target -g $RESOURCE_GROUP
ibmcloud schematics workspace new --file DO-NOT-COMMIT-create-workspace.json --github-token $GITHUB_TOKEN

rm -rf DO-NOT-COMMIT-create-workspace.json
