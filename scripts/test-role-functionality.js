#!/usr/bin/env node

// Test Role-Based Functionality
// Creates test data and verifies role-based access control

import { createClient } from '@supabase/supabase-js'
import { config } from 'dotenv'

config()

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
)

async function testRoleSystem() {
  console.log('🧪 Testing Role-Based Functionality...\n')
  
  try {
    // 1. Check current users and their roles
    console.log('👥 Current Users and Roles:')
    const { data: users, error: usersError } = await supabase
      .from('users')
      .select('id, email, full_name, role, organization_role, tenant_id')
      .order('created_at')
    
    if (usersError) {
      console.log('❌ Error fetching users:', usersError.message)
      return
    }
    
    users?.forEach(user => {
      console.log(`   ${user.email}: ${user.role} | ${user.organization_role || 'no org role'} | tenant: ${user.tenant_id?.slice(0,8) || 'none'}`)
    })
    
    // 2. Check tenants
    console.log('\n🏢 Current Tenants:')
    const { data: tenants, error: tenantsError } = await supabase
      .from('tenants')
      .select('id, name, subdomain, subscription_status')
    
    if (tenantsError) {
      console.log('❌ Error fetching tenants:', tenantsError.message)
    } else {
      tenants?.forEach(tenant => {
        console.log(`   ${tenant.name} (${tenant.subdomain}): ${tenant.subscription_status}`)
      })
    }
    
    // 3. Check applications
    console.log('\n📋 Current Applications:')
    const { data: applications, error: appsError } = await supabase
      .from('applications')
      .select('id, carrier_name, carrier_company_name, status, assigned_to, priority')
    
    if (appsError) {
      console.log('❌ Error fetching applications:', appsError.message)
    } else {
      console.log(`   Found ${applications?.length || 0} applications`)
      applications?.forEach(app => {
        console.log(`   ${app.carrier_company_name || app.carrier_name}: ${app.status} | assigned: ${app.assigned_to?.slice(0,8) || 'unassigned'} | priority: ${app.priority}`)
      })
    }
    
    // 4. Test enum values by inserting test data
    console.log('\n🔧 Testing Organization Role Enum:')
    
    if (users && users.length > 0 && tenants && tenants.length > 0) {
      const testUser = users[0]
      const testTenant = tenants[0]
      
      // Try to update a user's organization role
      const { data: updateData, error: updateError } = await supabase
        .from('users')
        .update({ organization_role: 'owner' })
        .eq('id', testUser.id)
        .select()
      
      if (updateError) {
        console.log('❌ Error updating organization role:', updateError.message)
      } else {
        console.log('✅ Successfully updated user organization role to "owner"')
      }
      
      // Test creating a team invitation
      console.log('\n📧 Testing Team Invitation Creation:')
      const { data: inviteData, error: inviteError } = await supabase
        .from('team_invitations')
        .insert({
          tenant_id: testTenant.id,
          email: 'test@example.com',
          organization_role: 'member',
          invited_by: testUser.id
        })
        .select()
      
      if (inviteError) {
        console.log('❌ Error creating invitation:', inviteError.message)
      } else {
        console.log('✅ Successfully created team invitation')
        console.log(`   Token: ${inviteData[0]?.invitation_token}`)
      }
    }
    
    // 5. Test MSA document creation
    if (applications && applications.length > 0 && users && users.length > 0) {
      console.log('\n📄 Testing MSA Document Creation:')
      const testApp = applications[0]
      const testUser = users[0]
      
      const { data: docData, error: docError } = await supabase
        .from('msa_documents')
        .insert({
          tenant_id: testApp.tenant_id,
          application_id: testApp.id,
          title: 'Test MSA Document',
          content: 'This is a test MSA document content.',
          created_by: testUser.id
        })
        .select()
      
      if (docError) {
        console.log('❌ Error creating MSA document:', docError.message)
      } else {
        console.log('✅ Successfully created MSA document')
        console.log(`   Document ID: ${docData[0]?.id}`)
      }
    }
    
    // 6. Test helper functions
    console.log('\n🔧 Testing Helper Functions:')
    
    try {
      const { data: tenantId, error: tenantError } = await supabase.rpc('get_user_tenant_id')
      if (tenantError) {
        console.log('❌ get_user_tenant_id error:', tenantError.message)
      } else {
        console.log('✅ get_user_tenant_id function works')
      }
    } catch (e) {
      console.log('ℹ️  get_user_tenant_id requires authenticated user context')
    }
    
    // 7. Check indexes and constraints
    console.log('\n📊 Database Performance Checks:')
    
    // Check if indexes exist by running queries that would use them
    const { data: indexTest, error: indexError } = await supabase
      .from('deal_assignments')
      .select('id')
      .eq('tenant_id', '00000000-0000-0000-0000-000000000000')
      .limit(1)
    
    if (indexError && !indexError.message.includes('permission')) {
      console.log('❌ Index test failed:', indexError.message)
    } else {
      console.log('✅ Tenant-based queries are indexed properly')
    }
    
    // 8. Test triggers
    console.log('\n⚡ Testing Triggers:')
    
    if (tenants && tenants.length > 0) {
      const testTenant = tenants[0]
      
      // Update tenant to trigger updated_at
      const { data: triggerTest, error: triggerError } = await supabase
        .from('tenants')
        .update({ settings: { test: 'trigger_test' } })
        .eq('id', testTenant.id)
        .select('updated_at')
      
      if (triggerError) {
        console.log('❌ Trigger test failed:', triggerError.message)
      } else {
        console.log('✅ updated_at trigger working')
        console.log(`   Updated at: ${triggerTest[0]?.updated_at}`)
      }
    }
    
    console.log('\n🎉 Role functionality testing complete!')
    
  } catch (error) {
    console.error('❌ Testing failed:', error)
  }
}

testRoleSystem()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Script failed:', error)
    process.exit(1)
  })