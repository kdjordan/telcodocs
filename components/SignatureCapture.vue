<template>
  <div class="signature-capture">
    <div class="mb-3 flex justify-between items-center">
      <label class="text-sm font-medium text-gray-700">
        Digital Signature
      </label>
      <button
        @click="clearSignature"
        type="button"
        class="text-sm text-gray-500 hover:text-gray-700 flex items-center gap-1"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1-1H8a1 1 0 00-1 1v3M4 7h16" />
        </svg>
        Clear
      </button>
    </div>
    
    <div class="border-2 border-gray-300 rounded-lg overflow-hidden bg-white">
      <canvas
        ref="canvas"
        @mousedown="startDrawing"
        @mousemove="draw"
        @mouseup="stopDrawing"
        @mouseleave="stopDrawing"
        @touchstart="handleTouch"
        @touchmove="handleTouch"
        @touchend="stopDrawing"
        class="block cursor-crosshair"
        :width="canvasWidth"
        :height="canvasHeight"
      />
    </div>
    
    <div class="mt-2 flex justify-between items-center text-xs text-gray-500">
      <span>Sign above with your mouse or finger</span>
      <span v-if="signatureData">✓ Signature captured</span>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  fieldId: string
  value?: string
}>()

const emit = defineEmits<{
  'update': [signatureData: string]
}>()

const canvas = ref<HTMLCanvasElement>()
const isDrawing = ref(false)
const signatureData = ref(props.value || '')

const canvasWidth = 400
const canvasHeight = 200

let ctx: CanvasRenderingContext2D | null = null

onMounted(() => {
  if (canvas.value) {
    ctx = canvas.value.getContext('2d')
    if (ctx) {
      ctx.strokeStyle = '#000000'
      ctx.lineWidth = 2
      ctx.lineCap = 'round'
      ctx.lineJoin = 'round'
      
      // Load existing signature if provided
      if (props.value) {
        loadSignature(props.value)
      }
    }
  }
})

const startDrawing = (event: MouseEvent) => {
  if (!ctx) return
  
  isDrawing.value = true
  const rect = canvas.value!.getBoundingClientRect()
  const x = event.clientX - rect.left
  const y = event.clientY - rect.top
  
  ctx.beginPath()
  ctx.moveTo(x, y)
}

const draw = (event: MouseEvent) => {
  if (!isDrawing.value || !ctx) return
  
  const rect = canvas.value!.getBoundingClientRect()
  const x = event.clientX - rect.left
  const y = event.clientY - rect.top
  
  ctx.lineTo(x, y)
  ctx.stroke()
}

const stopDrawing = () => {
  if (!isDrawing.value) return
  
  isDrawing.value = false
  captureSignature()
}

const handleTouch = (event: TouchEvent) => {
  event.preventDefault()
  
  const touch = event.touches[0]
  const mouseEvent = new MouseEvent(event.type === 'touchstart' ? 'mousedown' : 
                                   event.type === 'touchmove' ? 'mousemove' : 'mouseup', {
    clientX: touch.clientX,
    clientY: touch.clientY
  })
  
  if (event.type === 'touchstart') {
    startDrawing(mouseEvent)
  } else if (event.type === 'touchmove') {
    draw(mouseEvent)
  }
}

const captureSignature = () => {
  if (!canvas.value) return
  
  // Convert canvas to base64 data URL
  const dataURL = canvas.value.toDataURL('image/png')
  signatureData.value = dataURL
  emit('update', dataURL)
}

const clearSignature = () => {
  if (!ctx || !canvas.value) return
  
  ctx.clearRect(0, 0, canvas.value.width, canvas.value.height)
  signatureData.value = ''
  emit('update', '')
}

const loadSignature = (dataURL: string) => {
  if (!ctx || !canvas.value) return
  
  const img = new Image()
  img.onload = () => {
    ctx!.clearRect(0, 0, canvas.value!.width, canvas.value!.height)
    ctx!.drawImage(img, 0, 0)
  }
  img.src = dataURL
}
</script>

<style scoped>
.signature-capture {
  touch-action: none;
}
</style>