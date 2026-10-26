package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func stagingOptions(t *testing.T) *terraform.Options {
	return terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../staging",
		Vars: map[string]interface{}{
			"db_password": "terratestpassword123",
		},
	})
}

func TestStagingPlanIsValid(t *testing.T) {
	options := stagingOptions(t)

	terraform.Init(t, options)
	terraform.Validate(t, options)
	terraform.Plan(t, options)
}

func TestStagingInfrastructure(t *testing.T) {
	options := stagingOptions(t)

	defer terraform.Destroy(t, options)
	terraform.InitAndApply(t, options)

	vpcId := terraform.Output(t, options, "vpc_id")
	assert.NotEmpty(t, vpcId)

	serverIds := terraform.OutputList(t, options, "server_ids")
	assert.Equal(t, 2, len(serverIds))

	databaseEndpoint := terraform.Output(t, options, "database_endpoint")
	assert.Contains(t, databaseEndpoint, "rds.amazonaws.com")

	loadBalancerUrl := fmt.Sprintf("http://%s", terraform.Output(t, options, "lb_dns_name"))
	http_helper.HttpGetWithRetryWithCustomValidation(t, loadBalancerUrl, nil, 30, 10*time.Second, func(statusCode int, body string) bool {
		return statusCode == 200 && strings.Contains(body, "Hello from staging")
	})
}
