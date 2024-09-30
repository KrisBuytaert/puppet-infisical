#  infisical/manifests/init.pp
class infisical::get_secrets (
  Array[String] $secret_keys,
  Optional[String] $api_endpoint = hiera('infisical_api_endpoint', 'https://api.infisical.com'),
  Optional[String] $project_token = hiera('infisical_project_token', undef),
) {
  # Ensure the required Ruby gem or HTTP lib is available
  package { 'net-http':
    ensure => present,
  }

  # Iterate over the secret keys and call the custom resource for each one
  $secret_keys.each |$secret_key| {
    infisical::secret { "infisical_secret_${secret_key}":
      secret_key    => $secret_key,
      api_endpoint  => $api_endpoint,
      project_token => $project_token,
    }
  }
}

