require 'action_dispatch/routing/route_set'

module UrlForWithSubdomains
  def url_for(options, *args)
    if SubdomainFu.needs_rewrite?(options[:subdomain], options[:host]) || options[:only_path] == false
      options[:only_path] = false if SubdomainFu.override_only_path?
      options[:host] = SubdomainFu.rewrite_host_for_subdomains(options[:subdomain], options[:host])
    end
    options.delete(:subdomain) if (route_name = options[:use_route]) && (route = named_routes.get(route_name)) && route.requirements[:subdomain].blank?
    super(options, *args)
  end
end

ActionDispatch::Routing::RouteSet.prepend(UrlForWithSubdomains)
