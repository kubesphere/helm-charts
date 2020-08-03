---
stage: Enablement
group: Distribution
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
---

# Validations of values using JSON Schema

Helm 3 introduced support for validation of values using [schema
files](https://helm.sh/docs/topics/charts/#schema-files) which follow [JSON
Schema](https://json-schema.org/). Helm charts in this repository also makes use
of this feature by defining `values.schema.json` file for each sub-chart.

Guidelines for developers regarding usage of schema files:

- If you are adding a new entry to or modifying an existing entry in the `values.yml`
  file of a subchart, you must update the respective `values.schema.json` file to match
  this change.
- The first iteration of this task is expected to be completed when all the sub-charts
  are equipped with a schema file. You can check the progress of the first iteration in
  the [related epic](https://gitlab.com/groups/gitlab-org/charts/-/epics/8). Future
  iterations will focus on improving and polishing these schema files and enhance their
  efficiency and usability.
- All settings configurable via `values.yml` must have type validations (ensure they
  accept only the correct data types as values) implemented in the `values.schema.json`
  file. This must be completed in the first iteration.
- During the first iteration, validation of required fields can be limited to ensuring
  the settings a user has defined in their `values.yml` file is sufficient to spin up a
  pod with just that component, and without any error being reported in the logs. In
  future iterations, this should be expanded to ensure the pod is, in fact, functional.
  This involves deeper testing.
