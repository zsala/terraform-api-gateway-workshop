#
# Add more functionality
#

provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_api_gateway_rest_api" "api" {
    name = "proxy-gateway"
    description = "Proxy to handle requests from an external service to a backend service protected by a simple api key"
}

resource "aws_api_gateway_resource" "product_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "products"
}

resource "aws_api_gateway_method" "product_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "product_post_method_integration" {
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  resource_id                 = aws_api_gateway_resource.product_resource.id
  http_method                 = aws_api_gateway_method.product_post_method.http_method
  type                        = "HTTP"
  uri                         = "https://test-endpoint.com/proxy"
  integration_http_method     = "POST"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.product_resource.id
  http_method = aws_api_gateway_method.product_post_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "product_post_method_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.product_resource.id
  http_method = aws_api_gateway_method.product_post_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_api_gateway_deployment" "aws_api_gateway_deployment" {
  depends_on = ["aws_api_gateway_integration.product_post_method_integration"]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "aws_api_gateway_deployment"
}
