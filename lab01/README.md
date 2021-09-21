## Creamos el Service Principal en Azure.
    az ad sp create-for-rbac --name iac_service_principal

## Obtenemos el subscriptionId.
    az account subscription list

## Configuración de las Env.
    export ARM_CLIENT_ID="398220d0-eb22-4306-996e-bc4e90750ad4",
    export ARM_CLIENT_SECRET="d9_sXqYGZgSjZkYRgkZYFWP_75x_46aVA6",
    export ARM_SUBSCRIPTION_ID="4b2bf5e6-045c-4cb0-92b5-8ad053047ba6",
    export ARM_TENANT_ID="f1386254-966b-4c20-afd1-b28c9242c712"

## Listamos las locaciones. 
    az account list-locations --query '[].name'
