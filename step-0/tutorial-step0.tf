#
# Definition of a AWS API gateway
#

provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_api_gateway_rest_api" "api" {
    name = "proxy-gateway"
    description = "Proxy to handle requests from an external service to a backend service protected by a simple api key"
}
