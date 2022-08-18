AZURE_CONFIG_FILE ?= "./src/azureconfig.json"

build:
	@echo "=> Building templates..."
	@bicep build ./src/main.bicep --stdout

deploy:
	@echo "=> Deploying platform..."
	@az account set --subscription "$(AZURE_SUBSCRIPTION_ID)"
	@echo "==> Loading configuration file - ${AZURE_CONFIG_FILE}..."
	@az deployment sub create --name "Microsoft.Deployment" --location "uksouth" --template-file "./src/main.bicep" --parameters config=@"$(AZURE_CONFIG_FILE)"

validate:
	@echo "=> Validating platform..."
	@az account set --subscription "$(AZURE_SUBSCRIPTION_ID)"
	@echo "==> Loading configuration file - $(AZURE_CONFIG_FILE)..."
	@az deployment sub what-if --name "Microsoft.Deployment" --location "uksouth" --template-file "./src/main.bicep" --parameters config=@"$(AZURE_CONFIG_FILE)"

delete:
	@echo "=> Deleting platform..."
	@az group list --output json | jq -r '.[].name' | xargs -rtL1 az group delete --yes --no-wait --name