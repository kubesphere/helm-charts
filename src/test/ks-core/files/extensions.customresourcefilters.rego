package filter

import rego.v1

default match := false

match if {
	not listAvailableExtension
	not fuzzySearch
	not installStatusSearch
	not enabledStatusSearch
}

match if {
	listAvailableExtension
	isSubscribed
}

match if {
	listAvailableExtension
	alreadyInstalled
}

match if {
	listAvailableExtension
	not hasExtensionID
}

match if {
	fuzzySearch
	displayNameMatch
}

match if {
	installStatusSearch
	installStatusMatch
}

match if {
	enabledStatusSearch
	enabledStatusMatch
}

fuzzySearch if "q" == input.filter.field

installStatusSearch if "status" == input.filter.field

enabledStatusSearch if "enabled" == input.filter.field

listAvailableExtension if "available" == input.filter.field

isSubscribed if input.object.metadata.labels["marketplace.kubesphere.io/subscribed"] == "true"

alreadyInstalled if input.object.status.state != ""

hasExtensionID if input.object.metadata.labels["marketplace.kubesphere.io/extension-id"] != ""

displayNameMatch if {
	contains(lower(input.object.spec.displayName[_]), lower(input.filter.value))
}

nameMatch if {
	contains(lower(input.object.metadata.name), lower(input.filter.value))
}

installStatusMatch if {
	lower(input.object.status.state) == lower(input.filter.value)
}

enabledStatusMatch if {
	input.filter.value == "true" == input.object.status.enabled
}
