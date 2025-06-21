export interface Tenant {
  id: string
  name: string
  subdomain: string
  domain?: string
  settings: TenantSettings
  trial_ends_at?: string
  subscription_status: 'trial' | 'active' | 'cancelled' | 'expired'
  stripe_customer_id?: string
  stripe_subscription_id?: string
  created_at: string
  updated_at: string
}

export interface TenantSettings {
  logo_url?: string
  primary_color?: string
  workflow_settings: WorkflowSettings
}

export interface WorkflowSettings {
  drip_mode: 'sequential' | 'multiple' | 'all'
  require_approval: boolean
  auto_approve_after_days?: number
}

export interface User {
  id: string
  email: string
  full_name: string
  role: UserRole
  tenant_id?: string
  tenant?: Tenant
  created_at: string
  updated_at: string
}

export type UserRole = 'super_admin' | 'tenant_owner' | 'end_user'

export interface FormTemplate {
  id: string
  tenant_id: string
  name: string
  description?: string
  form_type: FormType
  fields: FormField[]
  settings: FormSettings
  version: number
  is_active: boolean
  created_by: string
  created_at: string
  updated_at: string
}

export type FormType = 'kyc' | 'fusf' | 'msa' | 'interop' | 'custom'

export interface FormField {
  id: string
  type: FieldType
  name: string
  label: string
  placeholder?: string
  required: boolean
  validation?: FieldValidation
  options?: FieldOption[]
  conditional?: ConditionalRule
  order: number
}

export type FieldType = 
  | 'text' 
  | 'email' 
  | 'phone' 
  | 'number'
  | 'textarea'
  | 'select'
  | 'radio'
  | 'checkbox'
  | 'date'
  | 'file'
  | 'signature'

export interface FieldValidation {
  pattern?: string
  min?: number
  max?: number
  minLength?: number
  maxLength?: number
  customMessage?: string
}

export interface FieldOption {
  label: string
  value: string
}

export interface ConditionalRule {
  field: string
  operator: 'equals' | 'not_equals' | 'contains' | 'greater_than' | 'less_than'
  value: any
}

export interface FormSettings {
  save_progress: boolean
  show_progress_bar: boolean
  confirmation_message?: string
  redirect_url?: string
}

export interface Application {
  id: string
  tenant_id: string
  carrier_name: string
  carrier_email: string
  user_id?: string
  status: ApplicationStatus
  current_stage: FormType
  workflow: ApplicationWorkflow[]
  created_at: string
  updated_at: string
  completed_at?: string
}

export type ApplicationStatus = 
  | 'draft'
  | 'in_progress'
  | 'pending_approval'
  | 'approved'
  | 'rejected'
  | 'completed'

export interface ApplicationWorkflow {
  form_type: FormType
  status: 'pending' | 'in_progress' | 'completed' | 'approved' | 'rejected'
  started_at?: string
  completed_at?: string
  approved_at?: string
  approved_by?: string
  rejection_reason?: string
}

export interface FormSubmission {
  id: string
  application_id: string
  form_template_id: string
  form_data: Record<string, any>
  attachments?: Attachment[]
  signature_id?: string
  submitted_at?: string
  created_at: string
  updated_at: string
}

export interface Attachment {
  id: string
  file_name: string
  file_url: string
  file_size: number
  mime_type: string
  uploaded_at: string
}

export interface Signature {
  id: string
  submission_id: string
  signature_data: string
  ip_address: string
  user_agent: string
  signed_at: string
}

export interface AuditLog {
  id: string
  tenant_id: string
  user_id: string
  action: string
  resource_type: string
  resource_id: string
  metadata?: Record<string, any>
  ip_address?: string
  user_agent?: string
  created_at: string
}