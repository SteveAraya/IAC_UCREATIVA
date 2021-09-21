## Creamos el Service Principal en Azure.
    az ad sp create-for-rbac --name iac_service_principal

## Obtenemos el subscriptionId.
    az account subscription list

## Configuración de las Env.
    export ARM_CLIENT_ID="",
    export ARM_CLIENT_SECRET="",
    export ARM_SUBSCRIPTION_ID="",
    export ARM_TENANT_ID=""

## Listamos las locaciones. 
    az account list-locations --query '[].name'
