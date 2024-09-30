require 'net/http'
require 'uri'
require 'json'

# Puppet custom function to fetch secrets from Infisical
Puppet::Functions.create_function(:'infisical_lookup') do
  dispatch :lookup do
    param 'String', :secret_key
    optional_param 'String', :project_token
    optional_param 'String', :endpoint
  end

  def lookup(secret_key, project_token = nil, endpoint = nil)
    project_token ||= lookup_project_token_from_hiera
    endpoint ||= lookup_endpoint_from_hiera

    # Ensure the endpoint is configured
    unless endpoint
      raise Puppet::Error, "Infisical endpoint not specified. Please configure it via the function or Hiera."
    end

    # Construct the full API URI for the secret
    uri = URI.parse("#{endpoint}/api/v3/secrets/raw/#{secret_key}")

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{project_token}"
    Puppet.debug("Infisical API URL: #{uri}")
  #  Puppet.debug("Infisical API Headers: #{headers}")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    Puppet.debug ("response : #{response.body}" )

    if response.code.to_i == 200
      secret = JSON.parse(response.body)['secret']['secretValue']
      Puppet.debug ("sekreet : #{secret}" )
      return secret
    else
      raise Puppet::Error, "Failed to retrieve secret #{secret_key} from Infisical: #{response.message}"
    end
  end

  # Optionally, fetch the project token from Hiera
  def lookup_project_token_from_hiera
    call_function('hiera', 'infisical_project_token')
  end

  # Optionally, fetch the endpoint from Hiera
  def lookup_endpoint_from_hiera
    call_function('hiera', 'infisical_api_endpoint', 'https://api.infisical.com')  # Default endpoint if not in Hiera
  end
end

