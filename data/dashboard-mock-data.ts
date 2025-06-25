// Mock data for Organization Owner Dashboard Screenshot
// This creates realistic, impressive data for marketing purposes

export const mockDashboardData = {
  // Key metrics showing strong performance
  metrics: {
    activeCarriers: 47,
    pendingApprovals: 12,
    completedThisMonth: 23,
    teamEfficiency: 92
  },

  // Carriers requiring attention - shows active deal flow
  urgentCarriers: [
    {
      id: '1',
      tenant_id: 'mock-tenant',
      carrier_name: 'Verizon Business',
      carrier_company_name: 'Verizon Communications Inc.',
      carrier_email: 'enterprise@verizon.com',
      status: 'pending_approval',
      current_stage: 'msa',
      priority: 'high',
      assigned_to: 'sarah-id',
      assigned_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 3 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 450000 }
    },
    {
      id: '2',
      tenant_id: 'mock-tenant',
      carrier_name: 'AT&T Enterprise',
      carrier_company_name: 'AT&T Inc.',
      carrier_email: 'wholesale@att.com',
      status: 'requires_action',
      current_stage: 'fusf',
      priority: 'urgent',
      assigned_to: 'mike-id',
      assigned_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 325000 }
    },
    {
      id: '3',
      tenant_id: 'mock-tenant',
      carrier_name: 'T-Mobile for Business',
      carrier_company_name: 'T-Mobile US Inc.',
      carrier_email: 'partner@t-mobile.com',
      status: 'pending_approval',
      current_stage: 'kyc',
      priority: 'high',
      assigned_to: 'emily-id',
      assigned_at: new Date(Date.now() - 4 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 30 * 60 * 1000).toISOString(),
      metadata: { dealValue: 275000 }
    },
    {
      id: '4',
      tenant_id: 'mock-tenant',
      carrier_name: 'Lumen Technologies',
      carrier_company_name: 'Lumen Technologies Inc.',
      carrier_email: 'wholesale@lumen.com',
      status: 'overdue',
      current_stage: 'interop',
      priority: 'urgent',
      assigned_to: 'david-id',
      assigned_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 180000 }
    },
    {
      id: '5',
      tenant_id: 'mock-tenant',
      carrier_name: 'Comcast Business',
      carrier_company_name: 'Comcast Corporation',
      carrier_email: 'enterprise@comcastbusiness.com',
      status: 'pending_approval',
      current_stage: 'msa',
      priority: 'normal',
      assigned_to: 'sarah-id',
      assigned_at: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
      metadata: { dealValue: 520000 }
    }
  ],

  // Recent team activities showing vibrant ecosystem
  recentActivities: [
    {
      id: '1',
      type: 'approval_granted',
      user_name: 'Sarah Johnson',
      user_role: 'admin',
      description: 'Approved MSA redlines',
      carrier_name: 'Verizon Business',
      timestamp: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
      metadata: { changeCount: 3 }
    },
    {
      id: '2',
      type: 'document_signed',
      user_name: 'Michael Chen',
      user_role: 'member',
      description: 'Completed FUSF documentation',
      carrier_name: 'AT&T Enterprise',
      timestamp: new Date(Date.now() - 32 * 60 * 1000).toISOString()
    },
    {
      id: '3',
      type: 'carrier_onboarded',
      user_name: 'Emily Rodriguez',
      user_role: 'admin',
      description: 'Successfully onboarded carrier',
      carrier_name: 'Spectrum Enterprise',
      timestamp: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 295000 }
    },
    {
      id: '4',
      type: 'team_member_added',
      user_name: 'System',
      user_role: 'system',
      description: 'New team member joined',
      carrier_name: 'Jessica Park',
      timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString()
    },
    {
      id: '5',
      type: 'document_uploaded',
      user_name: 'David Kim',
      user_role: 'member',
      description: 'Uploaded interop test results',
      carrier_name: 'Lumen Technologies',
      timestamp: new Date(Date.now() - 3 * 60 * 60 * 1000).toISOString()
    },
    {
      id: '6',
      type: 'approval_requested',
      user_name: 'Sarah Johnson',
      user_role: 'admin',
      description: 'Requested final approval',
      carrier_name: 'Cox Communications',
      timestamp: new Date(Date.now() - 4 * 60 * 60 * 1000).toISOString()
    },
    {
      id: '7',
      type: 'form_completed',
      user_name: 'Michael Chen',
      user_role: 'member',
      description: 'Completed KYC verification',
      carrier_name: 'Charter Communications',
      timestamp: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString()
    },
    {
      id: '8',
      type: 'msa_negotiation_started',
      user_name: 'Emily Rodriguez',
      user_role: 'admin',
      description: 'Started MSA negotiation',
      carrier_name: 'Windstream Enterprise',
      timestamp: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString()
    }
  ],

  // Pipeline showing healthy distribution
  pipelineData: {
    kyc: 14,
    fusf: 12,
    msa: 15,
    interop: 6
  },

  // High-performing team
  teamMembers: [
    {
      id: 'sarah-id',
      name: 'Sarah Johnson',
      role: 'admin',
      email: 'sarah@teleconnect.com',
      assignedCarriers: 12,
      performance: 96,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=Sarah+Johnson&background=ec4899&color=fff'
    },
    {
      id: 'mike-id',
      name: 'Michael Chen',
      role: 'member',
      email: 'michael@teleconnect.com',
      assignedCarriers: 8,
      performance: 92,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=Michael+Chen&background=8b5cf6&color=fff'
    },
    {
      id: 'emily-id',
      name: 'Emily Rodriguez',
      role: 'admin',
      email: 'emily@teleconnect.com',
      assignedCarriers: 10,
      performance: 94,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=Emily+Rodriguez&background=ec4899&color=fff'
    },
    {
      id: 'david-id',
      name: 'David Kim',
      role: 'member',
      email: 'david@teleconnect.com',
      assignedCarriers: 7,
      performance: 88,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=David+Kim&background=8b5cf6&color=fff'
    },
    {
      id: 'jessica-id',
      name: 'Jessica Park',
      role: 'member',
      email: 'jessica@teleconnect.com',
      assignedCarriers: 5,
      performance: 91,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=Jessica+Park&background=ec4899&color=fff'
    },
    {
      id: 'robert-id',
      name: 'Robert Thompson',
      role: 'admin',
      email: 'robert@teleconnect.com',
      assignedCarriers: 9,
      performance: 93,
      status: 'active',
      avatar: 'https://ui-avatars.com/api/?name=Robert+Thompson&background=8b5cf6&color=fff'
    }
  ],

  // Professional form templates
  formTemplates: [
    {
      id: '1',
      name: 'Know Your Customer (KYC)',
      stage: 'kyc',
      lastModified: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      status: 'active',
      fields: 28,
      submissions: 156
    },
    {
      id: '2',
      name: 'Federal Universal Service Fund',
      stage: 'fusf',
      lastModified: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString(),
      status: 'active',
      fields: 34,
      submissions: 142
    },
    {
      id: '3',
      name: 'Master Service Agreement',
      stage: 'msa',
      lastModified: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
      status: 'active',
      fields: 45,
      submissions: 138
    },
    {
      id: '4',
      name: 'Interoperability Testing',
      stage: 'interop',
      lastModified: new Date(Date.now() - 21 * 24 * 60 * 60 * 1000).toISOString(),
      status: 'active',
      fields: 52,
      submissions: 98
    }
  ],

  // Strong revenue growth
  revenueData: {
    mrr: 24500,
    growth: 28,
    seats: 8,
    churnRate: 2.3,
    arr: 294000,
    avgDealSize: 285000,
    timeToRevenue: 12, // days
    monthlyData: [
      { month: 'Jan', revenue: 18500 },
      { month: 'Feb', revenue: 19200 },
      { month: 'Mar', revenue: 20800 },
      { month: 'Apr', revenue: 21500 },
      { month: 'May', revenue: 23200 },
      { month: 'Jun', revenue: 24500 }
    ]
  },

  // Additional context for rich dashboard
  organizationInfo: {
    name: 'TeleConnect Solutions',
    industry: 'Telecommunications',
    founded: '2019',
    employees: '50-100',
    plan: 'Enterprise',
    nextBillingDate: new Date(Date.now() + 15 * 24 * 60 * 60 * 1000).toISOString()
  }
}