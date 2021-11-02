terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 2.26" 
        }
    }
}

provider "azurerm" {
    features {      
    }
}


resource "azurerm_logic_app_workflow" "example" {
  name                = "testarmtemplate"
  location            = "eastus2"
  resource_group_name = "practice_rg"
  parameters = {
    "connections_azureeventgrid_externalid" = "/subscriptions/9ba3bb49-d69e-4f57-a11f-bf0a022fbd21/resourceGroups/practice_rg/providers/Microsoft.Web/connections/azureeventgrid"
  }
  
  lifecycle {
    ignore_changes = [
      parameters,
      tags,
      workflow_parameters
    ]
  }
}

resource "azurerm_template_deployment" "deploy_logicapp" {
    name = "testarmtemplate"
    resource_group_name = "practice_rg"
    deployment_mode = "Incremental"
    template_body = file("testarmtemplate.json")
    depends_on = [
      azurerm_logic_app_workflow.example
    ]
    parameters = {
        connections_azureeventgrid_externalid = "/subscriptions/9ba3bb49-d69e-4f57-a11f-bf0a022fbd21/resourceGroups/practice_rg/providers/Microsoft.Web/connections/azureeventgrid"
    }

    lifecycle {
        ignore_changes = [
        template_body

        ]
    }

provisioner "local-exec" {
    command = <<EOT
     az deployment group list
    --resource-group practice_rg
    EOT
}
} 

