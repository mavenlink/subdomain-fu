require 'action_dispatch/routing/route_set'

module ActionDispatch
  module Routing
    class RouteSet #:nodoc:
      def url_for_with_subdomains(options, *args)
        if SubdomainFu.needs_rewrite?(options[:subdomain], options[:host]) || options[:only_path] == false
          options[:only_path] = false if SubdomainFu.override_only_path?
          options[:host] = SubdomainFu.rewrite_host_for_subdomains(options[:subdomain], options[:host])
        end
        options.delete(:subdomain) if (route_name = options[:use_route]) && (route = named_routes.get(route_name)) && route.requirements[:subdomain].blank?
        url_for_without_subdomains(options, *args)
      end
      alias_method_chain :url_for, :subdomains
    end
  end
end
