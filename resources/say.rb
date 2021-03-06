resource_name :slack_speak

property :message, String, required: true
default_action :say

action :say do
  aws_ssm_parameter_store 'get_slack_api_key' do
    name node['slack_speak']['ssm_parameter_store_hook_url']
    return_key 'slack_hook_url'
    with_decryption true
    action :get
  end

  ruby_block 'speak' do
    block do
      uri           = URI.parse(node.run_state['slack_hook_url'])
      https         = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req           = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
      req.body      = { text: new_resource.message }.to_json.to_s
      https.request(req)
    end
    ignore_failure true
  end
  only_if { node.run_state.key?('slack_hook_url') }
end
