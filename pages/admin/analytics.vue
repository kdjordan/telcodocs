<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-6">Platform Analytics</h1>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
      <Card>
        <template #content>
          <div class="flex flex-col">
            <span class="text-3xl font-bold">{{ stats.totalTenants }}</span>
            <span class="text-gray-600">Total Tenants</span>
            <span class="text-sm text-green-600 mt-2">
              <i class="pi pi-arrow-up text-xs"></i> {{ stats.tenantsGrowth }}% this month
            </span>
          </div>
        </template>
      </Card>

      <Card>
        <template #content>
          <div class="flex flex-col">
            <span class="text-3xl font-bold">{{ stats.totalUsers }}</span>
            <span class="text-gray-600">Total Users</span>
            <span class="text-sm text-green-600 mt-2">
              <i class="pi pi-arrow-up text-xs"></i> {{ stats.usersGrowth }}% this month
            </span>
          </div>
        </template>
      </Card>

      <Card>
        <template #content>
          <div class="flex flex-col">
            <span class="text-3xl font-bold">{{ stats.totalApplications }}</span>
            <span class="text-gray-600">Total Applications</span>
            <span class="text-sm text-green-600 mt-2">
              <i class="pi pi-arrow-up text-xs"></i> {{ stats.applicationsGrowth }}% this month
            </span>
          </div>
        </template>
      </Card>

      <Card>
        <template #content>
          <div class="flex flex-col">
            <span class="text-3xl font-bold">{{ stats.completionRate }}%</span>
            <span class="text-gray-600">Completion Rate</span>
            <span class="text-sm text-gray-600 mt-2">
              Avg. time: {{ stats.avgCompletionTime }} days
            </span>
          </div>
        </template>
      </Card>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <Card>
        <template #title>
          <div class="flex justify-between items-center">
            <span>Tenant Activity</span>
            <Dropdown v-model="tenantChartPeriod" :options="periodOptions" class="w-32" />
          </div>
        </template>
        <template #content>
          <Chart type="line" :data="tenantChartData" :options="chartOptions" class="h-64" />
        </template>
      </Card>

      <Card>
        <template #title>
          <div class="flex justify-between items-center">
            <span>Application Status</span>
            <Dropdown v-model="applicationChartPeriod" :options="periodOptions" class="w-32" />
          </div>
        </template>
        <template #content>
          <Chart type="doughnut" :data="applicationChartData" :options="doughnutOptions" class="h-64" />
        </template>
      </Card>
    </div>

    <Card class="mt-6">
      <template #title>Top Performing Tenants</template>
      <template #content>
        <DataTable :value="topTenants" showGridlines>
          <Column field="name" header="Tenant Name" sortable></Column>
          <Column field="applications" header="Applications" sortable></Column>
          <Column field="completionRate" header="Completion Rate" sortable>
            <template #body="slotProps">
              <ProgressBar :value="slotProps.data.completionRate" :showValue="true" />
            </template>
          </Column>
          <Column field="avgTime" header="Avg. Completion Time" sortable></Column>
          <Column field="revenue" header="Revenue" sortable>
            <template #body="slotProps">
              ${{ slotProps.data.revenue.toLocaleString() }}
            </template>
          </Column>
        </DataTable>
      </template>
    </Card>
  </div>
</template>

<script setup>
const { $supabase } = useNuxtApp()

const stats = ref({
  totalTenants: 0,
  totalUsers: 0,
  totalApplications: 0,
  completionRate: 0,
  avgCompletionTime: 0,
  tenantsGrowth: 0,
  usersGrowth: 0,
  applicationsGrowth: 0
})

const topTenants = ref([])
const tenantChartPeriod = ref('30d')
const applicationChartPeriod = ref('30d')

const periodOptions = [
  { label: 'Last 7 days', value: '7d' },
  { label: 'Last 30 days', value: '30d' },
  { label: 'Last 90 days', value: '90d' },
  { label: 'Last year', value: '1y' }
]

const tenantChartData = ref({
  labels: [],
  datasets: [{
    label: 'New Tenants',
    data: [],
    borderColor: '#3B82F6',
    tension: 0.4
  }]
})

const applicationChartData = ref({
  labels: ['Pending', 'In Progress', 'Completed', 'Rejected'],
  datasets: [{
    data: [30, 45, 20, 5],
    backgroundColor: ['#FFA726', '#66BB6A', '#42A5F5', '#EF5350']
  }]
})

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: false
    }
  }
}

const doughnutOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'right'
    }
  }
}

onMounted(async () => {
  await fetchStats()
  await fetchTopTenants()
  generateChartData()
})

const fetchStats = async () => {
  try {
    // Fetch tenant count
    const { count: tenantCount } = await $supabase
      .from('tenants')
      .select('*', { count: 'exact', head: true })
    
    // Fetch user count
    const { count: userCount } = await $supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
    
    // Mock data for demo - replace with actual queries
    stats.value = {
      totalTenants: tenantCount || 0,
      totalUsers: userCount || 0,
      totalApplications: 156,
      completionRate: 78,
      avgCompletionTime: 3.5,
      tenantsGrowth: 12,
      usersGrowth: 25,
      applicationsGrowth: 18
    }
  } catch (error) {
    console.error('Failed to fetch stats:', error)
  }
}

const fetchTopTenants = async () => {
  // Mock data for demo - replace with actual queries
  topTenants.value = [
    { name: 'TelecomCo Alpha', applications: 45, completionRate: 89, avgTime: '2.5 days', revenue: 15600 },
    { name: 'VoIP Solutions Inc', applications: 38, completionRate: 92, avgTime: '3.1 days', revenue: 12400 },
    { name: 'Global Telco Ltd', applications: 32, completionRate: 75, avgTime: '4.2 days', revenue: 10800 },
    { name: 'NextGen Communications', applications: 28, completionRate: 81, avgTime: '3.8 days', revenue: 9200 },
    { name: 'CloudVoice Systems', applications: 24, completionRate: 95, avgTime: '2.2 days', revenue: 8400 }
  ]
}

const generateChartData = () => {
  // Mock chart data - replace with actual data
  const days = 30
  const labels = []
  const data = []
  
  for (let i = days; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    labels.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }))
    data.push(Math.floor(Math.random() * 5) + 1)
  }
  
  tenantChartData.value.labels = labels
  tenantChartData.value.datasets[0].data = data
}

watch([tenantChartPeriod, applicationChartPeriod], () => {
  generateChartData()
})
</script>