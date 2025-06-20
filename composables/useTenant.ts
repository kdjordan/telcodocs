import type { Tenant } from '~/types'

export const useTenant = () => {
  const tenant = useState<Tenant | null>('tenant')
  
  const isMultiTenantMode = () => {
    return !!tenant.value
  }
  
  const getTenantId = () => {
    return tenant.value?.id || null
  }
  
  const getTenantSettings = () => {
    return tenant.value?.settings || {}
  }
  
  const getTenantSubdomain = () => {
    return tenant.value?.subdomain || null
  }
  
  return {
    tenant: readonly(tenant),
    isMultiTenantMode,
    getTenantId,
    getTenantSettings,
    getTenantSubdomain
  }
}