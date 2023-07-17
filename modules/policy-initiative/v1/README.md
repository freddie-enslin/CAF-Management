# Policy Initiative

Create or update an Azure Policy initiative to enforce governance rules.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | No       | The name of the policy initiative.
displayName    | No       | The display name of the policy initiative.
category       | No       | Set the category of the policy initiative. The default category is `Governance`.
version        | No       | Set the version of the policy initiative.
preview        | Yes      | Set to `true` of the policy in preview. Preview policies will use the `-preview` suffix to keep them separate from GA policies.
deprecated     | No       | Set to `true` if the policy initiative has been marked as _deprecated_.
description    | No       | The purpose of the policy initiative.
metadata       | No       | Additional metadata to add to the initiative.
content        | Yes      | Define the body of the policy initiative.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the policy initiative.

**Default value**

```text
[deployment().name]
```

### displayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the policy initiative.

**Default value**

```text
[parameters('name')]
```

### category

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the category of the policy initiative. The default category is `Governance`.

### version

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set the version of the policy initiative.

### preview

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Set to `true` of the policy in preview. Preview policies will use the `-preview` suffix to keep them separate from GA policies.

### deprecated

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set to `true` if the policy initiative has been marked as _deprecated_.

**Default value**

```text
False
```

### description

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The purpose of the policy initiative.

### metadata

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Additional metadata to add to the initiative.

### content

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Define the body of the policy initiative.

## Outputs

Name | Type | Description
---- | ---- | -----------
id   | string | A unique identifier for the Policy Initiative.
