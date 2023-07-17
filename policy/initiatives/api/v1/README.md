# Landing Zone API Initiatives

These initiatives are deployed at the landing zone management group within the Aurizon enterprise.

## API Policies

The following policies are contained within this initiative.

- API Management APIs should use only encrypted protocols
- API Management calls to API backends should be authenticated
- API Management calls to API backends should not bypass certificate thumbprint or name validation
- API Management direct management endpoint should not be enabled
- API Management minimum API version should be set to 2019-12-01 or higher
- API Management secret named values should be stored in Azure Key Vault
- API Management services should use a virtual network
- API Management should disable public network access to the service configuration endpoints
- API Management subscriptions should not be scoped to all APIs
