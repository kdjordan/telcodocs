<template>
  <div class="signature-capture">
    <div class="mb-2 flex justify-between items-center">
      <span class="text-sm text-gray-600">Sign below</span>
      <button
        type="button"
        @click="clearSignature"
        class="text-sm text-blue-600 hover:text-blue-700"
      >
        Clear
      </button>
    </div>
    
    <canvas
      ref="canvas"
      :width="canvasWidth"
      :height="canvasHeight"
      class="border border-gray-300 rounded bg-white cursor-crosshair"
      @mousedown="startDrawing"
      @mousemove="draw"
      @mouseup="stopDrawing"
      @mouseleave="stopDrawing"
      @touchstart="handleTouchStart"
      @touchmove="handleTouchMove"
      @touchend="stopDrawing"
    />
    
    <div v-if="!hasSignature" class="mt-2 text-sm text-gray-500 text-center">
      Draw your signature above
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  fieldId: string
}>()

const emit = defineEmits<{
  update: [signatureData: string]
}>()

const canvas = ref<HTMLCanvasElement | null>(null)
const isDrawing = ref(false)
const hasSignature = ref(false)
const canvasWidth = 400
const canvasHeight = 200

let ctx: CanvasRenderingContext2D | null = null
let lastX = 0
let lastY = 0

onMounted(() => {
  if (canvas.value) {
    ctx = canvas.value.getContext('2d')
    if (ctx) {
      ctx.strokeStyle = '#000000'
      ctx.lineWidth = 2
      ctx.lineCap = 'round'
      ctx.lineJoin = 'round'
    }
  }
})

const getCoordinates = (event: MouseEvent | Touch) => {
  if (!canvas.value) return { x: 0, y: 0 }
  
  const rect = canvas.value.getBoundingClientRect()
  return {
    x: event.clientX - rect.left,
    y: event.clientY - rect.top
  }
}

const startDrawing = (event: MouseEvent) => {
  isDrawing.value = true
  hasSignature.value = true
  
  const coords = getCoordinates(event)
  lastX = coords.x
  lastY = coords.y
}

const draw = (event: MouseEvent) => {
  if (!isDrawing.value || !ctx) return
  
  const coords = getCoordinates(event)
  
  ctx.beginPath()
  ctx.moveTo(lastX, lastY)
  ctx.lineTo(coords.x, coords.y)
  ctx.stroke()
  
  lastX = coords.x
  lastY = coords.y
}

const stopDrawing = () => {
  if (isDrawing.value && canvas.value) {
    isDrawing.value = false
    
    // Convert canvas to base64 and emit
    const signatureData = canvas.value.toDataURL()
    emit('update', signatureData)
  }
}

const handleTouchStart = (event: TouchEvent) => {
  event.preventDefault()
  const touch = event.touches[0]
  const mouseEvent = new MouseEvent('mousedown', {
    clientX: touch.clientX,
    clientY: touch.clientY
  })
  startDrawing(mouseEvent)
}

const handleTouchMove = (event: TouchEvent) => {
  event.preventDefault()
  const touch = event.touches[0]
  const mouseEvent = new MouseEvent('mousemove', {
    clientX: touch.clientX,
    clientY: touch.clientY
  })
  draw(mouseEvent)
}

const clearSignature = () => {
  if (canvas.value && ctx) {
    ctx.clearRect(0, 0, canvasWidth, canvasHeight)
    hasSignature.value = false
    emit('update', '')
  }
}
</script>

<style scoped>
.signature-capture {
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}
</style>