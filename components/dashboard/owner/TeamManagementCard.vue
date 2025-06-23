<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Team Management</h3>
      <button 
        @click="$emit('manage-team')"
        class="text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
      >
        Manage
      </button>
    </div>
    
    <div v-if="loading" class="text-center py-6">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else-if="teamMembers.length > 0" class="space-y-4">
      <!-- Team Members List -->
      <div class="space-y-3">
        <TeamMemberItem
          v-for="member in displayMembers"
          :key="member.id"
          :member="member"
          @view-details="$emit('view-member', $event)"
        />
      </div>
      
      <!-- Team Summary -->
      <div class="pt-4 border-t border-white/10">
        <div class="grid grid-cols-2 gap-4 text-center">
          <div>
            <p class="text-lg font-semibold text-white">{{ teamMembers.length }}</p>
            <p class="text-white/60 text-xs">Team Members</p>
          </div>
          <div>
            <p class="text-lg font-semibold text-white">{{ avgPerformance }}%</p>
            <p class="text-white/60 text-xs">Avg Performance</p>
          </div>
        </div>
      </div>
      
      <!-- Invite Button -->
      <button 
        @click="$emit('invite-member')"
        class="w-full mt-4 py-2 px-4 bg-pink-500/20 hover:bg-pink-500/30 text-pink-400 rounded-lg text-sm font-medium transition-colors flex items-center justify-center space-x-2"
      >
        <UserPlusIcon class="w-4 h-4" />
        <span>Invite Team Member</span>
      </button>
    </div>
    
    <div v-else class="text-center py-6">
      <div class="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center mx-auto mb-3">
        <UsersIcon class="w-6 h-6 text-white/40" />
      </div>
      <p class="text-white font-medium mb-2">Build Your Team</p>
      <p class="text-white/60 text-sm mb-4">Invite team members to help manage carrier onboarding</p>
      <button 
        @click="$emit('invite-member')"
        class="px-4 py-2 bg-pink-500 hover:bg-pink-600 text-white rounded-lg text-sm font-medium transition-colors"
      >
        Invite First Member
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { UserPlusIcon, UsersIcon } from '@heroicons/vue/24/outline'
import TeamMemberItem from '~/components/dashboard/shared/TeamMemberItem.vue'

interface TeamMember {
  id: string
  name: string
  role: string
  avatar?: string
  assignedCarriers: number
  performance: number
  status: 'active' | 'inactive' | 'pending'
}

interface Props {
  teamMembers: TeamMember[]
  loading: boolean
  maxDisplay?: number
}

const props = withDefaults(defineProps<Props>(), {
  maxDisplay: 4
})

defineEmits<{
  'manage-team': []
  'invite-member': []
  'view-member': [member: TeamMember]
}>()

const displayMembers = computed(() => 
  props.teamMembers.slice(0, props.maxDisplay)
)

const avgPerformance = computed(() => {
  if (props.teamMembers.length === 0) return 0
  const total = props.teamMembers.reduce((sum, member) => sum + member.performance, 0)
  return Math.round(total / props.teamMembers.length)
})
</script>