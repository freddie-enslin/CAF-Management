# Policy Initiative assignment

Assign a policy initiative at a management group scope.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | No       | The name of the assignment.
displayName    | No       | The display name of the assignment. By default this will be the name of the assignment.
description    | No       | An additional description for the assignment.
category       | No       | Set the category of the assignment.
policyDefinitionId | Yes      | The resource Id for the initiative that will be assigned to the scope.
enforced       | Yes      | Determines if the assignment is enforced.
assignedBy     | No       | The assigner that will be reported by Azure Policy.
excludedScopes | No       | Any excluded scopes for the assignment.
parameters     | No       | Any additional parameters that are required by the assignment.
metadata       | No       | Additional metadata to add to the assignment.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the assignment.

**Default value**

```text
[deployment().name]
```

### displayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the assignment. By default this will be the name of the assignment.

**Default value**

```text
[parameters('name')]
```

### description

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An additional description for the assignment.

### category

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the category of the assignment.

**Default value**

```text
Governance
```

### policyDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The resource Id for the initiative that will be assigned to the scope.

### enforced

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Determines if the assignment is enforced.

### assignedBy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The assigner that will be reported by Azure Policy.

**Default value**

```text
DevOps deployment
```

### excludedScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Any excluded scopes for the assignment.

### parameters

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Any additional parameters that are required by the assignment.

### metadata

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Additional metadata to add to the assignment.

## Outputs

Name | Type | Description
---- | ---- | -----------
id   | string | A unique identifier for the Policy Initiative assignment.
