/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
    "./error.vue"
  ],
  theme: {
    extend: {
      colors: {
        primary: '#91C4F2',       // Soft blue
        accent: '#A2E5C1',        // Mint green
        warning: '#F27272',       // Coral red
        textPrimary: '#1A1A1A',   // Almost black
        textSecondary: '#8E9BAE', // Cool gray
        bgLight: '#F2F6FA',       // Light dashboard background
        bgCard: '#E8EEF5',        // Light gray-blue for cards
        darkBase: '#131A20',      // Optional dark mode base
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        heading: ['Manrope', 'sans-serif'],
        inter: ['Inter', 'sans-serif'],
      },
      borderRadius: {
        xl: '1rem',
        '2xl': '1.5rem',
      },
      boxShadow: {
        card: '0 4px 20px rgba(0, 0, 0, 0.05)',
        subtle: '0 2px 8px rgba(0, 0, 0, 0.03)',
      },
    },
  },
  plugins: [],
}