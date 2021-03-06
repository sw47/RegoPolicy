    package admission

    import data.k8s.matches
    
    ##############################################################################
    #
    # Policy : Ensure services listen only on allowed ports.
    #
    ##############################################################################

    deny[{
        "id": "{{AzurePolicyID}}",         # identifies type of violation
        "resource": {
            "kind": "services",            # identifies kind of resource
            "namespace": namespace,        # identifies namespace of resource
            "name": name                   # identifies name of resource
        },
        "resolution": {"message": msg},    # provides human-readable message to display
    }] {
        matches[["services", namespace, name, matched_service]]
        port = matched_service.spec.ports[_]
        format_int(port.port, 10, portstr)
        not re_match("{{policyParameters.allowedServicePortsRegex}}", portstr)
        msg := sprintf("invalid port %v for service %v", [portstr, matched_service.metadata.name])
    }