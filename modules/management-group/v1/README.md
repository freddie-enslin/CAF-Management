# Management Group

Create or update and management group to the specified parent management group.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | No       | The name of the Management Group.
displayName    | No       | The display name of the Management Group.
parent         | Yes      | Specifies the name of the parent management group.
assignments    | No       | A list of additional role assignments for the Management Group.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Management Group.

**Default value**

```text
[deployment().name]
```

### displayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the Management Group.

**Default value**

```text
[parameters('name')]
```

### parent

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specifies the name of the parent management group.

### assignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of additional role assignments for the Management Group.

## Outputs

Name | Type | Description
---- | ---- | -----------
id   | string | A unique identifier for the Management Group.
