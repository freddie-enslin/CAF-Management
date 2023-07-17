# Subscription

Create ot update a subscription (version 2)

## Parameters

Parameter Name | Required | Description
-------------- | -------- | -----------
existingSubscriptionId | No | Existing subscription Id if it exists
subscriptionBillingScope | Yes | The billing scope for the subscription
subscriptionAliasName | No | The name of the subscription alias to be created
subscriptionDisplayName | No | The name of the subscription
subscriptionWorkload | No | The workload type can be either `Production` or `DevTest` and is case sensitive.
subscriptionManagementGroupId | No | The management group for subscription placement.
tags | No | Apply tags to the subscription

### existingSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The GUID of the existing subscription, if it exists

### subscriptionBillingScope

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The billing scope for the subscription

### subscriptionAliasName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The alias name for the subscription, this is the vaule that will be deployed for the new subscription.

### subscriptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

This is generally the same as the alias name, however it can be different if required.

### SubscriptionWorkload

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The workload type that can be deployed.  Type can be wither `Production` or `DevTest` and is case sensitive.  ANy subscriptions that will server production or management workloads must use Production.  DevTeest is avaialble for development and sandbox environments.

**Default value**

```text
Production
```

**Allowed values**

```text
Production
DevTest
```

### subscriptionManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Management group for subscription placement

**Default value**

```text
[tenant().tenantId]
```

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags to apply to the subscription

**Recommended values**

```bicep
tags {
  businessOwner: 'some.user@aurizon.com.au'
  businessGroup: 'kaiseki, managed apps, infrastructure'
  costCentre: 'apps, infrastructure ...'
  environment: 'dev, prd, sbx'
  technicalContact: 'some.user@aurizon.com.au'
  technicalGroup: 'apps, infrastructure ...'
  sourceCode: '{host}/{org}/{repo} e.g. github/Aurion/azure-core-platform'
}
```

## Outputs

Name | Type | Description
---- | ---- | -----------
id | string | A unique identifier for the subscription
subscriptionId | string | The GUID for the deployed subscription
