# Subscription

Create or update a subscription.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | No       | The name of the subscription.
displayName    | No       | The display name of the subscription.
workloadType   | No       | The workload type can be either `Production` or `DevTest` and is case sensitive.
managementGroup | No       | Specifies the name of the management group where the subscription will be linked to.
billingScope   | Yes      | The billing scope for the subscription.
subscriptionId | No       | The GUID if the subscription already exists.
assignments    | No       | A list of additional role assignments for the subscription.
tags           | No       | Apply tags to the subscription.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the subscription.

**Default value**

```text
[deployment().name]
```

### displayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the subscription.

**Default value**

```text
[parameters('name')]
```

### workloadType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The workload type can be either `Production` or `DevTest` and is case sensitive.

**Default value**

```text
Production
```

**Allowed values**

```text
DevTest
Production
```

### managementGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies the name of the management group where the subscription will be linked to.

**Default value**

```text
[tenant().tenantId]
```

### billingScope

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The billing scope for the subscription.

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The GUID if the subscription already exists.

### assignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of additional role assignments for the subscription.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Apply tags to the subscription.

## Outputs

Name | Type | Description
---- | ---- | -----------
id   | string | A unique identifier for the subscription.
subscriptionId | string | The guid for the deployed subscription.
