#
# Basic functionality
#

provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_api_gateway_rest_api" "api" {
    name = "proxy-gateway"
    description = "Proxy to handle requests from an external service to a backend service protected by a simple api key"
}

resource "aws_api_gateway_method" "product_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.product_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_resource" "product_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "products"
}
