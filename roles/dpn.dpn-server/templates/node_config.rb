{% for node in nodeitem[item] %}
Node.create!(
  name: "{{ node.name}}", # Note this need *not* be the canonical name
  namespace: "{{node.namespace}}",
  api_root: "{{node.api_root}}",
  private_auth_token: "{{node.token}}",
  auth_credential: "{{node._credential}}")
{% endfor %}
