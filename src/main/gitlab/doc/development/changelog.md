# Changelog entries

This guide contains instructions for when and how to generate a changelog entry
file, as well as information and history about our changelog process. These entries
are later integrated by [changelog_manager](changelog-manager.md)

## Overview

Each bullet point, or **entry**, in our [`CHANGELOG.md`][changelog.md] file is
generated from a single data file in the [`changelogs/unreleased/`][unreleased]
folder. The file is expected to be a [YAML] file in the
following format:

```yaml
---
title: "Change[log]s"
merge_request: 1972
author: Black Sabbath
type: added
```

The `merge_request` value is a reference to a merge request that adds this
entry, and the `author` key is used to give attribution to community
contributors. **Both are optional**.
The `type` field maps the category of the change,
valid options are: added, fixed, changed, deprecated, removed, security, other. **Type field is mandatory**.

Community contributors and core team members are encouraged to add their name to
the `author` field. GitLab team members **should not**.

[changelog.md]: https://gitlab.com/gitlab-org/charts/gitlab/blob/master/CHANGELOG.md
[unreleased]: https://gitlab.com/gitlab-org/charts/gitlab/tree/master/changelogs/
[YAML]: https://en.wikipedia.org/wiki/YAML

## What warrants a changelog entry?

- Any user-facing change **should** have a changelog entry. Example: "GitLab now
  uses system fonts for all text."
- A fix for a regression introduced and then fixed in the same release (i.e.,
  fixing a bug introduced during a monthly release candidate) **should not**
  have a changelog entry.
- Any developer-facing change (e.g., refactoring, technical debt remediation,
  test suite changes) **should not** have a changelog entry. Example: "Reduce
  database records created during Cycle Analytics model spec."
- _Any_ contribution from a community member, no matter how small, **may** have
  a changelog entry regardless of these guidelines if the contributor wants one.
  Example: "Fixed a typo on the search results page. (Jane Smith)"

## Writing good changelog entries

A good changelog entry should be descriptive and concise. It should explain the
change to a reader who has _zero context_ about the change. If you have trouble
making it both concise and descriptive, err on the side of descriptive.

- **Bad:** Go to a project order.
- **Good:** Show a user's starred projects at the top of the "Go to project"
  dropdown.

The first example provides no context of where the change was made, or why, or
how it benefits the user.

- **Bad:** Copy (some text) to clipboard.
- **Good:** Update the "Copy to clipboard" tooltip to indicate what's being
  copied.

Again, the first example is too vague and provides no context.

- **Bad:** Fixes and Improves CSS and HTML problems in mini pipeline graph and
  builds dropdown.
- **Good:** Fix tooltips and hover states in mini pipeline graph and builds
  dropdown.

The first example is too focused on implementation details. The user doesn't
care that we changed CSS and HTML, they care about the _end result_ of those
changes.

- **Bad:** Strip out `nil`s in the Array of Commit objects returned from
  `find_commits_by_message_with_elastic`
- **Good:** Fix 500 errors caused by Elasticsearch results referencing
  garbage-collected commits

The first example focuses on _how_ we fixed something, not on _what_ it fixes.
The rewritten version clearly describes the _end benefit_ to the user (fewer 500
errors), and _when_ (searching commits with Elasticsearch).

Use your best judgement and try to put yourself in the mindset of someone
reading the compiled changelog. Does this entry add value? Does it offer context
about _where_ and _why_ the change was made?

## How to generate a changelog entry

A `bin/changelog` script is available to generate the changelog entry file
automatically.

Its simplest usage is to provide the value for `title`:

```shell
bin/changelog 'Hey DZ, I added a feature to GitLab!'
```

At this point the script would ask you to select the category of the change (mapped to the `type` field in the entry):

```plaintext
>> Please specify the category of your change:
1. New feature
2. Bug fix
3. Feature change
4. New deprecation
5. Feature removal
6. Security fix
7. Other
```

The entry filename is based on the name of the current Git branch. If you run
the command above on a branch called `feature/hey-dz`, it will generate a
`changelogs/unreleased/feature-hey-dz.yml` file.

The command will output the path of the generated file and its contents:

```plaintext
create changelogs/unreleased/my-feature.yml
---
title: Hey DZ, I added a feature to GitLab!
merge_request:
author:
type:
```

### Arguments

| Argument                                    | Shorthand | Purpose                                       |
| ------------------------------------------- | --------- | --------------------------------------------- |
| [`--amend`](#--amend)                       |           | Amend the previous commit                     |
| [`--force`](#--force-or--f)                 | `-f`      | Overwrite an existing entry                   |
| [`--merge-request`](#--merge-request-or--m) | `-m`      | Set merge request ID                          |
| [`--dry-run`](#--dry-run-or--n)             | `-n`      | Don't actually write anything, just print     |
| [`--git-username`](#--git-username-or--u)   | `-u`      | Use Git user.name configuration as the author |
| [`--type`](#--type-or--t)                   | `-t`      | The category of the change, valid options are: added, fixed, changed, deprecated, removed, security, other |
| `--help`                                    | `-h`      | Print help message                            |

#### `--amend`

You can pass the **`--amend`** argument to automatically stage the generated
file and amend it to the previous commit.

If you use **`--amend`** and don't provide a title, it will automatically use
the "subject" of the previous commit, which is the first line of the commit
message:

```shell
$ git show --oneline
ab88683 Added an awesome new feature to GitLab

$ bin/changelog --amend
create changelogs/unreleased/feature-hey-dz.yml
---
title: Added an awesome new feature to GitLab
merge_request:
author:
type:
```

#### `--force` or `-f`

Use **`--force`** or **`-f`** to overwrite an existing changelog entry if it
already exists.

```shell
$ bin/changelog 'Hey DZ, I added a feature to GitLab!'
error changelogs/unreleased/feature-hey-dz.yml already exists! Use `--force` to overwrite.

$ bin/changelog 'Hey DZ, I added a feature to GitLab!' --force
create changelogs/unreleased/feature-hey-dz.yml
---
title: Hey DZ, I added a feature to GitLab!
merge_request: 1983
author:
type:
```

#### `--merge-request` or `-m`

Use the **`--merge-request`** or **`-m`** argument to provide the
`merge_request` value:

```shell
$ bin/changelog 'Hey DZ, I added a feature to GitLab!' -m 1983
create changelogs/unreleased/feature-hey-dz.yml
---
title: Hey DZ, I added a feature to GitLab!
merge_request: 1983
author:
type:
```

#### `--dry-run` or `-n`

Use the **`--dry-run`** or **`-n`** argument to prevent actually writing or
committing anything:

```shell
$ bin/changelog --amend --dry-run
create changelogs/unreleased/feature-hey-dz.yml
---
title: Added an awesome new feature to GitLab
merge_request:
author:
type:

$ ls changelogs/unreleased/
```

#### `--git-username` or `-u`

Use the **`--git-username`** or **`-u`** argument to automatically fill in the
`author` value with your configured Git `user.name` value:

```shell
$ git config user.name
Jane Doe

$ bin/changelog -u 'Hey DZ, I added a feature to GitLab!'
create changelogs/unreleased/feature-hey-dz.yml
---
title: Hey DZ, I added a feature to GitLab!
merge_request:
author: Jane Doe
type:
```

#### `--type` or `-t`

Use the **`--type`** or **`-t`** argument to provide the `type` value:

```shell
$ bin/changelog 'Hey DZ, I added a feature to GitLab!' -t added
create changelogs/unreleased/feature-hey-dz.yml
---
title: Hey DZ, I added a feature to GitLab!
merge_request:
author:
type: added
```

### History and Reasoning

This method was adopted from the primary [GitLab codebase][gl-codebase], as we
found the workflow to be appealing and familiar.

---

[Return to Development documentation](index.md)

[gl-codebase]: https://gitlab.com/gitlab-org/gitlab-foss/blob/master/doc/development/changelog.md
