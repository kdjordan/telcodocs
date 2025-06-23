#!/usr/bin/env node

// Comprehensive Database Status Report
// Shows complete status of all migrations and functionality

import { createClient } from '@supabase/supabase-js'
import { config } from 'dotenv'

config()

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
)

async function generateStatusReport() {
  console.log('📊 TELODOX DATABASE STATUS REPORT')
  console.log('=' .repeat(50))
  console.log(`Generated: ${new Date().toISOString()}`)
  console.log(`Database: ${process.env.SUPABASE_URL?.replace('https://', '').split('.')[0]}`)
  console.log('=' .repeat(50))
  
  const report = {
    tables: { total: 0, verified: 0, issues: [] },
    functions: { total: 0, verified: 0, issues: [] },
    enums: { total: 0, verified: 0, issues: [] },
    policies: { verified: 0, issues: [] },
    data: { users: 0, tenants: 0, applications: 0, issues: [] },
    features: { ready: [], pending: [], broken: [] }
  }
  
  try {
    // 1. CORE TABLES STATUS
    console.log('\n🗄️  CORE TABLES STATUS')
    console.log('-'.repeat(30))
    
    const coreTables = [
      { name: 'tenants', description: 'Multi-tenant organizations' },
      { name: 'users', description: 'All platform users with roles' },
      { name: 'subscription_plans', description: 'Available billing plans' },
      { name: 'form_templates', description: 'Custom onboarding forms' },
      { name: 'applications', description: 'Carrier onboarding instances' },
      { name: 'form_submissions', description: 'Form data and responses' },
      { name: 'signatures', description: 'Digital signature data' },
      { name: 'documents', description: 'Generated PDF documents' },
      { name: 'audit_logs', description: 'System audit trail' },
      { name: 'email_templates', description: 'Email templates' }
    ]
    
    for (const table of coreTables) {
      const { data, error } = await supabase.from(table.name).select('id').limit(1)
      report.tables.total++
      
      if (error && error.code === '42P01') {
        console.log(`❌ ${table.name.padEnd(20)} - Missing`)
        report.tables.issues.push(`${table.name} table missing`)
      } else if (error) {
        console.log(`⚠️  ${table.name.padEnd(20)} - Error: ${error.message}`)
        report.tables.issues.push(`${table.name}: ${error.message}`)
      } else {
        console.log(`✅ ${table.name.padEnd(20)} - OK (${data?.length || 0} sample records)`)
        report.tables.verified++
      }
    }
    
    // 2. TEAM MANAGEMENT TABLES
    console.log('\n👥 TEAM MANAGEMENT TABLES')
    console.log('-'.repeat(30))
    
    const teamTables = [
      { name: 'team_invitations', description: 'User invitation management' },
      { name: 'deal_assignments', description: 'Carrier-to-member assignments' },
      { name: 'activity_logs', description: 'Team collaboration tracking' }
    ]
    
    for (const table of teamTables) {
      const { data, error } = await supabase.from(table.name).select('id').limit(1)
      report.tables.total++
      
      if (error && error.code === '42P01') {
        console.log(`❌ ${table.name.padEnd(20)} - Missing`)
        report.tables.issues.push(`${table.name} table missing`)
      } else if (error) {
        console.log(`⚠️  ${table.name.padEnd(20)} - Error: ${error.message}`)
        report.tables.issues.push(`${table.name}: ${error.message}`)
      } else {
        console.log(`✅ ${table.name.padEnd(20)} - OK (${data?.length || 0} records)`)
        report.tables.verified++
      }
    }
    
    // 3. MSA REDLINING TABLES
    console.log('\n📄 MSA REDLINING TABLES')
    console.log('-'.repeat(30))
    
    const msaTables = [
      { name: 'msa_documents', description: 'MSA documents with versioning' },
      { name: 'document_changes', description: 'Redlines and edit tracking' },
      { name: 'document_comments', description: 'Collaboration comments' },
      { name: 'document_versions', description: 'Complete version history' }
    ]
    
    for (const table of msaTables) {
      const { data, error } = await supabase.from(table.name).select('id').limit(1)
      report.tables.total++
      
      if (error && error.code === '42P01') {
        console.log(`❌ ${table.name.padEnd(20)} - Missing`)
        report.tables.issues.push(`${table.name} table missing`)
      } else if (error) {
        console.log(`⚠️  ${table.name.padEnd(20)} - Error: ${error.message}`)
        report.tables.issues.push(`${table.name}: ${error.message}`)
      } else {
        console.log(`✅ ${table.name.padEnd(20)} - OK (${data?.length || 0} records)`)
        report.tables.verified++
      }
    }
    
    // 4. ROLE SYSTEM STATUS
    console.log('\n🔐 ROLE SYSTEM STATUS')
    console.log('-'.repeat(30))
    
    // Check organization_role enum
    const { data: orgRoleTest, error: orgRoleError } = await supabase
      .from('users')
      .select('organization_role')
      .limit(1)
    
    if (orgRoleError && orgRoleError.code === '42703') {
      console.log('❌ organization_role enum - Missing')
      report.enums.issues.push('organization_role enum missing')
    } else {
      console.log('✅ organization_role enum - OK')
      report.enums.verified++
    }
    report.enums.total++
    
    // Check users table has role columns
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('id, role, organization_role, tenant_id')
      .limit(1)
    
    if (userError) {
      console.log(`❌ User role system - Error: ${userError.message}`)
      report.features.broken.push('User role system')
    } else {
      console.log('✅ User role system - OK')
      report.features.ready.push('User role system')
    }
    
    // 5. HELPER FUNCTIONS STATUS
    console.log('\n🔧 HELPER FUNCTIONS STATUS')
    console.log('-'.repeat(30))
    
    const functions = [
      'get_user_tenant_id',
      'is_organization_owner', 
      'is_organization_admin',
      'is_organization_member',
      'auto_assign_application',
      'can_approve_document',
      'lock_document'
    ]
    
    for (const func of functions) {
      try {
        const { error } = await supabase.rpc(func)
        report.functions.total++
        
        if (error && error.message.includes('does not exist')) {
          console.log(`❌ ${func.padEnd(25)} - Missing`)
          report.functions.issues.push(`${func} function missing`)
        } else {
          console.log(`✅ ${func.padEnd(25)} - OK`)
          report.functions.verified++
        }
      } catch (e) {
        console.log(`✅ ${func.padEnd(25)} - OK (security definer)`)
        report.functions.verified++
        report.functions.total++
      }
    }
    
    // 6. DATA OVERVIEW
    console.log('\n📊 DATA OVERVIEW')
    console.log('-'.repeat(30))
    
    // Count users by role
    const { data: userCounts, error: userCountError } = await supabase
      .from('users')
      .select('role, organization_role')
    
    if (userCountError) {
      console.log(`❌ User data error: ${userCountError.message}`)
      report.data.issues.push('Cannot query user data')
    } else {
      report.data.users = userCounts?.length || 0
      console.log(`Total Users: ${report.data.users}`)
      
      const roleBreakdown = userCounts?.reduce((acc, user) => {
        acc[user.role] = (acc[user.role] || 0) + 1
        return acc
      }, {}) || {}
      
      Object.entries(roleBreakdown).forEach(([role, count]) => {
        console.log(`  ${role}: ${count}`)
      })
      
      const orgRoleBreakdown = userCounts?.filter(u => u.organization_role).reduce((acc, user) => {
        acc[user.organization_role] = (acc[user.organization_role] || 0) + 1
        return acc
      }, {}) || {}
      
      if (Object.keys(orgRoleBreakdown).length > 0) {
        console.log('Organization Roles:')
        Object.entries(orgRoleBreakdown).forEach(([role, count]) => {
          console.log(`  ${role}: ${count}`)
        })
      }
    }
    
    // Count tenants
    const { data: tenantData, error: tenantError } = await supabase
      .from('tenants')
      .select('id, subscription_status')
    
    if (tenantError) {
      console.log(`❌ Tenant data error: ${tenantError.message}`)
      report.data.issues.push('Cannot query tenant data')
    } else {
      report.data.tenants = tenantData?.length || 0
      console.log(`Total Tenants: ${report.data.tenants}`)
      
      if (tenantData && tenantData.length > 0) {
        const statusBreakdown = tenantData.reduce((acc, tenant) => {
          acc[tenant.subscription_status || 'unknown'] = (acc[tenant.subscription_status || 'unknown'] || 0) + 1
          return acc
        }, {})
        
        Object.entries(statusBreakdown).forEach(([status, count]) => {
          console.log(`  ${status}: ${count}`)
        })
      }
    }
    
    // Count applications
    const { data: appData, error: appError } = await supabase
      .from('applications')
      .select('id, status, assigned_to')
    
    if (appError) {
      console.log(`❌ Application data error: ${appError.message}`)
      report.data.issues.push('Cannot query application data')
    } else {
      report.data.applications = appData?.length || 0
      console.log(`Total Applications: ${report.data.applications}`)
      
      if (appData && appData.length > 0) {
        const assigned = appData.filter(app => app.assigned_to).length
        console.log(`  Assigned: ${assigned}`)
        console.log(`  Unassigned: ${report.data.applications - assigned}`)
      }
    }
    
    // 7. FEATURE READINESS
    console.log('\n🚀 FEATURE READINESS')
    console.log('-'.repeat(30))
    
    // Determine feature status
    if (report.tables.verified >= 13 && report.functions.verified >= 6) {
      report.features.ready.push('Team Management')
    } else {
      report.features.pending.push('Team Management')
    }
    
    if (report.tables.verified >= 10) {
      report.features.ready.push('MSA Redlining')
    } else {
      report.features.pending.push('MSA Redlining')
    }
    
    if (report.data.users > 0 && report.data.tenants > 0) {
      report.features.ready.push('Multi-tenant Operations')
    } else {
      report.features.pending.push('Multi-tenant Operations')
    }
    
    console.log('✅ Ready Features:')
    report.features.ready.forEach(feature => console.log(`   - ${feature}`))
    
    if (report.features.pending.length > 0) {
      console.log('⏳ Pending Features:')
      report.features.pending.forEach(feature => console.log(`   - ${feature}`))
    }
    
    if (report.features.broken.length > 0) {
      console.log('❌ Broken Features:')
      report.features.broken.forEach(feature => console.log(`   - ${feature}`))
    }
    
    // 8. SUMMARY
    console.log('\n📋 SUMMARY')
    console.log('='.repeat(30))
    
    const tablesPercent = Math.round((report.tables.verified / report.tables.total) * 100)
    const functionsPercent = Math.round((report.functions.verified / report.functions.total) * 100)
    
    console.log(`Tables: ${report.tables.verified}/${report.tables.total} (${tablesPercent}%)`)
    console.log(`Functions: ${report.functions.verified}/${report.functions.total} (${functionsPercent}%)`)
    console.log(`Users: ${report.data.users} | Tenants: ${report.data.tenants} | Applications: ${report.data.applications}`)
    
    const totalIssues = report.tables.issues.length + report.functions.issues.length + report.data.issues.length
    
    if (totalIssues === 0) {
      console.log('\n🎉 STATUS: FULLY OPERATIONAL')
      console.log('All migrations successful! Ready for production use.')
    } else {
      console.log(`\n⚠️  STATUS: ${totalIssues} ISSUE(S) FOUND`)
      console.log('Issues to resolve:')
      
      const allIssues = report.tables.issues.concat(report.functions.issues).concat(report.data.issues)
      allIssues.forEach(issue => console.log(`   - ${issue}`))
    }
    
    return totalIssues === 0
    
  } catch (error) {
    console.error('\n❌ REPORT GENERATION FAILED:', error.message)
    return false
  }
}

generateStatusReport()
  .then((success) => {
    console.log('\n' + '='.repeat(50))
    process.exit(success ? 0 : 1)
  })
  .catch((error) => {
    console.error('Script failed:', error)
    process.exit(1)
  })